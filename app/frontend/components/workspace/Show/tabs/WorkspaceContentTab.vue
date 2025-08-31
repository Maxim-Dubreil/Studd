<template>
  <div class="p-4 flex justify-center">
    <div class="rounded-xl border bg-card p-6 shadow-sm max-w-7xl w-full">
      <h2 class="text-2xl font-semibold mb-4">Content of your Workspace</h2>
      <p class="text-muted-foreground mb-4">Generations will be based on that content</p>

      <div v-if="workspace.raw_content" class="space-y-6">
        <div class="bg-muted rounded-lg p-4 border">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div class="flex items-center gap-3">
              <div class="flex-shrink-0">
                <Icon 
                  :name="workspace.raw_content.content_type === 'text/plain' ? 'file-text' : 'file'" 
                  class="h-5 w-5 text-primary" 
                />
              </div>
              <div>
                <span class="text-sm text-muted-foreground">Content type</span>
                <p class="font-medium text-foreground">
                  {{ workspace.raw_content.content_type === 'text/plain' ? 'Plain Text' : 'File' }}
                  <span v-if="workspace.raw_content.content_type !== 'text/plain'" class="text-sm text-muted-foreground">
                    ({{ getFileTypeLabel(workspace.raw_content.content_type) }})
                  </span>
                </p>
              </div>
            </div>

            <div v-if="workspace.raw_content.file_name" class="flex items-center gap-3">
              <div class="flex-shrink-0">
                <Icon name="file" class="h-5 w-5 text-primary" />
              </div>
              <div>
                <span class="text-sm text-muted-foreground">File name</span>
                <p class="font-medium text-foreground">{{ workspace.raw_content.file_name }}</p>
              </div>
            </div>
          </div>
        </div>

        <div v-if="workspace.raw_content.content && workspace.raw_content.content_type === 'text/plain'" class="mt-6">
          <h3 class="text-lg font-medium mb-2">Preview of the content:</h3>
          <div class="rounded-md bg-muted p-4 overflow-auto max-h-[400px]">
            <div class="text-sm whitespace-pre-wrap break-words leading-relaxed">{{ workspace.raw_content.content }}</div>
          </div>
        </div>

        <div v-if="workspace.raw_content.content_type !== 'text/plain'" class="mt-6">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-lg font-medium">Preview of the file</h3>
            <a 
              v-if="workspace.raw_content.file_url"
              :href="workspace.raw_content.file_url" 
              target="_blank"
              class="inline-flex items-center gap-2 px-3 py-2 text-sm bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors">
              <Icon name="external-link" class="h-4 w-4" />
              Open in full screen
            </a>
          </div>
          
          <div class="rounded-lg border overflow-hidden bg-card shadow-sm">
            <div v-if="isPDF(workspace.raw_content.content_type) && workspace.raw_content.file_url">
              <iframe 
                :src="workspace.raw_content.file_url + '#view=FitH'"
                class="w-full aspect-[4/3] border-0"
                title="PDF preview">
              </iframe>
            </div>
            
            <div v-else-if="workspace.raw_content.file_url" class="flex flex-col items-center justify-center p-12 text-muted-foreground">
              <Icon name="file" class="h-16 w-16 mb-4 text-muted-foreground/50" />
              <h4 class="text-lg font-medium mb-2 text-foreground">Preview not available</h4>
              <p class="text-center mb-6 text-muted-foreground">
                This file type cannot be previewed in the browser.
              </p>
              <a 
                :href="workspace.raw_content.file_url" 
                target="_blank"
                class="inline-flex items-center gap-2 px-4 py-2 bg-muted hover:bg-muted/80 text-foreground rounded-md transition-colors">
                <Icon name="download" class="h-4 w-4" />
                Download the file
              </a>
            </div>
            
            <div v-else class="flex flex-col items-center justify-center p-12 text-destructive">
              <Icon name="alert-triangle" class="h-16 w-16 mb-4 text-destructive/50" />
              <h4 class="text-lg font-medium mb-2">Error loading the file</h4>
              <p class="text-center text-destructive/80">
                Unable to load the file. Please contact support.
              </p>
            </div>
          </div>
        </div>
      </div>

      <div v-else class="flex items-center gap-2 text-muted-foreground justify-center p-8">
        <Icon name="alert-triangle" class="h-6 w-6" />
        <span class="text-lg">No content has been added to this workspace</span>
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
    file_url?: string | null;
  }

  interface Workspace {
    id: number;
    name: string;
    raw_content?: RawContent | null;
  }

  defineProps<{
    workspace: Workspace;
  }>();

  // Fonction pour vérifier si le fichier est un PDF
  const isPDF = (contentType?: string | null): boolean => {
    return contentType === 'application/pdf';
  };

  // Fonction pour obtenir un label lisible du type de fichier
  const getFileTypeLabel = (contentType?: string | null): string => {
    if (!contentType) return 'Unknown';
    
    const typeMap: Record<string, string> = {
      'application/pdf': 'PDF',
      'image/jpeg': 'JPEG Image',
      'image/png': 'PNG Image',
      'image/gif': 'GIF Image',
      'text/plain': 'Text',
      'application/msword': 'Word Document',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'Word Document',
      'application/vnd.ms-excel': 'Excel Spreadsheet',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'Excel Spreadsheet',
    };
    
    return typeMap[contentType] || contentType.split('/')[1]?.toUpperCase() || 'File';
  };
</script>