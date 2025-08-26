<script setup lang="ts">
import { ref } from "vue";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";

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
          <div class="flex items-center">
            <Label for="password">Password</Label>
            <a :href="links.forgot" class="ml-auto inline-block text-sm underline">
              Forgot password?
            </a>

          </div>
          <Input id="password" v-model="password" type="password" required :disabled="isSubmitting" />
          <!-- Checkbox - remember -->
          <div className="flex items-center justify-center gap-2 pt-1">
            <Checkbox id="remember" v-model="rememberMe" :disabled="isSubmitting" />
            <Label for="remember" class="">Remember me</Label>
          </div>
        </div>
        <!-- Confirmation -->
        <div class="w-full flex item-center justify-center">
          <Button type="submit" variant="gradient" size="lg" class="w-45 radius-xl" :disabled="isSubmitting">
            <svg v-if="isSubmitting" class="mr-2 h-4 w-4 animate-spin" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
              <path class="opacity-75" fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
            </svg>
            {{ isSubmitting ? "wait for connection..." : "Sign In" }}
          </Button>
        </div>
      </form>
    </template>
    <template #sidebar>
      <div class="relative flex items-center justify-center">
        <div class="text-center text-white p-8">
          <h2 class="text-2xl mb-4">
            <span>Welcome back to </span>
            <span class="font-bold">Study App !</span>
          </h2>
        </div>
      </div>
    </template>
    <template #links>
      <div class="text-center text-sm">
        Didn't have an account yet?
        <a :href="links.register" class="underline underline-offset-4 hover:text-primary">Sign Up</a>
      </div>
    </template>

  </AuthLayout>
</template>