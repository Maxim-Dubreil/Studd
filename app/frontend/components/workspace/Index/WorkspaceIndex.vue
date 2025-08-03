<script setup lang="ts">
  import { computed, nextTick, ref } from 'vue';

  import AddContentModal from '@/components/rawContent/AddContentModal.vue';
  import { Button } from '@/components/ui/button';
  import { Icon } from '@/components/ui/icon';
  import CreateWorkspaceModal from '@/components/workspace/create/CreateWorkspaceModal.vue';
  import EditWorkspaceModal from '@/components/workspace/edit/EditWorkspaceModal.vue';
  import AppLayout from '../../layout/AppLayout.vue';
  import WorkspaceIndexCard from './WorkspaceIndexCard.vue';

  interface Icon {
    id: number;
    name: string;
    path: string;
  }

  interface RawContent {
    id: number;
    content?: string | null;
    content_type?: string | null;
    file_name?: string | null;
  }

  interface Workspace {
    id: number;
    name: string;
    icon?: Icon;
    created_at: string;
    updated_at: string;
    raw_content?: RawContent | null;
  }

  interface Modal {
    openModal: () => void;
  }

  interface EditModal {
    openModal: () => void;
    closeModal: () => void;
  }

  interface Props {
    workspaces?: Workspace[];
    user?: {
      name: string;
      email: string;
      avatar?: string;
    };
  }

  const props = withDefaults(defineProps<Props>(), {
    workspaces: () => [],
    user: () => ({
      name: 'Utilisateur',
      email: 'user@example.com',
      avatar: undefined,
    }),
  });

  const createWorkspaceModal = ref<Modal | null>(null);
  const contentModal = ref<{ openModal: () => void } | null>(null);
  const selectedWorkspaceForEdit = ref<Workspace | null>(null);
  const selectedContent = ref<RawContent | null>(null);
  const localWorkspaces = ref<Workspace[]>(props.workspaces);

  const openCreateWorkspaceModal = () => {
    if (createWorkspaceModal.value) createWorkspaceModal.value.openModal();
  };

  const handleOpenEditModal = (workspace: Workspace) => {
    selectedWorkspaceForEdit.value = workspace;
  };

  const handleCloseEditModal = () => {
    selectedWorkspaceForEdit.value = null;
  };

  const handleOpenContentModal = (content: RawContent | null) => {
    selectedContent.value = content;
    nextTick(() => {
      if (contentModal.value) contentModal.value.openModal();
    });
  };

  const handleWorkspaceCreated = (newWorkspace: Workspace) => {
    localWorkspaces.value.push(newWorkspace);
    selectedWorkspaceForEdit.value = newWorkspace;
    handleOpenContentModal(null);
  };

  const handleContentUpdated = (updatedContent: RawContent) => {
    if (selectedWorkspaceForEdit.value) {
      const index = localWorkspaces.value.findIndex(
        (ws) => ws.id === selectedWorkspaceForEdit.value!.id
      );
      if (index !== -1) {
        localWorkspaces.value[index].raw_content = updatedContent;
      }
      handleCloseEditModal();
    }
  };

  const handleWorkspaceUpdated = (updatedWorkspace: Workspace) => {
    const index = localWorkspaces.value.findIndex((ws: Workspace) => ws.id === updatedWorkspace.id);
    if (index !== -1) {
      localWorkspaces.value[index] = { ...localWorkspaces.value[index], ...updatedWorkspace };
    }
    handleCloseEditModal();
  };

  const handleWorkspaceDeleted = (workspaceId: number) => {
    localWorkspaces.value = localWorkspaces.value.filter((ws: Workspace) => ws.id !== workspaceId);
    handleCloseEditModal();
  };
  const displayedWorkspaces = computed(() => localWorkspaces.value);
</script>

