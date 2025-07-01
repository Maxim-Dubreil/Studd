<script setup lang="ts">
import { ref } from "vue";
import Icon from "./ui/Icon.vue";
import "~/styles/app.css";

const props = defineProps<{
  activeItem?: string;
}>();

const emit = defineEmits<{
  (e: "update:activeItem", value: string): void;
}>();

const navigationItems = ref([
  { id: "home", label: "Home", iconName: "home" },
  { id: "workspaces", label: "Workspaces", iconName: "grid" },
  { id: "blog", label: "Blog", iconName: "document" },
  { id: "courses", label: "Courses", iconName: "book" },
  { id: "calendar", label: "Calendar", iconName: "calendar" },
]);

const handleClick = (id: string) => {
  emit("update:activeItem", id);
};
</script>

<template>
  <div class="...">
    <div class="p-6">
      <h1 class="text-2xl font-bold">StudyApp</h1>
    </div>
    <nav class="...">
      <div
        v-for="item in navigationItems"
        :key="item.id"
        @click="handleClick(item.id)"
        class="..."
      >
        <Icon :name="item.iconName" class="..." />
        {{ item.label }}
      </div>
    </nav>
  </div>
</template>
