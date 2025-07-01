<template>
  <div
    class="bg-white/70 backdrop-blur-lg rounded-[24px] p-6 shadow-lg border border-white/20 hover:shadow-xl transition-all duration-300 cursor-pointer hover:transform hover:scale-105 group"
    @click="$emit('click')"
  >
    <!-- Image 3D arrondie -->
    <div class="mb-4 flex justify-center">
      <div
        :class="getWorkspaceGradient(workspace.id)"
        class="w-24 h-24 rounded-[20px] flex items-center justify-center shadow-lg group-hover:shadow-xl transition-all duration-300 transform group-hover:scale-110"
      >
        <!-- Icône personnalisée selon le type de workspace -->
        <div
          class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-[12px] flex items-center justify-center shadow-md"
        >
          <Icon
            :name="getWorkspaceIcon(workspace.title)"
            size="lg"
            color="text-white"
          />
        </div>
      </div>
    </div>

    <!-- Titre du workspace -->
    <div class="text-center">
      <h3
        class="text-lg font-medium text-gray-700 group-hover:text-violet-600 transition-colors duration-300"
      >
        {{ workspace.title }}
      </h3>
    </div>
  </div>
</template>

<script setup lang="ts">
import Icon from "./Icon.vue";

interface Workspace {
  id: string;
  title: string;
  image?: string;
}

interface Props {
  workspace: Workspace;
}

defineProps<Props>();

defineEmits<{
  click: [];
}>();

// Fonction pour obtenir le dégradé en fonction de l'ID du workspace
const getWorkspaceGradient = (id: string) => {
  const gradients = [
    "bg-gradient-to-br from-violet-400 via-purple-500 to-blue-500",
    "bg-gradient-to-br from-emerald-400 via-teal-500 to-cyan-500",
    "bg-gradient-to-br from-orange-400 via-red-500 to-pink-500",
    "bg-gradient-to-br from-yellow-400 via-orange-500 to-red-500",
    "bg-gradient-to-br from-indigo-400 via-purple-500 to-pink-500",
    "bg-gradient-to-br from-green-400 via-blue-500 to-purple-500",
  ];

  // Utilise l'ID pour déterminer quel gradient utiliser
  const index = parseInt(id) % gradients.length;
  return gradients[index];
};

// Fonction pour obtenir l'icône en fonction du titre du workspace
const getWorkspaceIcon = (title: string) => {
  const titleLower = title.toLowerCase();

  if (titleLower.includes("chimie") || titleLower.includes("chemistry")) {
    return "zap";
  } else if (titleLower.includes("eco") || titleLower.includes("économie")) {
    return "trendingUp";
  } else if (
    titleLower.includes("math") ||
    titleLower.includes("mathématiques")
  ) {
    return "barChart";
  } else if (
    titleLower.includes("histoire") ||
    titleLower.includes("history")
  ) {
    return "book";
  } else if (
    titleLower.includes("physique") ||
    titleLower.includes("physics")
  ) {
    return "zap";
  } else if (
    titleLower.includes("littérature") ||
    titleLower.includes("literature")
  ) {
    return "bookmarked";
  } else {
    // Icône par défaut
    return "briefcase";
  }
};
</script>
