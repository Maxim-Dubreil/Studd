<script setup lang="ts">
  import { Icon } from '@/components/ui/icon';
  import { ref } from 'vue';

  // Données simulées - sera remplacé par des appels API
  const stats = ref({
    todoCount: 5,
    progressPercent: 75,
    completedCourses: 12,
    totalStudyTime: '127h',
    currentStreak: 14,
    averageGrade: 16.5,
  });

  const schedule = ref([
    {
      id: 1,
      time: '09:00',
      title: 'Développement Web Avancé',
      professor: 'Dr. Martin',
      room: 'Salle A205',
      type: 'course',
      duration: '2h',
    },
    {
      id: 2,
      time: '11:30',
      title: 'Pause',
      type: 'break',
      duration: '30min',
    },
    {
      id: 3,
      time: '12:00',
      title: 'TP JavaScript',
      professor: 'Mme. Dubois',
      room: 'Lab B12',
      type: 'practical',
      duration: '2h',
    },
    {
      id: 4,
      time: '14:00',
      title: 'Déjeuner',
      type: 'break',
      duration: '1h',
    },
    {
      id: 5,
      time: '15:00',
      title: 'Conférence React',
      professor: 'M. Rodriguez',
      room: 'Amphi C',
      type: 'conference',
      duration: '1h30',
    },
    {
      id: 6,
      time: '16:30',
      title: 'Étude personnelle',
      type: 'study',
      duration: '2h',
    },
    {
      id: 7,
      time: '18:30',
      title: 'Révisions',
      type: 'study',
      duration: '1h',
    },
    {
      id: 8,
      time: '19:30',
      title: 'Projet personnel',
      type: 'practical',
      duration: '2h',
    },
  ]);

  const getScheduleTypeColor = (type: string) => {
    switch (type) {
      case 'course':
        return 'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300';
      case 'practical':
        return 'bg-purple-100 dark:bg-purple-900/30 text-purple-700 dark:text-purple-300';
      case 'conference':
        return 'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-300';
      case 'study':
        return 'bg-orange-100 dark:bg-orange-900/30 text-orange-700 dark:text-orange-300';
      case 'break':
        return 'bg-gray-100 dark:bg-gray-800/50 text-gray-600 dark:text-gray-400';
      default:
        return 'bg-gray-100 dark:bg-gray-900/30 text-gray-600 dark:text-gray-400';
    }
  };

  const getScheduleIcon = (type: string) => {
    switch (type) {
      case 'course':
        return 'book-open';
      case 'practical':
        return 'code';
      case 'conference':
        return 'users';
      case 'study':
        return 'lightbulb';
      case 'break':
        return 'coffee';
      default:
        return 'clock';
    }
  };
</script>

