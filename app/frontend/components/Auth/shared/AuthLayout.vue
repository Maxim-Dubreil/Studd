<script setup lang="ts">
import { Card, CardContent } from '@/components/ui/card';
import Gradient from '@/components/GradientBackground.vue';

interface Props {
    title: string;
    subtitle?: string;
    showSidebar?: boolean; // Pour afficher l'image à côté
    showTerms?: boolean; // Pour afficher les conditions
}

withDefaults(defineProps<Props>(), {
    showSidebar: true,
    showTerms: true,
});
</script>

<template>
    <div class="min-h-screen flex items-center justify-center p-4">
        <Gradient />
        <div class="flex flex-col gap-6 w-full max-w-4xl">
            <!-- Card principale -->
            <Card class="overflow-hidden">
                <CardContent class="grid p-0" :class="showSidebar ? 'md:grid-cols-2' : 'md:grid-cols-1'">
                    <!-- Formulaire principal -->
                    <div class="p-6 md:p-8">
                        <div class="flex flex-col gap-6">
                            <!-- Header -->
                            <div class="flex flex-col items-center text-center">
                                <slot name="logo">
                                    <!-- Logo par défaut -->
                                    <div class="flex items-center justify-center">
                                        <img src="../../../assets/vue.sng" alt="Logo"
                                            class="w-12 h-12 object-contain rounded mb-4" />
                                    </div>
                                </slot>

                                <h1 class="text-2xl font-bold">{{ title }}</h1>
                                <p v-if="subtitle" class="text-balance text-muted-foreground">
                                    {{ subtitle }}
                                </p>
                            </div>

                            <!-- Contenu principal du formulaire -->
                            <slot />

                            <!-- Liens en bas (connexion/inscription) -->
                            <slot name="links" />
                        </div>
                    </div>

                    <!-- Sidebar avec image (optionnelle) -->
                    <div v-if="showSidebar" class="relative hidden bg-muted md:block">
                        <slot name="sidebar">
                            <img src="../../../../assets/images/vue.svg" alt="StudyApp"
                                class="absolute inset-0 h-full w-full object-cover dark:brightness-[0.2] dark:grayscale" />
                        </slot>
                    </div>
                </CardContent>
            </Card>

            <!-- Conditions d'utilisation -->
            <div v-if="showTerms"
                class="text-balance text-center text-xs text-muted-foreground [&_a]:underline [&_a]:underline-offset-4 hover:[&_a]:text-primary">
                <slot name="terms">
                    En continuant, vous acceptez nos
                    <a href="/terms">Conditions d'utilisation</a>
                    et notre <a href="/privacy">Politique de confidentialité</a>.
                </slot>
            </div>
        </div>
    </div>
</template>
