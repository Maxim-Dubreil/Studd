<template>
  <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/20 backdrop-blur-sm">
    <div class="bg-card w-full max-w-md rounded-lg border p-6 shadow-lg">
      <h2 class="text-foreground mb-4 text-lg font-semibold">Create a new workspace</h2>
      <form @submit.prevent="createWorkspace">
        <div class="mb-4">
          <Label for="workspace-name" class="text-muted-foreground">
            Workspace Name
          </Label>
          <Input id="workspace-name" v-model="name" type="text" class="mt-1" placeholder="Ex: Physique-Chimie"
            required />
        </div>

        <div class="mb-4">
          <Label class="text-muted-foreground">Choose an icon</Label>
          <div class="grid grid-cols-5 gap-2 pt-2">
            <div v-for="icon in icons" :key="icon.id"
              class="flex cursor-pointer flex-col items-center justify-center space-y-1 rounded-lg p-2" :class="{
                'bg-primary/10 ring-primary ring-2': selectedIconId === icon.id,
                'hover:bg-accent': selectedIconId !== icon.id,
              }" @click="selectedIconId = icon.id">
              <img :src="getIconUrl(icon.path)" :alt="icon.name" class="h-12 w-12 rounded-md object-contain" />
            </div>
          </div>
        </div>

        <div class="mt-6 flex justify-end space-x-2">
          <BaseButton type="button" variant="secondary" @click="closeModal">Cancel</BaseButton>
          <BaseButton type="submit">Create</BaseButton>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import BaseButton from '@/components/ui/button/Button.vue';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { useIconResolver } from '@/composables/useIconResolver';
import { ref } from 'vue';

interface Icon {
  id: number;
  name: string;
  path: string;
}

const { getIconUrl } = useIconResolver();

const showModal = ref(false);
const name = ref('');
const icons = ref<Icon[]>([]);
const selectedIconId = ref<number | null>(null);

const emit = defineEmits(['workspace-created']);

const fetchIcons = async () => {
  try {
    const response = await fetch('/icons');
    if (response.ok) {
      icons.value = await response.json();
    } else {
      console.error('Erreur lors du chargement des icônes');
    }
  } catch (error) {
    console.error('Erreur:', error);
  }
};

const openModal = () => {
  showModal.value = true;
  fetchIcons();
};

const closeModal = () => {
  showModal.value = false;
  name.value = '';
  selectedIconId.value = null;
};

const createWorkspace = async () => {
  if (name.value.trim() === '' || !selectedIconId.value) {
    alert('Veuillez renseigner un nom et sélectionner une icône.');
    return;
  }

  try {
    const token = document.querySelector('[name="csrf-token"]')?.getAttribute('content');
    if (!token) {
      console.error('CSRF token not found!');
      return;
    }

    const response = await fetch('/workspaces', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': token,
      },
      body: JSON.stringify({ workspace: { name: name.value, icon_id: selectedIconId.value } }),
    });

    if (response.ok) {
      const newWorkspace = await response.json();
      emit('workspace-created', newWorkspace);
      closeModal();
    } else {
      console.error('Error creating workspace');
    }
  } catch (error) {
    console.error('Error:', error);
  }
};

defineExpose({
  openModal,
});
</script>
