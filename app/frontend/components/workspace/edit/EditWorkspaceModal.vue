<script setup lang="ts">
import Button from '@/components/ui/button/Button.vue';
import Icon from '@/components/ui/icon/Icon.vue';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { useIconResolver } from '@/composables/useIconResolver';
import { computed, onMounted, ref } from 'vue';

interface IconInfo {
  id: number;
  name: string;
  path: string;
}

interface Workspace {
  id: number;
  name: string;
  icon?: IconInfo;
  created_at: string;
  updated_at: string;
  raw_content?: {
    content: string | null;
    content_type: string | null;
    file_name: string | null;
  };
}

const props = defineProps<{
  workspace: Workspace;
}>();
const emit = defineEmits([
  'close',
  'workspace-updated',
  'workspace-deleted',
  'open-content-modal',
]);

const confirmingDelete = ref(false);
const initialName = ref(props.workspace.name);
const editableName = ref(props.workspace.name);
const selectedIconId = ref<number | null>(props.workspace.icon?.id || null);
const availableIcons = ref<IconInfo[]>([]);

const { getIconUrl } = useIconResolver();

const isChanged = computed(() => {
  return (
    editableName.value !== props.workspace.name ||
    selectedIconId.value !== (props.workspace.icon?.id || null)
  );
});

const fetchIcons = async () => {
  try {
    const response = await fetch('/icons');
    if (response.ok) {
      availableIcons.value = await response.json();
    } else {
      console.error('Error loading icons');
    }
  } catch (error) {
    console.error('Error:', error);
  }
};

const handleUpdate = async () => {
  if (!isChanged.value) return;

  const token = document.querySelector('[name="csrf-token"]')?.getAttribute('content');
  const payload = {
    workspace: {
      name: editableName.value,
      icon_id: selectedIconId.value,
    },
  };

  try {
    const response = await fetch(`/workspaces/${props.workspace.id}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': token || '',
      },
      body: JSON.stringify(payload),
    });

    if (response.ok) {
      const updatedWorkspace = await response.json();
      emit('workspace-updated', updatedWorkspace);
    } else {
      console.error('Error updating workspace');
    }
  } catch (error) {
    console.error('Error:', error);
  }
};

const handleDelete = async () => {
  const token = document.querySelector('[name="csrf-token"]')?.getAttribute('content');

  try {
    const response = await fetch(`/workspaces/${props.workspace.id}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': token || '',
      },
    });

    if (response.ok) {
      emit('workspace-deleted', props.workspace.id);
    } else {
      console.error('Error deleting workspace');
    }
  } catch (error) {
    console.error('Error:', error);
  }
};

const closeModal = () => emit('close');

onMounted(() => {
  fetchIcons();
});
</script>

<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/30 backdrop-blur-sm">
    <div class="bg-card text-foreground w-full max-w-lg rounded-lg border p-6 shadow-lg">
      <h2 class="mb-6 text-xl font-semibold">Change "{{ initialName }}"</h2>

      <form @submit.prevent="handleUpdate">
        <div class="space-y-6">
          <div>
            <Label for="workspace-name-edit" class="text-muted-foreground">
              Workspace Name
            </Label>
            <Input id="workspace-name-edit" v-model="editableName" type="text" class="mt-1" required />
          </div>

          <div>
            <Label class="text-muted-foreground">Icon</Label>
            <div class="grid grid-cols-6 gap-2 pt-2">
              <div v-for="icon in availableIcons" :key="icon.id"
                class="flex cursor-pointer items-center justify-center rounded-lg p-2" :class="{
                  'bg-primary/10 ring-primary ring-2': selectedIconId === icon.id,
                  'hover:bg-accent': selectedIconId !== icon.id,
                }" @click="selectedIconId = icon.id">
                <img :src="getIconUrl(icon.path)" :alt="icon.name" class="h-12 w-12 rounded-md object-contain" />
              </div>
            </div>
          </div>

          <div>
            <Label class="text-muted-foreground">Content</Label>
            <div class="bg-background/50 mt-1 flex items-center justify-between rounded-lg border p-4">
              <div v-if="workspace.raw_content">
                <p v-if="workspace.raw_content.content_type === 'text/plain'">
                  <strong class="font-medium">Type:</strong>
                  Text
                  <span class="text-muted-foreground ml-2 text-sm">
                    ({{ workspace.raw_content.content?.length || 0 }} characters)
                  </span>
                </p>
                <p v-else-if="workspace.raw_content.content_type?.startsWith('image/')">
                  <strong class="font-medium">Type:</strong>
                  Image
                  <span class="text-muted-foreground ml-2 text-sm">
                    ({{ workspace.raw_content.file_name }})
                  </span>
                </p>
                <p v-else>
                  <strong class="font-medium">Type:</strong>
                  Files
                  <span class="text-muted-foreground ml-2 text-sm">
                    ({{ workspace.raw_content.file_name }})
                  </span>
                </p>
              </div>
              <p v-else class="text-muted-foreground italic">
                No content has been added.
              </p>

              <button @click.prevent="emit('open-content-modal', workspace.raw_content)" type="button"
                class="hover:bg-accent rounded-md p-2">
                <Icon :name="workspace.raw_content ? 'edit' : 'plus'" class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>

        <div class="mt-8 flex justify-end space-x-2">
          <Button type="button" variant="secondary" @click="closeModal" class="cursor-pointer">
            Cancel
          </Button>
          <Button type="submit" :disabled="!isChanged" class="cursor-pointer">Save</Button>
        </div>
      </form>

      <div class="border-destructive/20 mt-6 border-t pt-6 text-center">
        <Button variant="destructive" @click="confirmingDelete = true" class="cursor-pointer">
          Delete the Workspace
        </Button>
      </div>

      <div v-if="confirmingDelete"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm">
        <div class="bg-card border-destructive w-full max-w-sm rounded-lg border p-6 shadow-xl">
          <h3 class="text-destructive text-lg font-semibold">Are you sure?</h3>
          <p class="text-muted-foreground mt-2">
            This action is irreversible and will delete the workspace and all its content.
          </p>
          <div class="mt-6 flex justify-end space-x-2">
            <Button variant="secondary" @click="confirmingDelete = false" class="cursor-pointer">
              Cancel
            </Button>
            <Button variant="destructive" @click="handleDelete" class="cursor-pointer">
              Yes, delete
            </Button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
