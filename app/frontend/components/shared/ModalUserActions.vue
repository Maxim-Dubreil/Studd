<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, watch } from 'vue'
import { Edit, LogOut } from 'lucide-vue-next'

import { Button } from '@/components/ui/button'
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog'

import UserMenuModal from '@/components/shared/UserMenuModal.vue'

const props = withDefaults(defineProps<{
  /** Ref du conteneur scrollable (ex: <main ref="mainRef">) ; si absent → window */
  scrollTarget?: HTMLElement | null
  user?: { name?: string; email?: string; avatar?: string }
  threshold?: number // px avant d’afficher les actions
}>(), {
  scrollTarget: null,
  threshold: 160,
})

const visible = ref(false)
const userMenuModalRef = ref<InstanceType<typeof UserMenuModal> | null>(null)

const onScroll = () => {
  const el = props.scrollTarget
  const y = el ? el.scrollTop : window.scrollY
  visible.value = y >= props.threshold
}

onMounted(() => {
  const el = props.scrollTarget
  ;(el ?? window).addEventListener('scroll', onScroll, { passive: true })
  onScroll()
})

onBeforeUnmount(() => {
  const el = props.scrollTarget
  ;(el ?? window).removeEventListener('scroll', onScroll)
})

const openEditProfile = () => userMenuModalRef.value?.openModal?.()

const logout = () => {
  const link = document.createElement('a')
  link.href = '/logout'
  link.setAttribute('data-turbo-method', 'delete')
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}
</script>

<template>
  <!-- Transition apparence/disparition -->
  <transition
    enter-active-class="transition ease-out duration-200"
    enter-from-class="opacity-0 translate-y-2"
    enter-to-class="opacity-100 translate-y-0"
    leave-active-class="transition ease-in duration-150"
    leave-from-class="opacity-100 translate-y-0"
    leave-to-class="opacity-0 translate-y-2"
  >
    <div
      v-if="visible"
      class="fixed bottom-6 right-6 z-50 flex items-center gap-2"
    >
      <!-- Edit Profile -->
      <Button
        size="sm"
        variant="default"
        class="shadow-lg"
        @click="openEditProfile"
        aria-label="Edit profile"
      >
        <Edit class="mr-2 h-4 w-4" />
        Edit Profile
      </Button>

      <!-- Logout (confirm) -->
      <AlertDialog>
        <AlertDialogTrigger as-child>
          <Button
            size="icon"
            variant="outline"
            class="shadow-lg border-red-200/60 hover:bg-red-50 dark:hover:bg-red-950/40"
            aria-label="Log out"
          >
            <LogOut class="h-5 w-5 text-red-600 dark:text-red-500" />
          </Button>
        </AlertDialogTrigger>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Se déconnecter ?</AlertDialogTitle>
            <AlertDialogDescription>
              Vous allez être déconnecté de votre session.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Annuler</AlertDialogCancel>
            <AlertDialogAction
              class="bg-red-600 text-white hover:bg-red-700"
              @click="logout"
            >
              Confirmer
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <!-- Modal d’édition de profil réutilisé -->
      <UserMenuModal ref="userMenuModalRef" />
    </div>
  </transition>
</template>
