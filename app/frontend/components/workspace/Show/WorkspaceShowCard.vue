<template>
  <a
    :href="href"
    :class="[
      // Layout & base
      'group relative col-span-3 flex flex-col overflow-hidden rounded-2xl cursor-pointer',
      'bg-white/90 backdrop-blur-sm shadow-xl border border-white/50',
      'dark:border dark:border-white/10 dark:bg-black/80 dark:shadow-[inset_0_-20px_80px_-20px_#ffffff0f]',
      'transition-all duration-500 hover:shadow-2xl hover:scale-[1.02] hover:-translate-y-1',
      'before:absolute before:inset-0 before:rounded-2xl before:bg-gradient-to-br before:opacity-0 before:transition-opacity before:duration-300',
      getCardTheme(),
      cls,
    ]"
  >
    <div class="absolute inset-0 overflow-hidden rounded-2xl">
      <div :class="getBackgroundGradient()" class="absolute inset-0 opacity-20 group-hover:opacity-30 transition-opacity duration-500"></div>
      
      <div class="absolute top-4 right-4 w-16 h-16 rounded-full opacity-10 group-hover:opacity-20 transition-all duration-700 group-hover:scale-110" :class="getAccentColor()"></div>
      <div class="absolute bottom-6 left-6 w-12 h-12 rounded-full opacity-10 group-hover:opacity-20 transition-all duration-700 delay-100 group-hover:scale-110" :class="getAccentColor()"></div>
      
      <div class="absolute inset-0 opacity-5 group-hover:opacity-10 transition-opacity duration-500" 
           style="background-image: radial-gradient(circle, currentColor 1px, transparent 1px); background-size: 20px 20px;"
           :class="getTextColor()"></div>
           
      <img
        v-if="bgImage"
        :src="bgImage"
        alt=""
        class="absolute inset-0 h-full w-full object-cover opacity-20 transition-all duration-500 group-hover:opacity-30 group-hover:scale-105"
      />
    </div>

    <!-- Contenu principal -->
    <div
      class="pointer-events-none z-20 mt-auto flex transform-gpu flex-col gap-2 p-6 transition-all duration-500 group-hover:-translate-y-8"
    >
      <component
        :is="Icon"
        :class="`h-12 w-12 transition-all duration-500 group-hover:scale-110 group-hover:rotate-12 ${getIconColor()}`"
      />
      <div class="relative inline-block">
        <div class="absolute inset-0 rounded-lg opacity-20 group-hover:opacity-30 transition-opacity duration-300" :class="getAccentColor()"></div>
        <h3 :class="`relative text-xl font-bold transition-colors duration-300 px-3 py-1 ${getTextColor()}`">{{ name }}</h3>
      </div>
      <p class="text-sm text-gray-600 dark:text-gray-300 leading-relaxed">{{ desc }}</p>
    </div>

    <div
      class="pointer-events-none absolute bottom-0 flex w-full translate-y-10 transform-gpu p-4 opacity-0 transition-all duration-500 group-hover:translate-y-0 group-hover:opacity-100"
    >
      <div
        :class="`inline-flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-semibold transition-all duration-300 ${getCtaStyles()}`"
      >
        {{ cta }}
        <ArrowRight class="h-4 w-4 transition-transform duration-300 group-hover:translate-x-1" />
      </div>
    </div>

    <div
      class="pointer-events-none absolute inset-0 transition-all duration-500 group-hover:bg-white/10 dark:group-hover:bg-black/20"
    />
    
    <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-700">
      <div class="absolute inset-0 -skew-x-12 bg-gradient-to-r from-transparent via-white/20 to-transparent transform translate-x-[-100%] group-hover:translate-x-[200%] transition-transform duration-1000 ease-out"></div>
    </div>
  </a>
</template>

