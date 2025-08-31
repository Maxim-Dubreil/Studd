<script setup lang="ts">
  import { NAV_BTN, NAV_ICON } from '@/components/shared/sidebar/navStyles';
  import {
    Sidebar,
    SidebarContent,
    SidebarFooter,
    SidebarGroup,
    SidebarGroupContent,
    SidebarGroupLabel,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
    SidebarSeparator,
  } from '@/components/ui/sidebar';
  import { Grid3X3, Home, Settings } from 'lucide-vue-next';
  import { onMounted, onUnmounted, ref, toRefs } from 'vue';
  import logoLight from '../../../images/logo/logoLight.png';
  import NavFooter from './NavFooter.vue';

  const props = defineProps<{
    user?: { name: string; email: string; avatar?: string };
  }>();
  const { user } = toRefs(props);

  // Menu items avec tes routes
  const items = [
    {
      title: 'Dashboard',
      url: '/',
      icon: Home,
    },
    {
      title: 'Workspaces',
      url: '/workspaces',
      icon: Grid3X3,
    },
    // {
    //     title: "Blog",
    //     url: "/blog",
    //     icon: FileText,
    // },
    // {
    //     title: "Courses",
    //     url: "/courses",
    //     icon: BookOpen,
    // },
    // {
    //     title: "Calendar",
    //     url: "/calendar",
    //     icon: Calendar,
    // },
    {
      title: 'Settings',
      url: '/settings',
      icon: Settings,
    },
  ];

  const activeItem = ref<string>('/');

  const normalizePath = (path: string) => {
    const p = path.replace(/\/+$/, '') || '/';
    return p === '/dashboard' ? '/' : p;
  };

  const computeActive = () => {
    const path = normalizePath(window.location.pathname);
    const match = items.find(
      (item) => path === item.url || (item.url !== '/' && path.startsWith(item.url))
    );
    activeItem.value = match ? match.url : '/';
  };

  onMounted(() => {
    computeActive();
    window.addEventListener('popstate', computeActive);
  });
  onUnmounted(() => window.removeEventListener('popstate', computeActive));

  const isActive = (url: string) => activeItem.value === url;
</script>
<template>
  <Sidebar variant="floating" collapsible="icon" class="group">
    <SidebarContent>
      <SidebarGroup class="space-y-2">
        <SidebarGroupLabel
          class="text-xl pt-4 font-semibold text-neutral-900 dark:text-neutral-50"
        >
          <a
            href="/"
            class="flex items-center gap-2 text-sm font-medium transition-colors duration-200 hover:text-indigo-600 dark:hover:text-indigo-400"
            aria-label="Go to home"
          >
            <img :src="logoLight" alt="Logo" class="h-7 w-7 rounded-lg" />
            <p>Studd</p>
          </a>
        </SidebarGroupLabel>
        <SidebarSeparator
          class="bg-border mx-auto my-3 h-[2px] w-3/4 rounded-full group-data-[collapsed=true]:hidden group-data-[collapsible=icon]:hidden group-data-[state=collapsed]:hidden"
        />
        <SidebarGroupContent>
          <SidebarMenu class="gap-2">
            <SidebarMenuItem v-for="item in items" :key="item.title">
              <SidebarMenuButton as-child :isActive="isActive(item.url)" class="p-0">
                <a
                  :href="item.url"
                  :class="['group', NAV_BTN]"
                  :data-active="isActive(item.url) ? 'true' : undefined"
                >
                  <component :is="item.icon" :class="NAV_ICON" />
                  <span class="text-sm group-data-[state=collapsed]:hidden">
                    {{ item.title }}
                  </span>
                </a>
              </SidebarMenuButton>
            </SidebarMenuItem>
          </SidebarMenu>
        </SidebarGroupContent>
      </SidebarGroup>
    </SidebarContent>
    <SidebarFooter>
      <NavFooter :user="user" />
    </SidebarFooter>
  </Sidebar>
</template>
