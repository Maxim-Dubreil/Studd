<script setup lang="ts">
  import AppLayout from '@/components/layout/AppLayout.vue';
  import NavbarLanding from '../landingPage/NavbarLanding.vue';

  interface NavItem {
    label: string;
    url: string;
    variant?: 'default' | 'gradient' | 'outline' | 'link';
    data?: Record<string, any>;
  }
  const props = defineProps<{ left: NavItem[]; center: NavItem[]; right: NavItem[] }>();

  type Concept = { id: string; title: string; desc: string; };
  const concepts: Concept[] = [
    { id: 'create-workspace', title: 'Create Workspace', desc: 'Create a new workspace for your projects and documents.' },
    { id: 'studysheet',       title: 'StudySheet',       desc: 'Structured course sheet (sections, summaries, links, tasks).' },
    { id: 'flashcards',       title: 'Flashcards',       desc: 'Short Q/A cards for active memorization (spaced repetition).' },
    { id: 'collection',       title: 'Create a Collection', desc: 'Group flashcards by theme, chapter, or course.' },
    { id: 'quiz-generate',    title: 'Generate Quiz',    desc: 'Automatically generate a quiz from a text or sheet.' },
    { id: 'quiz',             title: 'Quiz',             desc: 'Quick evaluation session: score, correction, explanations.' },
    { id: 'quiz-learning',    title: 'Quiz Learning',    desc: 'Learning mode with short and repeated sessions.' },
    { id: 'mindmap',          title: 'MindMap',          desc: 'Mind map to organize ideas, concepts, and links.' },
  ];
</script>

<template>
  <AppLayout :hideSidebar="true" :hideToggle="false" :hideGradient="false">
    <div class="flex justify-center px-4">
      <NavbarLanding :left="props.left" :center="props.center" :right="props.right" />
    </div>

    <div class="mx-auto max-w-screen-xl px-4 py-16 pt-32">
      <h1 class="text-3xl font-bold md:text-5xl">Documentation</h1>
      <p class="text-muted-foreground mt-3 md:text-lg">
        User guides, FAQ, and examples.
      </p>

      <!-- Concepts grid -->
      <div class="mt-10 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        <a
          v-for="c in concepts"
          :key="c.id"
          :href="`#${c.id}`"
          class="group block rounded-2xl border bg-card p-5 transition
                 hover:shadow-md hover:border-primary/50"
        >
          <div class="mb-2 flex items-center justify-between">
            <h3 class="text-lg font-semibold tracking-tight">{{ c.title }}</h3>
            <span
              class="inline-flex h-7 min-w-7 items-center justify-center rounded-full border px-2 text-xs
                     text-muted-foreground group-hover:border-primary/40 group-hover:text-primary"
              aria-hidden="true"
            >
              #
            </span>
          </div>
          <p class="text-sm text-muted-foreground">
            {{ c.desc }}
          </p>
        </a>
      </div>

      <!-- Anchor placeholders (minimal — titles only) -->
      <div class="sr-only">
        <div v-for="c in concepts" :key="c.id" :id="c.id">{{ c.title }}</div>
      </div>
    </div>
  </AppLayout>
</template>