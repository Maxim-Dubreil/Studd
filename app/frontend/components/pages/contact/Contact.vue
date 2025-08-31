<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import { Button } from '@/components/ui/button';
  import { reactive } from 'vue';
  import NavbarLanding from '../landingPage/NavbarLanding.vue';

  interface Props {
    left: Array<{ label: string; url: string }>;
    center: Array<{ label: string; url: string }>;
    right: Array<{
      label: string;
      url: string;
      variant?: 'default' | 'gradient' | 'outline' | 'link';
      data?: Record<string, any>;
    }>;
  }

  const props = defineProps<Props>();

  // --- Team (4 personnes) -------------------------------------------------
  const team = reactive([
    {
      id: 1,
      name: 'Yannis',
      role: 'Backend - Machine Learning - Data Architect',
      email: 'yannis.djaffer@epitech.eu',
      avatar: '/images/team/yannis.jpg',
    },
    {
      id: 2,
      name: 'Théo ',
      role: 'Backend - Machine Learning - Design',
      email: 'theo.lordelot@epitech.eu',
      avatar: '/images/team/theo.jpg',
    },
    {
      id: 3,
      name: 'Yohann',
      role: 'Frontend - Test Manager, CI/CD',
      email: 'yohann.provost@epitech.eu',
      avatar: '/images/team/yohann.jpg',
    },
    {
      id: 4,
      name: 'Maxim',
      role: 'Frontend - UI/UX - DevOps - Design',
      email: 'maxim.dubreil@epitech.eu',
      avatar: '/images/team/maxim.jpg',
    },
  ]);

  // mini-formulaires (un par personne)
  const forms = reactive(team.map(() => ({ fromEmail: '', message: '' })));

  function sendMessage(idx: number) {
    const person = team[idx];
    const data = forms[idx];
    console.log('[Contact]', person.name, data);
    alert(`Message envoyé à ${person.name} 👌`);
    data.fromEmail = '';
    data.message = '';
  }

  // --- Carte (adresse & coordonnées) -------------------------------------
  const org = {
    name: 'Epitech Rennes — Villejean',
    address: '12 Rue Jean-Louis Bertrand, 35000 Rennes, France',
    lat: 48.12457,
    lon: -1.69726,
  };

  // Helper pour le lien OSM plein écran
  function osmLink(lat: number, lon: number, zoom = 15) {
    return `https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=${zoom}/${lat}/${lon}`;
  }
</script>