<template>
  <AppLayout :hide-sidebar="false" :hide-top-nav="false" :hide-gradient="false" :hide-toggle="true">
    <div class="relative min-h-screen">
      <div class="relative z-10 flex h-screen">
        <div class="flex flex-1 flex-col">
          <div class="flex flex-1 gap-6 overflow-hidden p-6">
            <div
              class="flex flex-1 flex-col rounded-2xl border border-white/20 bg-white/80 shadow-xl backdrop-blur-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-2xl"
            >
              <div class="border-b border-gray-100 p-6 dark:border-slate-700/50">
                <h1 class="text-2xl font-bold text-gray-800 dark:text-white">Mes Workspaces</h1>
                <p class="mt-1 text-gray-600 dark:text-gray-300">Gérez vos espaces de travail</p>
              </div>

              <div class="scrollbar-hide flex-1 overflow-y-auto p-6">
                <div class="mb-8 grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
                  <WorkspaceIndexCard
                    v-for="workspace in displayedWorkspaces"
                    :key="workspace.id"
                    :workspace="workspace"
                    @edit="(workspace: Workspace) => handleOpenEditModal(workspace)"
                  />

                  <div
                    v-if="displayedWorkspaces.length === 0"
                    class="col-span-full py-12 text-center"
                  >
                    <Icon
                      name="grid"
                      class="mx-auto mb-4 h-16 w-16 text-gray-300 dark:text-gray-600"
                    />
                    <h3 class="mb-2 text-lg font-medium text-gray-500 dark:text-gray-400">
                      Aucun workspace
                    </h3>
                    <p class="text-gray-400 dark:text-gray-500">
                      Créez votre premier espace de travail pour commencer
                    </p>
                  </div>
                </div>
              </div>
              <div
                class="flex justify-center border-t border-gray-100 p-6 dark:border-slate-700/50"
              >
                <Button
                  @click="openCreateWorkspaceModal"
                  variant="secondary"
                  size="icon"
                  class="h-14 w-14 cursor-pointer rounded-full"
                >
                  <Icon name="plus" class="h-8 w-8" />
                </Button>
              </div>
            </div>

            <div
              class="flex w-80 flex-col rounded-2xl border border-white/20 bg-white/80 shadow-xl backdrop-blur-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-2xl"
            >
              <div class="border-b border-gray-100 p-6 dark:border-slate-700/50">
                <h2 class="text-xl font-semibold text-gray-800 dark:text-white">Informations</h2>
              </div>

              <div class="flex-1 space-y-6 p-6">
                <div
                  class="rounded-xl bg-gradient-to-r from-violet-500/10 to-purple-500/10 p-4 dark:from-violet-500/20 dark:to-purple-500/20"
                >
                  <h3 class="mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Statistiques
                  </h3>
                  <div class="space-y-2">
                    <div class="flex justify-between text-sm">
                      <span class="text-gray-600 dark:text-gray-400">Total des workspaces:</span>
                      <span class="font-medium text-gray-800 dark:text-white">
                        {{ displayedWorkspaces.length }}
                      </span>
                    </div>
                    <div class="flex justify-between text-sm">
                      <span class="text-gray-600 dark:text-gray-400">Créés ce mois:</span>
                      <span class="font-medium text-gray-800 dark:text-white">
                        {{ displayedWorkspaces.length }}
                      </span>
                    </div>
                  </div>
                </div>

                <div>
                  <h3 class="mb-3 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Actions rapides
                  </h3>
                  <div class="space-y-2">
                    <Button variant="outline" class="w-full">
                      <div class="flex items-center">
                        <Icon
                          name="settings"
                          class="h-4 w-4 text-gray-500 transition-colors group-hover:text-violet-500 dark:text-gray-400"
                        />
                        <span
                          class="ml-3 text-sm text-gray-700 group-hover:text-gray-900 dark:text-gray-300 dark:group-hover:text-white"
                        >
                          Paramètres
                        </span>
                      </div>
                    </Button>
                    <Button variant="outline" class="w-full">
                      <div class="flex items-center">
                        <Icon
                          name="users"
                          class="h-4 w-4 text-gray-500 transition-colors group-hover:text-violet-500 dark:text-gray-400"
                        />
                        <span
                          class="ml-3 text-sm text-gray-700 group-hover:text-gray-900 dark:text-gray-300 dark:group-hover:text-white"
                        >
                          Inviter des membres
                        </span>
                      </div>
                    </Button>
                    <Button variant="outline" class="w-full">
                      <div class="flex items-center">
                        <Icon
                          name="document"
                          class="h-4 w-4 text-gray-500 transition-colors group-hover:text-violet-500 dark:text-gray-400"
                        />
                        <span
                          class="ml-3 text-sm text-gray-700 group-hover:text-gray-900 dark:text-gray-300 dark:group-hover:text-white"
                        >
                          Documentation
                        </span>
                      </div>
                    </Button>
                  </div>
                </div>

                <div class="rounded-xl bg-blue-50/50 p-4 dark:bg-blue-900/20">
                  <div class="flex items-start">
                    <Icon name="info" class="mt-0.5 h-5 w-5 text-blue-500 dark:text-blue-400" />
                    <div class="ml-3">
                      <h4 class="text-sm font-medium text-blue-900 dark:text-blue-100">
                        Besoin d'aide ?
                      </h4>
                      <p class="mt-1 text-xs text-blue-700 dark:text-blue-200">
                        Consultez notre guide pour créer votre premier workspace.
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <CreateWorkspaceModal ref="createWorkspaceModal" @workspace-created="handleWorkspaceCreated" />
    <AddContentModal
      v-if="selectedWorkspaceForEdit"
      ref="contentModal"
      :workspace="selectedWorkspaceForEdit"
      :rawContent="selectedContent"
      @content-updated="handleContentUpdated"
    />
    <EditWorkspaceModal
      v-if="selectedWorkspaceForEdit"
      :workspace="selectedWorkspaceForEdit"
      @close="handleCloseEditModal"
      @workspace-updated="handleWorkspaceUpdated"
      @workspace-deleted="handleWorkspaceDeleted"
      @open-content-modal="handleOpenContentModal"
    />
  </AppLayout>
</template>