<script setup lang="ts">
  import { ArrowRight } from 'lucide-vue-next';

  const props = defineProps<{
    name: string;
    desc: string;
    href: string;
    cta: string;
    Icon: any;
    cls?: string;
    bgImage?: string;
  }>();

  /* On garde 'cls' dans le template directement : pas besoin de destructurer. */
  const { cls } = props;
  
  const getCardTheme = () => {
    const name = props.name.toLowerCase();
    if (name.includes('quiz')) {
      return 'hover:before:from-purple-500/20 hover:before:to-indigo-500/20 hover:before:opacity-100';
    } else if (name.includes('study') || name.includes('sheet')) {
      return 'hover:before:from-emerald-500/20 hover:before:to-teal-500/20 hover:before:opacity-100';
    } else if (name.includes('mind') || name.includes('map')) {
      return 'hover:before:from-orange-500/20 hover:before:to-red-500/20 hover:before:opacity-100';
    } else if (name.includes('flash') || name.includes('card')) {
      return 'hover:before:from-blue-500/20 hover:before:to-cyan-500/20 hover:before:opacity-100';
    }
    return 'hover:before:from-violet-500/20 hover:before:to-purple-500/20 hover:before:opacity-100';
  };
  
  const getBackgroundGradient = () => {
    const name = props.name.toLowerCase();
    if (name.includes('quiz')) {
      return 'bg-gradient-to-br from-purple-200 via-indigo-200 to-violet-200';
    } else if (name.includes('study') || name.includes('sheet')) {
      return 'bg-gradient-to-br from-emerald-200 via-teal-200 to-green-200';
    } else if (name.includes('mind') || name.includes('map')) {
      return 'bg-gradient-to-br from-orange-200 via-red-200 to-pink-200';
    } else if (name.includes('flash') || name.includes('card')) {
      return 'bg-gradient-to-br from-blue-200 via-cyan-200 to-sky-200';
    }
    return 'bg-gradient-to-br from-violet-200 via-purple-200 to-indigo-200';
  };
  
  const getAccentColor = () => {
    const name = props.name.toLowerCase();
    if (name.includes('quiz')) {
      return 'bg-purple-400';
    } else if (name.includes('study') || name.includes('sheet')) {
      return 'bg-emerald-400';
    } else if (name.includes('mind') || name.includes('map')) {
      return 'bg-orange-400';
    } else if (name.includes('flash') || name.includes('card')) {
      return 'bg-blue-400';
    }
    return 'bg-violet-400';
  };
  
  const getTextColor = () => {
    const name = props.name.toLowerCase();
    if (name.includes('quiz')) {
      return 'text-purple-700';
    } else if (name.includes('study') || name.includes('sheet')) {
      return 'text-emerald-700';
    } else if (name.includes('mind') || name.includes('map')) {
      return 'text-orange-700';
    } else if (name.includes('flash') || name.includes('card')) {
      return 'text-blue-700';
    }
    return 'text-violet-700';
  };
  
  const getIconColor = () => {
    const name = props.name.toLowerCase();
    if (name.includes('quiz')) {
      return 'text-purple-600';
    } else if (name.includes('study') || name.includes('sheet')) {
      return 'text-emerald-600';
    } else if (name.includes('mind') || name.includes('map')) {
      return 'text-orange-600';
    } else if (name.includes('flash') || name.includes('card')) {
      return 'text-blue-600';
    }
    return 'text-violet-600';
  };
  
  const getCtaStyles = () => {
    const name = props.name.toLowerCase();
    if (name.includes('quiz')) {
      return 'bg-purple-600 text-white hover:bg-purple-700';
    } else if (name.includes('study') || name.includes('sheet')) {
      return 'bg-emerald-600 text-white hover:bg-emerald-700';
    } else if (name.includes('mind') || name.includes('map')) {
      return 'bg-orange-600 text-white hover:bg-orange-700';
    } else if (name.includes('flash') || name.includes('card')) {
      return 'bg-blue-600 text-white hover:bg-blue-700';
    }
    return 'bg-violet-600 text-white hover:bg-violet-700';
  };
</script>
