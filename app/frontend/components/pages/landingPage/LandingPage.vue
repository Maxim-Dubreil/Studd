<script setup lang="ts">
import AppLayout from '@/components/layout/AppLayout.vue'
import NavbarLanding from './NavbarLanding.vue'
import { Button } from '@/components/ui/button'

interface Props {
  left: Array<{ label: string; url: string }>
  center: Array<{ label: string; url: string }>
  right: Array<{
    label: string
    url: string
    variant?: 'default' | 'gradient' | 'outline' | 'link'
    data?: Record<string, any>
  }>
}
const props = defineProps<Props>()
const features = [
  {
    title: 'AI Generation',
    desc: 'Create revision notes and summaries in one click from your courses.',
    href: '/workspaces',
  },
  {
    title: 'Course Import',
    desc: 'Import your courses (PDF, DOCX, links) and keep everything in one place.',
    href: '/workspaces',
  },
  {
    title: 'Workspaces',
    desc: 'Organize by subject/project, collaborate in teams, keep control.',
    href: '/workspaces',
  },
  {
    title: 'Quizzes & Revision',
    desc: 'Auto quizzes, flashcards, spaced repetition, progress tracking.',
    href: '/workspaces',
  },
]
</script>

<template>
  <AppLayout :hideSidebar="true" :hideTopNav="true" :hideToggle="false" :hideGradient="false">
    <section class="relative overflow-hidden">

      <!-- NAVBAR EXISTANTE (inchangée) -->
      <div class="flex justify-center px-4">
        <NavbarLanding :left="props.left" :center="props.center" :right="props.right" />
      </div>

      <!-- HERO -->
      <div aria-hidden="true"
        class="pointer-events-none absolute inset-0 -z-10 bg-gradient-to-b from-indigo-50/70 via-transparent to-transparent dark:from-indigo-950/30" />
      <div class="mx-auto grid max-w-screen-xl grid-cols-1 gap-10 px-4 py-16 md:grid-cols-2 md:py-24">
        <div class="flex flex-col justify-center">
          <h1 class="text-3xl font-bold leading-tight md:text-5xl">
            StudyApp — Courses, AI, Quizzes & Revision in one place.
          </h1>
          <p class="mt-4 text-muted-foreground md:text-lg">
            Import your courses, generate summaries with AI, revise with quizzes, and track your progress.
          </p>
          <div class="mt-6 flex flex-wrap items-center gap-3">
            <Button as="a" href="/users/sign_up" variant="gradient" size="lg">
              Create an account
            </Button>
            <Button as="a" href="/users/sign_in" variant="outline" size="lg">
              Sign in
            </Button>
          </div>
        </div>

        <!-- Placeholder visuel (remplacé) -->
        <div class="flex items-center justify-center">
          <div class="w-full md:max-w-xl lg:max-w-2xl rounded-2xl border bg-background/60 p-2 shadow-lg">

            <div class="grid gap-2">
              <!-- GIF #1 : grand, ratio confortable -->
              <div
                class="relative overflow-hidden rounded-xl border bg-muted aspect-[16/10] md:aspect-[16/9] lg:aspect-[21/9]">
                <img src="../../../images/landingPage/create.gif" alt="Create workspace"
                  class="absolute inset-0 h-full w-full  object-center scale-[1.12]" decoding="async" />
              </div>

              <!-- GIF #2 : idem, un peu plus large en desktop -->
              <div class="relative overflow-hidden rounded-xl border bg-muted aspect-[16/10] md:aspect-[16/9]">
                <img src="../../../images/landingPage/in.gif" alt="In workspace"
                  class="absolute inset-0 h-full w-full object-cover object-center scale-[1.20]" decoding="async" />
              </div>
            </div>

          </div>
        </div>
      </div>
    </section>

    <!-- FEATURES -->
    <section id="features" class="mx-auto max-w-screen-xl px-4 pb-16 md:pb-24">
      <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
        <a v-for="f in features" :key="f.title" :href="f.href"
          class="group block rounded-2xl border p-6 shadow-sm transition hover:shadow-md">
          <div class="text-sm font-semibold text-indigo-600">{{ f.title }}</div>
          <h3 class="mt-1 text-lg font-semibold">{{ f.title }}</h3>
          <p class="mt-2 text-sm text-muted-foreground">
            {{ f.desc }}
          </p>
          <div class="mt-4 inline-flex items-center text-sm font-medium text-indigo-600 group-hover:underline">
            Learn more
            <svg class="ml-1 h-4 w-4 transition group-hover:translate-x-0.5" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M5 12h14" />
              <path d="m12 5 7 7-7 7" />
            </svg>
          </div>
        </a>
      </div>
    </section>

    <!-- HOW IT WORKS -->
    <section class="mx-auto max-w-screen-xl px-4 pb-16 md:pb-24">
      <div class="grid gap-4 md:grid-cols-3">
        <div class="rounded-xl border p-5">
          <div class="text-xs font-semibold text-muted-foreground">Step 1</div>
          <h4 class="mt-1 font-semibold">Import your courses</h4>
          <p class="mt-2 text-sm text-muted-foreground">PDF, DOCX, links. We centralize everything.</p>
        </div>
        <div class="rounded-xl border p-5">
          <div class="text-xs font-semibold text-muted-foreground">Step 2</div>
          <h4 class="mt-1 font-semibold">Generate flashcards & summaries</h4>
          <p class="mt-2 text-sm text-muted-foreground">AI to extract the essentials, cleanly.</p>
        </div>
        <div class="rounded-xl border p-5">
          <div class="text-xs font-semibold text-muted-foreground">Step 3</div>
          <h4 class="mt-1 font-semibold">Revise with quizzes</h4>
          <p class="mt-2 text-sm text-muted-foreground">Quizzes + spaced repetition + stats.</p>
        </div>
      </div>
      <div class="mt-6 flex justify-center">
        <Button as="a" href="/users/sign_up" variant="gradient" size="lg">Get started</Button>
      </div>
    </section>

    <!-- FOOTER (léger) -->
    <footer class="border-t">
      <div class="mx-auto flex max-w-screen-xl items-center justify-between gap-4 px-4 py-8">
        <p class="text-xs text-muted-foreground">© {{ new Date().getFullYear() }} StudyApp</p>
        <div class="flex items-center gap-4 text-xs">
          <a href="/legal" class="hover:underline">Legal</a>
          <a href="/privacy" class="hover:underline">Privacy</a>
          <a href="/contact" class="hover:underline">Contact</a>
        </div>
      </div>
    </footer>
  </AppLayout>
</template>
