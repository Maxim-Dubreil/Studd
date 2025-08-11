<script setup lang="ts">
  import { Icon } from '@/components/ui/icon';
  import { ref } from 'vue';

  const todos = ref([
    { id: 1, text: "Finir l'exercice de JavaScript", completed: false, priority: 'high' },
    { id: 2, text: 'Réviser les concepts de Vue.js', completed: true, priority: 'medium' },
    { id: 3, text: 'Lire le chapitre 5 du cours', completed: false, priority: 'low' },
    { id: 4, text: 'Préparer la présentation finale', completed: false, priority: 'high' },
    { id: 5, text: 'Exercices CSS Grid', completed: false, priority: 'medium' },
  ]);

  const notifications = ref([
    {
      id: 1,
      type: 'course',
      title: 'Nouveau cours disponible',
      subtitle: 'React Hooks avancés',
      time: 'Il y a 2h',
      icon: 'book-open',
    },
    {
      id: 2,
      type: 'assignment',
      title: 'Devoir à rendre demain',
      subtitle: 'Projet Vue.js',
      time: 'Il y a 4h',
      icon: 'clock',
    },
    {
      id: 3,
      type: 'message',
      title: 'Message du professeur',
      subtitle: "Changement d'horaire",
      time: 'Il y a 1j',
      icon: 'mail',
    },
    {
      id: 4,
      type: 'grade',
      title: 'Nouvelle note disponible',
      subtitle: 'CSS Grid - 17/20',
      time: 'Il y a 2j',
      icon: 'star',
    },
  ]);

  const quickActions = ref([
    {
      id: 1,
      title: 'Nouveau cours',
      icon: 'plus',
      color: 'text-blue-500',
      bg: 'bg-blue-100 dark:bg-blue-900/30',
    },
    {
      id: 2,
      title: 'Planning',
      icon: 'calendar',
      color: 'text-green-500',
      bg: 'bg-green-100 dark:bg-green-900/30',
    },
    {
      id: 3,
      title: 'Messages',
      icon: 'mail',
      color: 'text-purple-500',
      bg: 'bg-purple-100 dark:bg-purple-900/30',
    },
    {
      id: 4,
      title: 'Profil',
      icon: 'users',
      color: 'text-orange-500',
      bg: 'bg-orange-100 dark:bg-orange-900/30',
    },
  ]);

  const getNotificationColor = (type: string) => {
    switch (type) {
      case 'course':
        return 'text-blue-500 dark:text-blue-400';
      case 'assignment':
        return 'text-orange-500 dark:text-orange-400';
      case 'message':
        return 'text-green-500 dark:text-green-400';
      case 'grade':
        return 'text-yellow-500 dark:text-yellow-400';
      default:
        return 'text-gray-500 dark:text-gray-400';
    }
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high':
        return 'text-red-500';
      case 'medium':
        return 'text-orange-500';
      case 'low':
        return 'text-green-500';
      default:
        return 'text-gray-500';
    }
  };
</script>

