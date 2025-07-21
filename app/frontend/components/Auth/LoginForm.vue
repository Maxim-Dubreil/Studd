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
    register: string;
    forgot: string;
  };
}

const props = defineProps<Props>();

const email = ref("");
const password = ref("");
const isSubmitting = ref(false);
const rememberMe = ref(false);

const submitForm = () => {
  if (isSubmitting.value) return;
  isSubmitting.value = true;

  const railsForm = document.getElementById("rails-login-form") as HTMLFormElement;
  const emailInput = document.getElementById("rails-login-email") as HTMLInputElement;
  const passwordInput = document.getElementById("rails-login-password") as HTMLInputElement;
  const rememberInput = document.getElementById("rails-login-remember") as HTMLInputElement;
if (rememberInput) rememberInput.checked = rememberMe.value;

  emailInput.value = email.value;
  passwordInput.value = password.value;

  railsForm.submit();
};
</script>

<template>
  <AuthLayout title="Connexion" :show-sidebar="true">
    <!-- Logo -->
    <template #logo>
    </template>
    <template #default>

      <!-- Erreurs -->
      <FormErrors :errors="errors" />

      <!-- Formulaire -->
      <form @submit.prevent="submitForm" class="space-y-6 mx-2">

        <!-- Email -->
        <div class="grid gap-2 pb-2">
          <Label for="email">Email</Label>
          <Input id="email" v-model="email" type="email" required :disabled="isSubmitting" />
        </div>

        <!-- Mot de passe -->
        <div class="grid gap-2 pb-15">
          <Label for="password">Mot de passe</Label>
          <div>
            <Input id="password" v-model="password" type="password" required :disabled="isSubmitting" />
            <div class="text-center pt-2">
              <a :href="links.forgot" class="text-sm underline underline-offset-4 hover:text-primary">
                Mot de passe oublié ?
              </a>
            </div>
          </div>
        </div>

        <!-- Confirmation -->
        <div class="w-full flex item-center justify-center">
          <Button type="submit" class="w-45 h-12 rounded-2xl text-md" style="background-color: #7D6BFB"
            :disabled="isSubmitting">
            <svg v-if="isSubmitting" class="mr-2 h-4 w-4 animate-spin" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
              <path class="opacity-75" fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
            </svg>
            {{ isSubmitting ? "Connexion..." : "Se connecter" }}
          </Button>
        </div>
      </form>
    </template>
    <template #sidebar>
      <div class="relative flex items-center justify-center">
        <div class="text-center text-white p-8">
          <h2 class="text-3xl mb-4">
            <span>Bon retour sur </span>
            <span class="font-bold">Study App !</span>
          </h2>
        </div>
      </div>
    </template>
    <template #links>
      <div class="text-center text-sm">
        Pas encore de compte ?
        <a :href="links.register" class="underline underline-offset-4 hover:text-primary">S'inscrire</a>
      </div>
    </template>

  </AuthLayout>
</template>