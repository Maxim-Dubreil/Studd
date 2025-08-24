<template>
  <div class="p-4 flex justify-center">
    <div class="rounded-xl border bg-card p-6 shadow-sm max-w-7xl w-full">
      <h2 class="text-2xl font-semibold mb-4">Contenu du workspace</h2>

      <div v-if="workspace.raw_content" class="space-y-4">
        <div class="flex items-center gap-2">
          <Icon name="file-text" class="h-5 w-5 text-indigo-500" />
          <span class="font-medium">Type de contenu:</span>
          <span>{{ workspace.raw_content.content_type === 'text/plain' ? 'Texte' : 'Fichier' }}</span>
        </div>

        <div v-if="workspace.raw_content.file_name" class="flex items-center gap-2">
          <Icon name="file" class="h-5 w-5 text-indigo-500" />
          <span class="font-medium">Nom du fichier:</span>
          <span>{{ workspace.raw_content.file_name }}</span>
        </div>

        <div v-if="workspace.raw_content.content" class="mt-6">
          <h3 class="text-lg font-medium mb-2">Aperçu du contenu:</h3>
          <div class="rounded-md bg-muted p-4 overflow-auto max-h-[400px]">
            <pre class="text-sm">{{ workspace.raw_content.content }}</pre>
          </div>
        </div>
      </div>

      <div v-else class="flex items-center gap-2 text-amber-500 justify-center p-8">
        <Icon name="alert-triangle" class="h-6 w-6" />
        <span class="text-lg">Aucun contenu n'a été ajouté à ce workspace</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
  import Icon from '@/components/ui/icon/Icon.vue';

  interface RawContent {
    id: number;
    content?: string | null;
    content_type?: string | null;
    file_name?: string | null;
  }

  interface Workspace {
    id: number;
    name: string;
    raw_content?: RawContent | null;
  }

  defineProps<{
    workspace: Workspace;
  }>();
</script>