<template>
  <div class="flex-1 p-8">
    <!-- Titre principal -->
    <div class="mb-8">
      <h1
        class="text-3xl font-semibold text-gray-700 transition-colors duration-300 dark:text-gray-200"
      >
        Dashboard
      </h1>
      <p class="mt-2 text-gray-500 dark:text-gray-400">
        Bienvenue dans votre espace d'apprentissage
      </p>
    </div>

    <!-- Contenu en grille -->
    <div class="mb-8 grid grid-cols-12 gap-6">
      <!-- Carte principale de bienvenue - Plus grande -->
      <div
        class="col-span-12 flex h-40 items-center justify-between rounded-3xl bg-gradient-to-r from-violet-500 to-blue-600 p-8 text-white shadow-lg transition-all duration-300 hover:scale-[1.02] hover:shadow-xl dark:from-violet-600 dark:to-blue-700 dark:shadow-2xl dark:hover:shadow-violet-500/25"
      >
        <div class="flex-1">
          <h2 class="mb-3 text-2xl font-bold">Continuez votre apprentissage !</h2>
          <p class="text-lg text-violet-100 dark:text-violet-200">
            Vous êtes à {{ stats.progressPercent }}% de vos objectifs cette semaine
          </p>
          <div class="mt-4">
            <div class="flex items-center space-x-4 text-sm">
              <span class="rounded-full bg-white/20 px-3 py-1">
                {{ stats.currentStreak }} jours consécutifs
              </span>
              <span class="rounded-full bg-white/20 px-3 py-1">
                {{ stats.totalStudyTime }} d'étude
              </span>
            </div>
          </div>
        </div>
        <div class="flex items-center space-x-6">
          <div class="text-center">
            <div class="text-3xl font-bold">{{ stats.averageGrade }}/20</div>
            <div class="text-sm text-violet-200">Moyenne</div>
          </div>
          <Icon name="graduation-cap" class="h-16 w-16 text-white opacity-80" />
        </div>
      </div>

      <!-- Statistiques rapides - 4 cartes moyennes -->
      <div
        class="col-span-3 h-36 rounded-2xl border border-white/20 bg-white/80 p-6 shadow-lg backdrop-blur-xl transition-all duration-300 hover:scale-105 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
      >
        <div class="mb-4 flex items-center">
          <Icon name="trending-up" class="mr-3 h-6 w-6 text-green-500 dark:text-green-400" />
          <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Progression</span>
        </div>
        <div class="mb-2 text-3xl font-bold text-gray-800 dark:text-gray-100">
          {{ stats.progressPercent }}%
        </div>
        <div class="h-3 w-full rounded-full bg-gray-200 dark:bg-slate-700">
          <div
            class="h-3 rounded-full bg-gradient-to-r from-green-400 to-green-600 transition-all duration-500 dark:from-green-500 dark:to-green-700"
            :style="`width: ${stats.progressPercent}%`"
          ></div>
        </div>
      </div>

      <div
        class="col-span-3 h-36 rounded-2xl border border-white/20 bg-white/80 p-6 shadow-lg backdrop-blur-xl transition-all duration-300 hover:scale-105 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
      >
        <div class="mb-4 flex items-center">
          <Icon name="book-open" class="mr-3 h-6 w-6 text-blue-500 dark:text-blue-400" />
          <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Cours complétés</span>
        </div>
        <div class="text-3xl font-bold text-gray-800 dark:text-gray-100">
          {{ stats.completedCourses }}
        </div>
        <div class="text-sm text-gray-500 dark:text-gray-400">sur 20 cours</div>
      </div>

      <div
        class="col-span-3 h-36 rounded-2xl border border-white/20 bg-white/80 p-6 shadow-lg backdrop-blur-xl transition-all duration-300 hover:scale-105 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
      >
        <div class="mb-4 flex items-center">
          <Icon name="clock" class="mr-3 h-6 w-6 text-purple-500 dark:text-purple-400" />
          <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Temps d'étude</span>
        </div>
        <div class="text-3xl font-bold text-gray-800 dark:text-gray-100">
          {{ stats.totalStudyTime }}
        </div>
        <div class="text-sm text-gray-500 dark:text-gray-400">cette semaine</div>
      </div>

      <div
        class="col-span-3 h-36 rounded-2xl border border-white/20 bg-white/80 p-6 shadow-lg backdrop-blur-xl transition-all duration-300 hover:scale-105 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
      >
        <div class="mb-4 flex items-center">
          <Icon name="target" class="mr-3 h-6 w-6 text-orange-500 dark:text-orange-400" />
          <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Série actuelle</span>
        </div>
        <div class="text-3xl font-bold text-gray-800 dark:text-gray-100">
          {{ stats.currentStreak }}
        </div>
        <div class="text-sm text-gray-500 dark:text-gray-400">jours consécutifs</div>
      </div>

      <!-- Emploi du temps - Carte remontée qui prend toute la largeur -->
      <div
        class="col-span-12 rounded-2xl border border-white/20 bg-white/80 p-8 shadow-lg backdrop-blur-xl transition-all duration-300 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
      >
        <div class="mb-8 flex items-center justify-between">
          <div>
            <h3 class="text-2xl font-semibold text-gray-800 dark:text-gray-100">
              Emploi du temps - Aujourd'hui
            </h3>
            <p class="mt-1 text-gray-500 dark:text-gray-400">
              Votre planning détaillé de la journée
            </p>
          </div>
          <div class="flex items-center space-x-3">
            <span class="text-lg text-gray-500 dark:text-gray-400">Lundi 30 Juin</span>
            <Icon name="calendar" class="h-7 w-7 text-gray-400 dark:text-gray-500" />
          </div>
        </div>

        <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-4">
          <div
            v-for="item in schedule"
            :key="item.id"
            :class="[
              'group cursor-pointer rounded-xl border-2 p-5 transition-all duration-300 hover:-translate-y-1 hover:shadow-lg',
              getScheduleTypeColor(item.type),
            ]"
          >
            <div class="mb-4 flex items-start justify-between">
              <div class="flex items-center space-x-3">
                <div
                  :class="[
                    'rounded-lg bg-white/20 p-2 dark:bg-black/20',
                    item.type === 'break' ? 'bg-gray-200 dark:bg-gray-700' : '',
                  ]"
                >
                  <Icon :name="getScheduleIcon(item.type)" class="h-5 w-5" />
                </div>
                <div>
                  <div class="text-base font-bold">{{ item.time }}</div>
                  <div class="text-sm font-medium opacity-75">{{ item.duration }}</div>
                </div>
              </div>
              <div
                v-if="item.type !== 'break'"
                class="h-3 w-3 rounded-full bg-current transition-transform duration-300 group-hover:scale-125"
              ></div>
            </div>

            <div class="space-y-2">
              <h4 class="text-base leading-tight font-semibold">{{ item.title }}</h4>
              <div v-if="item.professor" class="flex items-center text-sm opacity-80">
                <Icon name="users" class="mr-2 h-4 w-4" />
                <span>{{ item.professor }}</span>
              </div>
              <div v-if="item.room" class="flex items-center text-sm opacity-80">
                <Icon name="map-pin" class="mr-2 h-4 w-4" />
                <span>{{ item.room }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