<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="false" :hideGradient="false">
    <!-- NAVBAR -->
    <div class="flex justify-center px-4">
      <NavbarLanding :left="props.left" :center="props.center" :right="props.right" />
    </div>

    <!-- HERO / ENTÊTE -->
    <section class="relative overflow-hidden">
      <div
        aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-10 bg-gradient-to-b from-indigo-50/70 via-transparent to-transparent dark:from-indigo-950/30"
      />
      <div class="mx-auto max-w-screen-xl px-4 py-14">
        <div class="mx-auto max-w-3xl text-center">
          <h1 class="text-3xl leading-tight font-bold md:text-5xl">Contact</h1>
          <p class="text-muted-foreground mt-3 md:text-lg">
            One team, four points of contact. Write directly to the right person.
          </p>
        </div>
      </div>
    </section>

    <!-- TEAM CONTACT (4 cartes + mini-formulaires) -->
    <section class="mx-auto max-w-screen-xl px-4 pb-16 md:pb-24">
      <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        <div
          v-for="(p, idx) in team"
          :key="p.id"
          class="group flex flex-col rounded-2xl border bg-white/60 p-5 shadow-sm transition hover:shadow-md"
        >
          <!-- Header personne -->
          <div class="flex items-center gap-3">
            <div class="relative h-12 w-12 shrink-0 overflow-hidden rounded-full border">
              <img
                :src="
                  p.avatar ||
                  'https://api.dicebear.com/8.x/initials/svg?seed=' + encodeURIComponent(p.name)
                "
                :alt="p.name"
                class="h-full w-full object-cover"
                loading="lazy"
                decoding="async"
              />
            </div>
            <div>
              <div class="text-sm font-semibold">{{ p.name }}</div>
              <div class="text-xs text-slate-500">{{ p.role }}</div>
            </div>
          </div>

          <!-- Coordonnées -->
          <div class="mt-3 grid gap-1 text-sm">
            <a :href="'mailto:' + p.email" class="text-indigo-600 hover:underline">{{ p.email }}</a>
          </div>

          <!-- Formulaire court -->
          <form class="mt-4 grid gap-3" @submit.prevent="sendMessage(idx)">
            <div class="grid gap-1">
              <label class="text-xs font-medium text-slate-600" :for="'email-' + p.id">
                Votre email
              </label>
              <input
                :id="'email-' + p.id"
                v-model="forms[idx].fromEmail"
                type="email"
                required
                placeholder="vous@exemple.com"
                class="h-10 rounded-md border border-slate-200 bg-white px-3 text-sm ring-0 transition outline-none focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400"
              />
            </div>
            <div class="grid gap-1">
              <label class="text-xs font-medium text-slate-600" :for="'msg-' + p.id">Message</label>
              <textarea
                :id="'msg-' + p.id"
                v-model="forms[idx].message"
                rows="3"
                required
                placeholder="Expliquez votre besoin…"
                class="rounded-md border border-slate-200 bg-white px-3 py-2 text-sm ring-0 transition outline-none focus:border-indigo-400 focus:ring-1 focus:ring-indigo-400"
              />
            </div>
            <Button type="submit" variant="gradient" class="justify-center">Send</Button>
          </form>
        </div>
      </div>
    </section>

    <!-- LOCALISATION / MAP -->
    <section class="mx-auto max-w-screen-xl px-4 pb-20">
      <div class="grid gap-6 md:grid-cols-2">
        <div class="rounded-2xl border bg-white/60 p-6 shadow-sm">
          <div class="text-xs font-semibold text-slate-500">Où nous trouver</div>
          <h3 class="mt-1 text-lg font-semibold">{{ org.name }}</h3>
          <p class="text-muted-foreground mt-1 text-sm">{{ org.address }}</p>

          <div class="mt-4 inline-flex items-center text-sm font-medium text-indigo-600">
            <svg
              class="mr-1 h-4 w-4"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M21 10c0 7-9 12-9 12S3 17 3 10a9 9 0 1 1 18 0Z" />
              <circle cx="12" cy="10" r="3" />
            </svg>
            <a
              :href="osmLink(org.lat, org.lon)"
              target="_blank"
              rel="noopener"
              class="hover:underline"
            >
              Ouvrir dans OpenStreetMap
            </a>
          </div>
        </div>

        <div class="overflow-hidden rounded-2xl border shadow-sm">
          <!-- OpenStreetMap embed, marker sur Paris par défaut -->
          <iframe
            :src="`https://www.openstreetmap.org/export/embed.html?bbox=${org.lon - 0.02}%2C${org.lat - 0.015}%2C${org.lon + 0.02}%2C${org.lat + 0.015}&layer=mapnik&marker=${org.lat}%2C${org.lon}`"
            style="width: 100%; height: 360px; border: 0"
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
          />
        </div>
      </div>
    </section>

    <!-- FOOTER LÉGER -->
    <footer class="border-t">
      <div class="mx-auto flex max-w-screen-xl items-center justify-between gap-4 px-4 py-8">
        <p class="text-muted-foreground text-xs">© {{ new Date().getFullYear() }} StudyApp</p>
        <div class="flex items-center gap-4 text-xs">
          <a href="/legal" class="hover:underline">Legal</a>
          <a href="/privacy" class="hover:underline">Privacy</a>
          <a href="/contact" class="hover:underline">Contact</a>
        </div>
      </div>
    </footer>
  </AppLayout>
</template>

<style scoped>
  @media (max-width: 380px) {
    .team-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
