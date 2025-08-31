<!-- app/frontend/components/shared/NavUser.vue -->
<script setup lang="ts">
  import { NAV_AVATAR, NAV_BTN, NAV_ICON } from '@/components/shared/sidebar/navStyles';
  import { CalendarDays, Edit, LogOut } from 'lucide-vue-next';
  import { ref } from 'vue';

  import DecoDialog from '../../ui/alert-dialog/DecoDialog.vue';
  import UserMenuModal from './UserMenuModal.vue';

  import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
  import { HoverCard, HoverCardContent, HoverCardTrigger } from '@/components/ui/hover-card';
  import { Label } from '@/components/ui/label';
  import { SidebarMenu, SidebarMenuButton, SidebarMenuItem } from '@/components/ui/sidebar';

  interface Props {
    user?: {
      name?: string;
      email?: string;
      avatar?: string;
    };
  }
  const props = defineProps<Props>();
  const userMenuModalRef = ref<InstanceType<typeof UserMenuModal> | null>(null);

  const openEditProfile = () => {
    userMenuModalRef.value?.openModal?.();
  };
  const logout = () => {
    const link = document.createElement('a');
    link.href = '/logout';
    link.setAttribute('data-turbo-method', 'delete');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };
</script>

<template>
  <SidebarMenu>
    <SidebarMenuItem>
      <!-- Log Out  -->
      <DecoDialog
        :on-confirm="logout"
        title="Log Out"
        description="Are you sure you want to log out?"
        action-label="Continue"
        cancel-label="Cancel"
        :destructive="true"
      >
        <template #trigger>
          <SidebarMenuButton as-child>
            <button type="button" :class="['group', NAV_BTN, 'cursor-pointer']" @click.stop>
              <LogOut :class="[NAV_ICON]" style="color: red" />
              <span class="text-sm group-data-[collapsible=icon]:hidden">Log out</span>
            </button>
          </SidebarMenuButton>
        </template>
      </DecoDialog>
    </SidebarMenuItem>

    <!-- Edit Profile  -->
    <SidebarMenuItem>
      <SidebarMenuButton as-child>
        <button
          type="button"
          :class="['group', NAV_BTN, 'cursor-pointer']"
          @click="openEditProfile"
        >
          <Edit :class="NAV_ICON" />
          <span class="text-sm group-data-[collapsible=icon]:hidden">Edit Profile</span>
        </button>
      </SidebarMenuButton>
    </SidebarMenuItem>

    <!-- Bloc avatar + infos HoverCard -->
    <SidebarMenuItem>
      <HoverCard :open-delay="100" :close-delay="100">
        <HoverCardTrigger as-child>
          <button type="button" :class="['group', NAV_BTN]">
            <Avatar :class="NAV_AVATAR">
              <AvatarImage
                :src="props.user?.avatar || 'https://github.com/unovue.png'"
                :alt="props.user?.name || 'User avatar'"
              />
              <AvatarFallback class="rounded-lg">U</AvatarFallback>
            </Avatar>

            <div class="min-w-0 text-left group-data-[collapsible=icon]:hidden">
              <p class="text-sm font-semibold">{{ props.user?.name || 'John Doe' }}</p>
            </div>
          </button>
        </HoverCardTrigger>

        <HoverCardContent side="right" align="start" :side-offset="8" class="z-50 m-2 w-64 p-4">
          <div class="flex items-center gap-3">
            <Avatar>
              <AvatarImage
                :src="props.user?.avatar || 'https://github.com/unovue.png'"
                :alt="props.user?.name || 'User avatar'"
              />
              <AvatarFallback>U</AvatarFallback>
            </Avatar>
            <div class="space-y-1">
              <Label class="text-sm font-semibold">{{ props.user?.name || 'John Doe' }}</Label>
              <Label class="text-muted-foreground text-xs">
                {{ props.user?.email || 'john@example.com' }}
              </Label>
            </div>
          </div>

          <div class="bg-border my-3 h-px"></div>

          <div class="flex items-center gap-2">
            <CalendarDays class="h-4 w-4 opacity-70" />
            <span class="text-muted-foreground text-xs">Joined on January 2014</span>
          </div>
        </HoverCardContent>
      </HoverCard>
    </SidebarMenuItem>
  </SidebarMenu>

  <Teleport to="body">
    <UserMenuModal ref="userMenuModalRef" />
  </Teleport>
</template>
