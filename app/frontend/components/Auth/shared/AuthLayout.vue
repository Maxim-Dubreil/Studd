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
        <div class="flex flex-col gap-6 w-full max-w-4xl h-full">
            <!-- Card principale -->
            <Card class="overflow-hidden">
                <CardContent class="grid p-0" :class="showSidebar ? 'md:grid-cols-2' : 'md:grid-cols-1'">
                    <!-- Formulaire principal -->
                    <div class="p-6 md:p-8">
                        <div class="flex flex-col gap-6">
                            <!-- Header -->
                            <div class="flex flex-col items-center text-center pb-6 pt-4">
                                <!-- Logo par défaut -->

                                <h1 class="text-3xl font-bold">{{ title }}</h1>
                                <p v-if="subtitle" class="text-balance text-muted-foreground">
                                    {{ subtitle }}
                                </p>
                            </div>

                            <!-- Contenu principal du formulaire -->
                            <slot class="gap-8" />

                            <!-- Liens en bas (connexion/inscription) -->
                            <slot name="links" />
                        </div>
                    </div>

                    <!-- Sidebar avec image (optionnelle) -->
                    <div v-if="showSidebar" class="relative overflow-hidden flex items-center justify-center"
                        style="background: linear-gradient(90deg, #C2C3FF 0%, #4D51FF 100%);">
                        <!-- Bulles stylisées -->
                        <div
                            class="absolute w-44 h-44 rounded-full bg-gradient-to-tr from-fuchsia-400 via-blue-400 to-green-300 top-6 right-6 opacity-50 blur-lg shadow-2xl border-2 border-white/30">
                        </div>

                        <div
                            class="absolute w-32 h-32 rounded-full bg-gradient-to-tr from-cyan-300 via-pink-300 to-purple-400 bottom-16 left-16 opacity-50 blur-md shadow-xl border border-white/20">
                        </div>

                        <div
                            class="absolute w-24 h-24 rounded-full bg-gradient-to-tr from-yellow-200 via-orange-300 to-pink-400 bottom-10 right-36 opacity-50 blur-md shadow-lg border border-white/20">
                        </div>
                        <slot name="sidebar">

                        </slot>
                    </div>
                </CardContent>
            </Card>

            <!-- Conditions d'utilisation -->
            <!-- <div v-if="showTerms"
                class="text-balance text-center text-xs text-muted-foreground [&_a]:underline [&_a]:underline-offset-4 hover:[&_a]:text-primary">
                <slot name="terms">
                    En continuant, vous acceptez nos
                    <a href="/terms">Conditions d'utilisation</a>
                    et notre <a href="/privacy">Politique de confidentialité</a>.
                </slot>
            </div> -->
        </div>
    </div>
</template>