<template>
  <div class="flex w-80 flex-col space-y-6 p-6">
    <!-- Actions rapides -->
    <div
      class="rounded-2xl border border-white/20 bg-white/80 p-6 shadow-lg backdrop-blur-xl transition-all duration-300 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
    >
      <div class="mb-4 flex items-center justify-between">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-100">Actions rapides</h3>
        <Icon name="zap" class="h-5 w-5 text-violet-500 dark:text-violet-400" />
      </div>

      <div class="grid grid-cols-2 gap-3">
        <button
          v-for="action in quickActions"
          :key="action.id"
          :class="[
            'group flex flex-col items-center rounded-xl border border-gray-100 p-3 transition-all duration-300 hover:shadow-md dark:border-slate-700/30',
            action.bg,
          ]"
        >
          <Icon
            :name="action.icon"
            :class="[
              'mb-2 h-6 w-6 transition-transform duration-300 group-hover:scale-110',
              action.color,
            ]"
          />
          <span class="text-xs font-medium text-gray-700 dark:text-gray-300">
            {{ action.title }}
          </span>
        </button>
      </div>
    </div>

    <!-- Todo List améliorée -->
    <div
      class="rounded-2xl border border-white/20 bg-white/80 p-6 shadow-lg backdrop-blur-xl transition-all duration-300 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
    >
      <div class="mb-4 flex items-center justify-between">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-100">À faire</h3>
        <div class="flex items-center space-x-2">
          <span class="text-xs text-gray-500 dark:text-gray-400">
            {{ todos.filter((t) => !t.completed).length }}/{{ todos.length }}
          </span>
          <Icon
            name="plus"
            class="h-5 w-5 cursor-pointer text-gray-400 transition-colors duration-300 hover:text-violet-500 dark:text-gray-500 dark:hover:text-violet-400"
          />
        </div>
      </div>

      <div class="scrollbar-hide max-h-48 space-y-3 overflow-y-auto">
        <div
          v-for="todo in todos"
          :key="todo.id"
          class="group flex items-center space-x-3 rounded-lg p-2 transition-all duration-300 hover:bg-gray-50 dark:hover:bg-slate-700/30"
        >
          <div
            :class="[
              'flex h-4 w-4 cursor-pointer items-center justify-center rounded border-2 transition-all duration-300',
              todo.completed
                ? 'border-violet-500 bg-violet-500 dark:border-violet-600 dark:bg-violet-600'
                : 'border-gray-300 hover:border-violet-400 dark:border-gray-600 dark:hover:border-violet-500',
            ]"
          >
            <Icon v-if="todo.completed" name="check" class="h-3 w-3 text-white" />
          </div>
          <div class="min-w-0 flex-1">
            <span
              :class="[
                'block text-sm transition-all duration-300',
                todo.completed
                  ? 'text-gray-400 line-through dark:text-gray-500'
                  : 'text-gray-700 group-hover:text-gray-900 dark:text-gray-300 dark:group-hover:text-gray-100',
              ]"
            >
              {{ todo.text }}
            </span>
            <div v-if="!todo.completed" class="mt-1 flex items-center">
              <div
                :class="['mr-2 h-1.5 w-1.5 rounded-full', getPriorityColor(todo.priority)]"
              ></div>
              <span :class="['text-xs capitalize', getPriorityColor(todo.priority)]">
                {{ todo.priority }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Notifications améliorées -->
    <div
      class="rounded-2xl border border-white/20 bg-white/80 p-6 shadow-lg backdrop-blur-xl transition-all duration-300 hover:shadow-xl dark:border-slate-700/50 dark:bg-slate-800/90 dark:shadow-xl dark:hover:shadow-slate-900/50"
    >
      <div class="mb-4 flex items-center justify-between">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-100">Notifications</h3>
        <div class="flex items-center space-x-2">
          <div class="h-2 w-2 animate-pulse rounded-full bg-red-400"></div>
          <Icon name="bell" class="h-5 w-5 text-gray-400 dark:text-gray-500" />
        </div>
      </div>

      <div class="scrollbar-hide max-h-64 space-y-4 overflow-y-auto">
        <div
          v-for="notification in notifications"
          :key="notification.id"
          class="group flex cursor-pointer items-start space-x-3 rounded-lg p-3 transition-colors duration-300 hover:bg-gray-50 dark:hover:bg-slate-700/50"
        >
          <div
            :class="[
              'mt-1 flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full',
              notification.type === 'course'
                ? 'bg-blue-100 dark:bg-blue-900/30'
                : notification.type === 'assignment'
                  ? 'bg-orange-100 dark:bg-orange-900/30'
                  : notification.type === 'message'
                    ? 'bg-green-100 dark:bg-green-900/30'
                    : 'bg-yellow-100 dark:bg-yellow-900/30',
            ]"
          >
            <Icon
              :name="notification.icon"
              :class="[
                'h-4 w-4 transition-colors duration-300',
                getNotificationColor(notification.type),
              ]"
            />
          </div>
          <div class="min-w-0 flex-1">
            <p
              class="truncate text-sm font-medium text-gray-900 transition-colors duration-300 group-hover:text-gray-700 dark:text-gray-100 dark:group-hover:text-gray-200"
            >
              {{ notification.title }}
            </p>
            <p class="mt-1 truncate text-xs text-gray-600 dark:text-gray-300">
              {{ notification.subtitle }}
            </p>
            <p class="mt-1 text-xs text-gray-500 dark:text-gray-400">
              {{ notification.time }}
            </p>
          </div>
          <div
            class="h-2 w-2 rounded-full bg-violet-400 opacity-0 transition-opacity duration-300 group-hover:opacity-100 dark:bg-violet-500"
          ></div>
        </div>
      </div>
    </div>
  </div>
</template>
