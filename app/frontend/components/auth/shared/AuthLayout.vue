<script setup lang="ts">
  import { Card, CardContent } from '@/components/ui/card';
  import AppLayout from '../../layout/AppLayout.vue';
  interface Props {
    title: string;
    subtitle?: string;
    showSidebar?: boolean;
    showTerms?: boolean;
  }

  withDefaults(defineProps<Props>(), {
    showSidebar: true,
    showTerms: true,
  });
</script>

<template>
  <AppLayout :hideSidebar="true" :hideToggle="false" :hideHelper="false">
    <div
      class="mx-auto flex h-screen w-full max-w-4xl flex-col items-center justify-center gap-6 overflow-hidden px-4"
    >
      <!-- Card principale -->
      <Card class="max-h-[90vh] w-full overflow-hidden">
        <CardContent class="grid p-0" :class="showSidebar ? 'md:grid-cols-2' : 'md:grid-cols-1'">
          <!-- Formulaire principal -->
          <div class="overflow-y-auto p-6 md:p-8">
            <div class="flex flex-col gap-6">
              <!-- Header -->
              <div class="flex flex-col items-center pt-4 pb-6 text-center">
                <!-- Logo par défaut -->

                <h1 class="text-3xl font-bold">{{ title }}</h1>
                <p v-if="subtitle" class="text-muted-foreground max-w-md text-balance">
                  {{ subtitle }}
                </p>
              </div>

              <!-- Contenu principal du formulaire -->
              <slot class="gap-8"></slot>

              <!-- Liens en bas (connexion/inscription) -->
              <slot name="links"></slot>
            </div>
          </div>
          <!-- Sidebar avec image (optionnelle) -->
          <div
            v-if="showSidebar"
            class="relative flex items-center justify-center overflow-hidden"
            style="background: linear-gradient(90deg, #c2c3ff 0%, #4d51ff 100%)"
          >
            <!-- Bulles stylisées -->
            <div
              class="absolute top-6 right-6 h-44 w-44 rounded-full border-2 border-white/30 bg-gradient-to-tr from-fuchsia-400 via-blue-400 to-green-300 opacity-50 shadow-2xl blur-lg"
            ></div>

            <div
              class="absolute bottom-16 left-16 h-32 w-32 rounded-full border border-white/20 bg-gradient-to-tr from-cyan-300 via-pink-300 to-purple-400 opacity-50 shadow-xl blur-md"
            ></div>

            <div
              class="absolute right-36 bottom-10 h-24 w-24 rounded-full border border-white/20 bg-gradient-to-tr from-yellow-200 via-orange-300 to-pink-400 opacity-50 shadow-lg blur-md"
            ></div>
            <slot name="sidebar"></slot>
          </div>
        </CardContent>
      </Card>
    </div>
  </AppLayout>
</template>
