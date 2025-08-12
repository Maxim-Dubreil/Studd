<script setup lang="ts">
import { Calendar, Grid3X3, Home, Inbox, BookOpen, Settings, FileText } from "lucide-vue-next"
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
        title: "Paramètres",
        url: "/settings",
        icon: Settings,
    },
];
</script>
<template>
    <Sidebar variant="floating" collapsible="icon">
        <SidebarContent>
            <SidebarGroup>
                <SidebarGroupLabel>StudyApp</SidebarGroupLabel>
                <SidebarSeparator />
                <SidebarGroupContent>
                    <SidebarMenu>
                        <SidebarMenuItem v-for="item in items" :key="item.title">
                            <SidebarMenuButton asChild>
                                <a :href="item.url" class="gap-2 p-2 rounded-lg hover:bg-accent transition-colors">
                                    <component :is="item.icon" />
                                    <span>{{ item.title }}</span>
                                </a>
                            </SidebarMenuButton>
                        </SidebarMenuItem>
                    </SidebarMenu>
                </SidebarGroupContent>
            </SidebarGroup>
        </SidebarContent>
    </Sidebar>
</template>