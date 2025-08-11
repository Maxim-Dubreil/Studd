<script setup lang="ts">
  import Button from '@/components/ui/button/Button.vue';
  import { Input } from '@/components/ui/input';
  import { Label } from '@/components/ui/label';
  import { ref } from 'vue';

  import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
  } from '@/components/ui/card';

  const showModal = ref(false);
  const userName = ref('John Doe');
  const userEmail = ref('john.doe@example.com');

  const emit = defineEmits(['profile-updated']);

  const openModal = () => {
    showModal.value = true;
  };

  const closeModal = () => {
    showModal.value = false;
    userName.value = 'John Doe';
    userEmail.value = 'john.doe@example.com';
  };

  const saveProfile = async () => {
    if (userName.value.trim() === '' || userEmail.value.trim() === '') {
      alert('Veuillez renseigner tous les champs.');
      return;
    }

    // Mock data - simulate API call
    const mockUserProfile = {
      id: 1,
      name: userName.value,
      email: userEmail.value,
      updatedAt: new Date().toISOString(),
    };

    emit('profile-updated', mockUserProfile);
    closeModal();
  };

  defineExpose({
    openModal,
  });
</script>

<template>
  <div
    v-if="showModal"
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/10 backdrop-blur-sm"
  >
    <Card class="w-[350px]">
      <CardHeader class="pt-6 pb-4">
        <CardTitle>Vos données utilisateur</CardTitle>
        <CardDescription>Modifiez vos informations personnelles.</CardDescription>
      </CardHeader>
      <CardContent>
        <form @submit.prevent="saveProfile">
          <div class="grid w-full items-center gap-6">
            <div class="flex flex-col space-y-1.5">
              <Label for="user-name">Nom</Label>
              <Input id="user-name" v-model="userName" placeholder="Nom actuel" required />
            </div>
            <div class="flex flex-col space-y-1.5">
              <Label for="user-email">Email</Label>
              <Input id="user-email" v-model="userEmail" placeholder="Email actuel" required />
            </div>
          </div>
        </form>
      </CardContent>
      <CardFooter class="flex justify-between px-6 pt-8 pb-6">
        <Button variant="outline" @click="closeModal">Annuler</Button>
        <Button @click="saveProfile">Sauvegarder</Button>
      </CardFooter>
    </Card>
  </div>
</template>
