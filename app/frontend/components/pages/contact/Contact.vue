<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import Icon from '@/components/ui//icon/Icon.vue';
  import { Button } from '@/components/ui/button';
  import { reactive, ref } from 'vue';
  import maximAvatar from '../../../images/team/maxim.png';
  import theoAvatar from '../../../images/team/theo.png';
  import yannisAvatar from '../../../images/team/yannis.png';
  import yohannAvatar from '../../../images/team/yohann.png';
  import NavbarLanding from '../landingPage/NavbarLanding.vue';

  interface NavItem {
    label: string;
    url: string;
  }
  interface RightItem extends NavItem {
    variant?: 'default' | 'gradient' | 'outline' | 'link';
    data?: Record<string, any>;
  }
  interface Props {
    left: NavItem[];
    center: NavItem[];
    right: RightItem[];
  }
  const props = defineProps<Props>();

  // --- Team -------------------------------------------------
  const team = reactive([
    {
      id: 1,
      name: 'Yannis',
      role: 'Backend - Machine Learning - Data Architect',
      email: 'yannis.djaffer@epitech.eu',
      avatar: yannisAvatar,
    },
    {
      id: 2,
      name: 'Théo ',
      role: 'Backend - Machine Learning - Design',
      email: 'theo.lordelot@epitech.eu',
      avatar: theoAvatar,
    },
    {
      id: 3,
      name: 'Yohann',
      role: 'Frontend - Test Manager, CI/CD',
      email: 'yohann.provost@epitech.eu',
      avatar: yohannAvatar,
    },
    {
      id: 4,
      name: 'Maxim',
      role: 'Frontend - UI/UX - DevOps - Design',
      email: 'maxim.dubreil@epitech.eu',
      avatar: maximAvatar,
    },
  ]);

  // --- Localisation -------------------------------------------------------
  const org = {
    name: 'Epitech Rennes — Villejean',
    address: '12 Rue Jean-Louis Bertrand, 35000 Rennes, France',
    lat: 48.12457,
    lon: -1.69726,
  };
  function osmLink(lat: number, lon: number, zoom = 15) {
    return `https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=${zoom}/${lat}/${lon}`;
  }

  const copiedFor = ref<number | null>(null);

  async function copyEmail(email: string, id: number) {
    try {
      await navigator.clipboard.writeText(email);
      copiedFor.value = id;
      setTimeout(() => (copiedFor.value = null), 1800);
    } catch {
      // Fallback
      alert('Impossible to copy, here the email: ' + email);
    }
  }
</script>

