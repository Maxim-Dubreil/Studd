<script setup lang="ts">
import { Calendar, Grid3X3, Home, Inbox, BookOpen, Settings, FileText } from "lucide-vue-next"
import { onMounted, ref, onUnmounted } from "vue";

import {
    Sidebar,
    SidebarContent,
    SidebarGroup,
    SidebarGroupContent,
    SidebarGroupLabel,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
    SidebarSeparator,
    SidebarMenuSkeleton
} from '@/components/ui/sidebar'

// Menu items avec tes routes
const items = [
    {
        title: "Dashboard",
        url: "/",
        icon: Home,
    },
    {
        title: "Workspaces",
        url: "/workspaces",
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
        title: "Settings",
        url: "/settings",
        icon: Settings,
    },
];

const activeItem = ref<string>('/');

const normalizePath = (path: string) => {
    // retire les / finaux (sauf root) et alias /dashboard -> /
    const p = (path.replace(/\/+$/, '') || '/');
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
    // si navigation SPA/History API
    window.addEventListener('popstate', computeActive);
});
onUnmounted(() => window.removeEventListener('popstate', computeActive));

const isActive = (url: string) => activeItem.value === url;

</script>
<template>
    <div class="px-3 py-5">
        <Sidebar variant="floating" collapsible="icon" class="group" :style="{ '--sidebar-width': '248px' }">
            <SidebarContent>
                <SidebarGroup class="space-y-2">
                    <SidebarGroupLabel class="px-4 pt-4 font-semibold text-neutral-900 dark:text-neutral-50 text-xl">
                        StudyApp
                    </SidebarGroupLabel>
                    <SidebarSeparator class="my-3 w-3/4 mx-auto h-[2px] bg-border rounded-full
                   group-data-[collapsible=icon]:hidden
                   group-data-[state=collapsed]:hidden
                   group-data-[collapsed=true]:hidden" />

                    <SidebarGroupContent>

                        <SidebarMenu class="gap-2">

                            <SidebarMenuItem v-for="item in items" :key="item.title">

                                <SidebarMenuButton asChild :isActive="isActive(item.url)" class="h-12 rounded-2xl px-4 text-sm font-medium tracking-wide
         bg-transparent text-gray-600 dark:text-gray-300 
         hover:bg-violet-100/70 dark:hover:bg-violet-900/30
         hover:text-violet-600
         dark:hover:text-violet-400`
         data-[active=true]:text-white data-[active=true]:shadow
         data-[active=true]:bg-gradient-to-r
         data-[active=true]:from-violet-500 data-[active=true]:to-purple-600
         dark:data-[active=true]:from-violet-600 dark:data-[active=true]:to-purple-700
         data-[active=true]:hover:brightness-105
         transition-colors
         gap-4">
                                    <a :href="item.url" class="transition-all duration-300 hover:shadow-sm">
                                        <component :is="item.icon" class="w-7 h-7 shrink-0" /> <span class="truncate">{{
                                            item.title }}</span>
                                    </a>
                                </SidebarMenuButton>
                            </SidebarMenuItem>
                        </SidebarMenu>
                    </SidebarGroupContent>
                </SidebarGroup>
            </SidebarContent>
        </Sidebar>
    </div>
</template>