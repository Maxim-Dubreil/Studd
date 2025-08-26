<template>
  <div
    v-if="showModal"
    class="fixed inset-0 z-60 flex items-center justify-center bg-black/30 backdrop-blur-sm"
  >
    <div class="bg-card text-foreground w-full max-w-lg rounded-lg border p-6 shadow-lg">
      <h2 class="mb-6 text-xl font-semibold">{{ modalTitle }}</h2>

      <div class="space-y-4">
        <div>
          <Label class="text-muted-foreground">Ajouter un fichier</Label>
          <Input type="file" @change="handleFileUpload" class="mt-1" ref="fileInput" />
        </div>

        <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <span class="w-full border-t" />
          </div>
          <div class="relative flex justify-center text-xs uppercase">
            <span class="bg-card text-muted-foreground px-2">Ou</span>
          </div>
        </div>

        <div>
          <Label class="text-muted-foreground">Collez votre texte ici</Label>
          <Textarea v-model="editableTextContent" rows="10" class="mt-1"></Textarea>
        </div>
      </div>

      <div class="mt-8 flex justify-end space-x-2">
        <Button type="button" variant="secondary" @click="closeModal" class="cursor-pointer">
          Annuler
        </Button>
        <Button
          type="button"
          @click="submitContent"
          class="cursor-pointer"
          :disabled="!isSubmittable"
        >
          {{ submitButtonText }}
        </Button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import Button from '@/components/ui/button/Button.vue';
  import { Input } from '@/components/ui/input';
  import { Label } from '@/components/ui/label';
  import { Textarea } from '@/components/ui/textarea';
  import { computed, defineEmits, defineExpose, defineProps, ref, watch } from 'vue';

  interface Workspace {
    id: number;
    name: string;
  }

  interface RawContent {
    id: number;
    content?: string | null;
    content_type?: string | null;
    file_name?: string | null;
  }

  const props = defineProps<{
    workspace: Workspace;
    rawContent?: RawContent | null;
  }>();

  const emit = defineEmits(['content-updated']);

  const showModal = ref(false);
  const editableTextContent = ref('');
  const newFile = ref<File | null>(null);
  const fileInput = ref<HTMLInputElement | null>(null);

  const isEditing = computed(() => !!props.rawContent);

  const modalTitle = computed(() =>
    isEditing.value
      ? `Modifier le contenu de "${props.workspace.name}"`
      : `Ajouter du contenu à "${props.workspace.name}"`
  );

  const submitButtonText = computed(() =>
    isEditing.value ? 'Enregistrer les modifications' : 'Ajouter le contenu'
  );

  const isSubmittable = computed(() => {
    return newFile.value !== null || editableTextContent.value.trim() !== '';
  });

  watch(
    () => props.rawContent,
    (newVal: RawContent | null | undefined) => {
      if (newVal && newVal.content_type === 'text/plain') {
        editableTextContent.value = newVal.content || '';
      } else {
        editableTextContent.value = '';
      }
      newFile.value = null;
      if (fileInput.value) fileInput.value.value = '';
    }
  );

  const openModal = () => {
    showModal.value = true;
  };
  const closeModal = () => {
    showModal.value = false;
  };

  const handleFileUpload = (event: Event) => {
    const target = event.target as HTMLInputElement;
    if (target.files && target.files.length > 0) {
      newFile.value = target.files[0];
      editableTextContent.value = '';
    }
  };

  watch(editableTextContent, (newVal: string) => {
    if (newVal.trim() !== '' && newFile.value) {
      newFile.value = null;
      if (fileInput.value) fileInput.value.value = '';
    }
  });

  const submitContent = async () => {
    if (!isSubmittable.value) {
      alert('Veuillez fournir un fichier ou du texte.');
      return;
    }

    const formData = new FormData();

    if (newFile.value) {
      formData.append('raw_content[file]', newFile.value);
      formData.append('raw_content[content]', '');
    } else {
      formData.append('raw_content[content]', editableTextContent.value);
    }

    const token = document.querySelector('[name="csrf-token"]')?.getAttribute('content');
    const url = isEditing.value
      ? `/raw_contents/${props.rawContent?.id}`
      : `/raw_contents?workspace_id=${props.workspace.id}`;
    const method = isEditing.value ? 'PATCH' : 'POST';

    if (isEditing.value) {
      formData.append('_method', 'PATCH');
    } else {
      formData.append('workspace_id', props.workspace.id.toString());
    }

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'X-CSRF-Token': token || '' },
        body: formData,
      });

      if (response.ok) {
        const updatedContent = await response.json();
        emit('content-updated', updatedContent);
        closeModal();
      } else {
        console.error('Erreur lors de la soumission du contenu');
      }
    } catch (error) {
      console.error('Erreur:', error);
    }
  };

  defineExpose({ openModal });
</script>
