<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { Button } from '@/components/ui/button';
import Icon from '@/components/ui/icon/Icon.vue';
import { cn } from '@/lib/utils';

interface NavItem {
  name: string;
  url: string;
  icon: string; // Nom de l'icône Lucide
  id?: string; // Identifiant optionnel pour l'onglet
}

interface Props {
  items: NavItem[];
  class?: string;
}

const props = defineProps<Props>();

// Définir les événements émis
const emit = defineEmits<{
  (e: 'tab-change', tabId: string): void
}>();

const activeTab = ref(props.items[0]?.name || '');
const isMobile = ref(false);

const updateIsMobile = () => {
  isMobile.value = window.innerWidth < 768;
};

onMounted(() => {
  updateIsMobile();
  window.addEventListener('resize', updateIsMobile);
  return () => window.removeEventListener('resize', updateIsMobile);
});

const setActiveTab = (item: NavItem) => {
  activeTab.value = item.name;
  // Émettre l'événement avec l'ID de l'onglet ou le nom si l'ID n'est pas défini
  emit('tab-change', item.id || item.name.toLowerCase());
};

const containerClass = computed(() => {
  return cn(
    'fixed bottom-0 sm:top-0 left-1/2 -translate-x-1/2 z-50 mb-6 sm:pt-6',
    props.class
  );
});
</script>

<template>
  <div :class="containerClass">
    <div class="flex items-center gap-3 bg-background/5 border border-border backdrop-blur-lg py-1 px-1 rounded-xl shadow-lg">
      <template v-for="item in props.items" :key="item.name">
        <a
          :href="item.url"
          @click.prevent="setActiveTab(item)"
          :class="cn(
            'relative cursor-pointer text-sm font-semibold px-6 py-2 rounded-xl transition-colors',
            'text-foreground/80 hover:text-primary',
            activeTab === item.name && 'bg-muted text-primary'
          )"
        >
          <span class="hidden md:inline">{{ item.name }}</span>
          <span class="md:hidden">
            <Icon :name="item.icon" size="sm" />
          </span>

          <!-- Animation de l'élément actif -->
          <transition name="lamp" mode="out-in">
            <div
              v-if="activeTab === item.name"
              class="absolute inset-0 w-full bg-primary/5 rounded-xl -z-10 transition-all duration-300"
            >
              <div class="absolute -top-2 left-1/2 -translate-x-1/2 w-8 h-1 bg-primary rounded-t-full">
                <div class="absolute w-12 h-6 bg-primary/20 rounded-full blur-md -top-2 -left-2"></div>
                <div class="absolute w-8 h-6 bg-primary/20 rounded-full blur-md -top-1"></div>
                <div class="absolute w-4 h-4 bg-primary/20 rounded-full blur-sm top-0 left-2"></div>
              </div>
            </div>
          </transition>
        </a>
      </template>
    </div>
  </div>
</template>

<style scoped>
.lamp-enter-active,
.lamp-leave-active {
  transition: all 0.3s ease;
}

.lamp-enter-from,
.lamp-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>