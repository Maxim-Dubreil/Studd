<script setup lang="ts">
import { ref } from "vue";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import AuthLayout from "./shared/AuthLayout.vue";
import FormErrors from "./shared/FormErrors.vue";

interface Props {
    formUrl: string;
    minimumPasswordLength?: number;
    errors?: string[];
    csrfToken: string;
    links: {
        login: string;
    };
}

const props = defineProps<Props>();

const email = ref("");
const password = ref("");
const passwordConfirmation = ref("");
const isSubmitting = ref(false);

const submitForm = () => {
    if (isSubmitting.value) return;

    isSubmitting.value = true;

    const railsForm = document.getElementById(
        "rails-registration-form"
    ) as HTMLFormElement;
    const emailInput = document.getElementById(
        "rails-reg-email"
    ) as HTMLInputElement;
    const passwordInput = document.getElementById(
        "rails-reg-password"
    ) as HTMLInputElement;
    const passwordConfirmationInput = document.getElementById(
        "rails-reg-password-confirmation"
    ) as HTMLInputElement;

    emailInput.value = email.value;
    passwordInput.value = password.value;
    passwordConfirmationInput.value = passwordConfirmation.value;

    railsForm.submit();
};
</script>

<template>
    <AuthLayout title="Créer votre compte" subtitle="" :show-sidebar="true">

        <!-- Logo -->
        <template #logo>
        </template>

        <template #default>
            <!-- Erreurs -->
            <FormErrors :errors="errors" />

            <!-- Formulaire -->
            <form @submit.prevent="submitForm" class="space-y-6 mx-2 ">
                <!-- Email -->
                <div class="grid gap-2 pb-2">
                    <Label for="email">Email</Label>
                    <Input id="email" v-model="email" type="email" placeholder="votre@email.com" required
                        :disabled="isSubmitting" />
                </div>
                <!-- Mot de passe -->
                <div class="grid gap-2 pb-2">
                    <Label for="password">
                        Mot de passe
                        <span v-if="minimumPasswordLength" class="text-sm text-muted-foreground font-normal">
                            ({{ minimumPasswordLength }} caractères minimum)
                        </span>
                    </Label>
                    <Input id="password" v-model="password" type="password" required :disabled="isSubmitting" />
                </div>
                <!-- Confirmation -->
                <div class="grid gap-2 pb-15">
                    <Label for="password_confirmation">Confirmer le mot de passe</Label>
                    <Input id="password_confirmation" v-model="passwordConfirmation" type="password" required
                        :disabled="isSubmitting" />
                </div>
                <!-- Bouton -->
                <div class="w-full flex item-center justify-center">
                    <Button type="submit" class="w-45 h-12 rounded-2xl text-md cursor-pointer" style="background-color: #7D6BFB"
                        :disabled="isSubmitting">
                        <svg v-if="isSubmitting" class="mr-2 h-4 w-4 animate-spin" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
                            </circle>
                            <path class="opacity-75" fill="currentColor"
                                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                            </path>
                        </svg>
                        {{ isSubmitting ? "Création en cours..." : "Créer mon compte" }}
                    </Button>
                </div>
            </form>
        </template>
        <!-- Sidebar avec image -->
        <template #sidebar>
            <div class="relative flex items-center justify-center">
                <div class="text-center text-white p-6">
                    <h2 class="text-3xl mb-4">
                        <span>Bienvenue sur </span>
                        <span class="font-bold">Study App !</span>
                    </h2>
                    <p class="px-8 text-md">
                        La plateforme d'apprentissage qui révolutionne vos études
                    </p>
                </div>
            </div>
        </template>
        <template #links>
            <div class="text-center text-sm">
                Déjà un compte ?
                <a :href="links.login" class="underline underline-offset-4 hover:text-primary">
                    Se connecter
                </a>
            </div>
        </template>
    </AuthLayout>

    <!-- Formulaire Rails caché -->
    <slot name="rails-form" />
</template>
