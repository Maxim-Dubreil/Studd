<template>
  <div class="space-y-8 font-['Inter',sans-serif]">
    <!-- Grille de workspaces -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <WorkspaceCard
        v-for="workspace in workspaces"
        :key="workspace.id"
        :workspace="workspace"
        @click="openWorkspace(workspace.id)"
      />
    </div>

    <!-- Bouton Create new workspace -->
    <div class="flex justify-center mt-8">
      <button
        @click="createNewWorkspace"
        class="bg-violet-500 hover:bg-violet-600 text-white px-8 py-4 rounded-[20px] font-medium text-lg transition-all duration-300 shadow-lg hover:shadow-xl backdrop-blur-sm border border-violet-400/20"
      >
        Create new workspace
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import WorkspaceCard from "@/components/ui/WorkspaceCard.vue";

interface Workspace {
  id: string;
  title: string;
  image?: string;
}

const workspaces = ref<Workspace[]>([
  {
    id: "1",
    title: "Partiel chimie",
  },
  {
    id: "2",
    title: "Chapitre 3 – Eco",
  },
  {
    id: "3",
    title: "Mathématiques",
  },
  {
    id: "4",
    title: "Histoire moderne",
  },
  {
    id: "5",
    title: "Physique quantique",
  },
  {
    id: "6",
    title: "Littérature",
  },
]);

const openWorkspace = (workspaceId: string) => {
  console.log("Opening workspace:", workspaceId);
  // Logique pour ouvrir le workspace
};

const createNewWorkspace = () => {
  console.log("Creating new workspace");
  // Logique pour créer un nouveau workspace
};
</script>
