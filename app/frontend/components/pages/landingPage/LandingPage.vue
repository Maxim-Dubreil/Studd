<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import { Button } from '@/components/ui/button';
  import NavbarLanding from './NavbarLanding.vue';

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
  const features = [
    {
      title: 'AI Generation',
      desc: 'Create revision notes and summaries in one click from your courses.',
      href: '/workspaces',
    },
    {
      title: 'Course Import',
      desc: 'Import your courses and keep everything in one place.',
      href: '/workspaces',
    },
    {
      title: 'Workspaces',
      desc: 'Organize your subjects, projects, and content to stay in control.',
      href: '/workspaces',
    },
    {
      title: 'Quizzes & Revision',
      desc: 'Auto quizzes, flashcards, spaced repetition, progress tracking.',
      href: '/workspaces',
    },
  ];
</script>

<template>
  <AppLayout :hideSidebar="true" :hideToggle="false" :hideGradient="false" :hideHelper="false">
    <section class="relative overflow-hidden">
      <!-- NAVBAR EXISTANTE (inchangée) -->
      <div class="flex justify-center px-4">
        <NavbarLanding :left="props.left" :center="props.center" :right="props.right" />
      </div>

      <!-- HERO -->
      <div
        aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-10 bg-gradient-to-b from-indigo-50/70 via-transparent to-transparent dark:from-indigo-950/30"
      />
      <div
        class="mx-auto grid max-w-screen-xl grid-cols-1 gap-10 px-4 py-16 md:grid-cols-2 md:py-24"
      >
        <div class="flex flex-col justify-center">
          <h1 class="text-3xl leading-tight font-bold md:text-5xl">
            Studd — Courses, AI, Quizzes, mind maps & Revision in one place.
          </h1>
          <p class="text-muted-foreground mt-4 md:text-lg">
            Import your courses, generate summaries and mind maps with AI, revise with quizzes, and
            track your progress.
          </p>
          <div class="mt-6 flex flex-wrap items-center gap-3">
            <Button as="a" href="/users/sign_up" variant="gradient" size="lg">
              Create an account now
            </Button>
            <Button as="a" href="/users/sign_in" variant="outline" size="lg">Sign in</Button>
          </div>
        </div>

        <!-- Placeholder visuel (remplacé) -->
        <div class="flex items-center justify-center">
          <div
            class="bg-background/60 w-full rounded-2xl border p-2 shadow-lg md:max-w-xl lg:max-w-2xl"
          >
            <div class="grid gap-2">
              <!-- GIF #1 : grand, ratio confortable -->
              <div
                class="bg-muted relative aspect-[16/10] overflow-hidden rounded-xl border md:aspect-[16/9] lg:aspect-[21/9]"
              >
                <img
                  src="../../../images/landingPage/create.gif"
                  alt="Create workspace"
                  class="absolute inset-0 h-full w-full scale-[1.12] object-center"
                  decoding="async"
                />
              </div>

              <!-- GIF #2 : idem, un peu plus large en desktop -->
              <div
                class="bg-muted relative aspect-[16/10] overflow-hidden rounded-xl border md:aspect-[16/9]"
              >
                <img
                  src="../../../images/landingPage/in.gif"
                  alt="In workspace"
                  class="absolute inset-0 h-full w-full scale-[1.20] object-cover object-center"
                  decoding="async"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- FEATURES -->
    <section id="features" class="mx-auto max-w-screen-xl px-4 pb-16 md:pb-24">
      <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        <a
          v-for="(f, i) in features"
          :key="f.title"
          :href="f.href"
          class="group block rounded-2xl border p-6 shadow-sm transition hover:shadow-md"
        >
          <h3 class="mt-1 text-lg font-semibold">{{ i + 1 }}. {{ f.title }}</h3>
          <p class="text-muted-foreground mt-2 text-sm">
            {{ f.desc }}
          </p>
          <div
            class="mt-4 inline-flex items-center text-sm font-medium text-indigo-600 group-hover:underline"
          >
            Learn more
            <svg
              class="ml-1 h-4 w-4 transition group-hover:translate-x-0.5"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="M5 12h14" />
              <path d="m12 5 7 7-7 7" />
            </svg>
          </div>
        </a>
      </div>
    </section>

    <!-- HOW IT WORKS -->
    <section class="mx-auto max-w-screen-xl px-4 pb-16 md:pb-12">
      <div class="grid gap-4 md:grid-cols-4">
        <div class="rounded-xl border bg-white/40 p-5">
          <div class="text-muted-foreground text-xs font-semibold">Step 1</div>
          <h4 class="mt-1 font-semibold">Import your courses</h4>
          <p class="text-muted-foreground mt-2 text-sm">
            PDF, DOCX, links, Paste textes, we centralize everything.
          </p>
        </div>
        <div class="rounded-xl border bg-white/40 p-5">
          <div class="text-muted-foreground text-xs font-semibold">Step 2</div>
          <h4 class="mt-1 font-semibold">Generate flashcards, summaries, mind maps for learning</h4>
          <p class="text-muted-foreground mt-2 text-sm">
            AI, will extract the essentials, cleanly.
          </p>
        </div>
        <div class="rounded-xl border bg-white/40 p-5">
          <div class="text-muted-foreground text-xs font-semibold">Step 3</div>
          <h4 class="mt-1 font-semibold">Revise with quizzes</h4>
          <p class="text-muted-foreground mt-2 text-sm">Quizzes + spaced repetition + stats.</p>
        </div>
        <div class="rounded-xl border bg-white/40 p-5">
          <div class="text-muted-foreground text-xs font-semibold">Step 4</div>
          <h4 class="mt-1 font-semibold">You are Ready for exam!</h4>
          <p class="text-muted-foreground mt-2 text-sm">Continue to train, and learn with us!</p>
        </div>
      </div>
      <div class="mt-12 flex justify-center">
        <Button as="a" href="/users/sign_up" variant="gradient" size="lg">Get started</Button>
      </div>
    </section>

    <!-- FOOTER (léger) -->
    <footer class="border-t">
      <div class="mx-auto flex max-w-screen-xl items-center justify-between gap-4 px-4 py-8">
        <p class="text-muted-foreground text-xs">© {{ new Date().getFullYear() }} Studd</p>
        <div class="flex items-center gap-4 text-xs">
          <p>
            an
            <span class="text-blue-500">{Epitech}</span>
            Project
          </p>
          <p>|</p>
          <a href="/contact" class="hover:underline">Contact</a>
        </div>
      </div>
    </footer>
  </AppLayout>
</template>