<template>
  <AppLayout :hideSidebar="true" :hideToggle="false" :hideHelper="true" :hideGradient="false">
    <!-- NAVBAR -->
    <div class="flex justify-center px-4">
      <NavbarLanding :left="props.left" :center="props.center" :right="props.right" />
    </div>

    <!-- HERO -->
    <section class="relative overflow-hidden">
      <div
        aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-10 bg-gradient-to-b from-indigo-50/70 via-transparent to-transparent dark:from-indigo-950/30"
      />
      <div class="mx-auto max-w-screen-xl px-4 py-16 pt-32">
        <div class="mx-auto max-w-3xl text-center">
          <h1 class="text-3xl leading-tight font-bold md:text-5xl">Contact</h1>
          <p class="text-muted-foreground mt-3 md:text-lg">
            Need help? Have questions? Our team is here to assist you. Reach out to us via email or
            explore our student location below.
          </p>
        </div>
      </div>
    </section>

    <!-- TEAM CONTACT (cartes) -->
    <section class="mx-auto max-w-screen-xl px-4 pb-16 md:pb-24">
      <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        <div v-for="p in team" :key="p.id" class="group relative rounded-2xl">
          <!-- Gradient ring / halo -->
          <div
            class="absolute inset-0 -z-10 rounded-2xl bg-gradient-to-br from-indigo-300/25 via-fuchsia-300/20 to-emerald-300/25 opacity-0 blur-[6px] transition-opacity duration-300 group-hover:opacity-100"
          />
          <div
            class="rounded-2xl border border-slate-200 bg-white/70 p-6 shadow-sm backdrop-blur transition group-hover:-translate-y-0.5 group-hover:shadow-md supports-[backdrop-filter]:bg-white/60"
          >
            <!-- Header personne -->
            <div class="flex items-center gap-4">
              <div
                class="relative h-12 w-12 shrink-0 overflow-hidden rounded-full border border-slate-200"
              >
                <img :src="p.avatar" :alt="p.name" class="h-full w-full object-cover" />
              </div>
              <div>
                <div class="text-md font-bold">{{ p.name }}</div>
                <div class="text-sm text-slate-500">{{ p.role }}</div>
              </div>
            </div>

            <!-- Coordonnées / chips -->
            <div class="mt-10 flex items-center gap-2">
              <span
                class="inline-flex items-center rounded-2xl border border-slate-200 px-2.5 py-2.5 text-[12px] font-medium text-slate-600"
              >
                <Icon name="mail" class="mr-2 h-4 w-4" />
                {{ p.email }}
              </span>
              <Button
                variant="outline"
                class="h-9 px-3"
                :aria-label="`Copier ${p.email}`"
                @click="copyEmail(p.email, p.id)"
              >
                <Icon name="copy" />
              </Button>
            </div>

            <!-- Actions -->
            <div class="mt-4 flex items-center justify-center gap-2">
              <a class="inline-flex" :href="'mailto:' + p.email" aria-label="Send an email">
                <Button variant="gradient" class="h-9 px-3">
                  <Icon name="send" />
                  Open in mail app
                </Button>
              </a>

              <!-- Feedback copie -->
              <span v-if="copiedFor === p.id" class="ml-1 text-xs font-medium text-emerald-600">
                Copié ✓
              </span>
            </div>

            <!-- Micro-footer (CTA léger) -->
            <div
              class="mt-4 border-t border-dashed border-slate-200 pt-3 text-[11px] text-slate-500"
            >
              <p>Will respond surely :)</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- LOCALISATION / MAP -->
    <section class="mx-auto max-w-screen-xl px-4 pb-20">
      <div class="w-max-250px gap-6">
        <div class="rounded-t-2xl border bg-white/60 p-6 shadow-sm">
          <div class="text-xs font-semibold text-slate-500">Where you can find us ></div>
          <h3 class="mt-1 text-lg font-semibold">{{ org.name }}</h3>
          <p class="text-muted-foreground mt-1 text-sm">{{ org.address }}</p>

          <div class="mt-4 inline-flex items-center text-sm font-medium text-indigo-600">
            <Icon name="map-pin" class="mr-2 h-5 w-5" />
            <a
              :href="osmLink(org.lat, org.lon)"
              target="_blank"
              rel="noopener"
              class="hover:underline"
            >
              Open in OpenStreetMap
            </a>
          </div>
        </div>

        <div class="overflow-hidden rounded-b-2xl border shadow-sm">
          <iframe
            :src="`https://www.openstreetmap.org/export/embed.html?bbox=${org.lon - 0.02}%2C${org.lat - 0.015}%2C${org.lon + 0.02}%2C${org.lat + 0.015}&layer=mapnik&marker=${org.lat}%2C${org.lon}`"
            style="width: 100%; height: 450px; border: 0"
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
          />
        </div>
      </div>
    </section>

    <!-- FOOTER -->
    <footer class="border-t">
      <div class="mx-auto flex max-w-screen-xl items-center justify-between gap-4 px-4 py-8">
        <p class="text-muted-foreground text-xs">© {{ new Date().getFullYear() }} Studd</p>
        <div class="flex items-center gap-4 text-xs">
          <p>
            an
            <span class="text-blue-500">{Epitech}</span>
            Project
          </p>
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
