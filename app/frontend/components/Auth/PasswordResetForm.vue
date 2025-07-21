<script setup lang="ts">
import { ref } from "vue";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import AuthLayout from "./shared/AuthLayout.vue";
import FormErrors from "./shared/FormErrors.vue";

interface Props {
    formUrl: string;
    errors?: string[];
    csrfToken: string;
    links: {
        login: string;
        register: string;
    };
}

const props = defineProps<Props>();

const email = ref("");
const isSubmitting = ref(false);

const submitForm = () => {
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    const railsForm = document.getElementById("rails-password-form") as HTMLFormElement;
    const emailInput = document.getElementById("rails-password-email") as HTMLInputElement;

    emailInput.value = email.value;

    railsForm.submit();
};
</script>

<template>
    <AuthLayout title="Mot de passe oublié ?" :show-sidebar="false">
        <template #logo>
        </template>
        <template #default>

            <div className="m-5">
                <FormErrors :errors="errors" />
                <form @submit.prevent="submitForm" class="space-y-10 max-w-lg">
                    <div class="grid gap-2 pb-2">
                        <Label for="email">Email</Label>
                        <Input id="email" v-model="email" type="email" required :disabled="isSubmitting" />
                        <div class="w-full max-w-md text-center pt-2">
                            <p className="text-md text-muted-foreground ">
                                Entrez votre adresse e-mail pour recevoir les instructions de réinitialisation de mot de
                                passe.
                            </p>
                        </div>
                    </div>
                    <div class="w-full flex items-center justify-center">
                        <Button type="submit" class="w-50 h-12 rounded-2xl text-md" style="background-color: #7D6BFB"
                            :disabled="isSubmitting">
                            <svg v-if="isSubmitting" class="mr-2 h-4 w-4 animate-spin" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
                                    stroke-width="4" />
                                <path class="opacity-75" fill="currentColor"
                                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                            </svg>
                            {{ isSubmitting ? "Envoi..." : "Envoyer les instructions" }}
                        </Button>
                    </div>
                </form>
            </div>

        </template>
        <template #links>
            <div class="text-center text-sm">
                <a :href="links.login" class="underline underline-offset-4 hover:text-primary">Se connecter</a>
                <span class="mx-2">|</span>
                <a :href="links.register" class="underline underline-offset-4 hover:text-primary">S'inscrire</a>
            </div>
        </template>
    </AuthLayout>
</template>