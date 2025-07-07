<script setup lang="ts">
import { ref } from "vue";
import Icon from "../Icon.vue";

const todos = ref([
  { id: 1, text: "Finir l'exercice de JavaScript", completed: false, priority: "high" },
  { id: 2, text: "Réviser les concepts de Vue.js", completed: true, priority: "medium" },
  { id: 3, text: "Lire le chapitre 5 du cours", completed: false, priority: "low" },
  { id: 4, text: "Préparer la présentation finale", completed: false, priority: "high" },
  { id: 5, text: "Exercices CSS Grid", completed: false, priority: "medium" },
]);

const notifications = ref([
  { id: 1, type: "course", title: "Nouveau cours disponible", subtitle: "React Hooks avancés", time: "Il y a 2h", icon: "book-open" },
  { id: 2, type: "assignment", title: "Devoir à rendre demain", subtitle: "Projet Vue.js", time: "Il y a 4h", icon: "clock" },
  { id: 3, type: "message", title: "Message du professeur", subtitle: "Changement d'horaire", time: "Il y a 1j", icon: "mail" },
  { id: 4, type: "grade", title: "Nouvelle note disponible", subtitle: "CSS Grid - 17/20", time: "Il y a 2j", icon: "star" },
]);

const quickActions = ref([
  { id: 1, title: "Nouveau cours", icon: "plus", color: "text-blue-500", bg: "bg-blue-100 dark:bg-blue-900/30" },
  { id: 2, title: "Planning", icon: "calendar", color: "text-green-500", bg: "bg-green-100 dark:bg-green-900/30" },
  { id: 3, title: "Messages", icon: "mail", color: "text-purple-500", bg: "bg-purple-100 dark:bg-purple-900/30" },
  { id: 4, title: "Profil", icon: "users", color: "text-orange-500", bg: "bg-orange-100 dark:bg-orange-900/30" },
]);

const getNotificationColor = (type: string) => {
  switch (type) {
    case 'course': return 'text-blue-500 dark:text-blue-400';
    case 'assignment': return 'text-orange-500 dark:text-orange-400';
    case 'message': return 'text-green-500 dark:text-green-400';
    case 'grade': return 'text-yellow-500 dark:text-yellow-400';
    default: return 'text-gray-500 dark:text-gray-400';
  }
};

const getPriorityColor = (priority: string) => {
  switch (priority) {
    case 'high': return 'text-red-500';
    case 'medium': return 'text-orange-500';
    case 'low': return 'text-green-500';
    default: return 'text-gray-500';
  }
};
</script>

<template>
  <div class="w-80 flex flex-col space-y-6 p-6">
    <!-- Actions rapides -->
    <div class="bg-white/80 dark:bg-slate-800/90 backdrop-blur-xl rounded-2xl shadow-lg dark:shadow-xl border border-white/20 dark:border-slate-700/50 p-6 transition-all duration-300 hover:shadow-xl dark:hover:shadow-slate-900/50">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-100">Actions rapides</h3>
        <Icon name="zap" class="w-5 h-5 text-violet-500 dark:text-violet-400" />
      </div>
      
      <div class="grid grid-cols-2 gap-3">
        <button 
          v-for="action in quickActions" 
          :key="action.id"
          :class="['flex flex-col items-center p-3 rounded-xl border border-gray-100 dark:border-slate-700/30 hover:shadow-md transition-all duration-300 group', action.bg]"
        >
          <Icon :name="action.icon" :class="['w-6 h-6 mb-2 group-hover:scale-110 transition-transform duration-300', action.color]" />
          <span class="text-xs font-medium text-gray-700 dark:text-gray-300">{{ action.title }}</span>
        </button>
      </div>
    </div>

    <!-- Todo List améliorée -->
    <div class="bg-white/80 dark:bg-slate-800/90 backdrop-blur-xl rounded-2xl shadow-lg dark:shadow-xl border border-white/20 dark:border-slate-700/50 p-6 transition-all duration-300 hover:shadow-xl dark:hover:shadow-slate-900/50">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-100">À faire</h3>
        <div class="flex items-center space-x-2">
          <span class="text-xs text-gray-500 dark:text-gray-400">{{ todos.filter(t => !t.completed).length }}/{{ todos.length }}</span>
          <Icon name="plus" class="w-5 h-5 text-gray-400 dark:text-gray-500 hover:text-violet-500 dark:hover:text-violet-400 cursor-pointer transition-colors duration-300" />
        </div>
      </div>
      
      <div class="space-y-3 max-h-48 overflow-y-auto scrollbar-hide">
        <div 
          v-for="todo in todos" 
          :key="todo.id" 
          class="flex items-center space-x-3 group p-2 rounded-lg hover:bg-gray-50 dark:hover:bg-slate-700/30 transition-all duration-300"
        >
          <div 
            :class="[
              'w-4 h-4 rounded border-2 flex items-center justify-center cursor-pointer transition-all duration-300',
              todo.completed 
                ? 'bg-violet-500 dark:bg-violet-600 border-violet-500 dark:border-violet-600' 
                : 'border-gray-300 dark:border-gray-600 hover:border-violet-400 dark:hover:border-violet-500'
            ]"
          >
            <Icon 
              v-if="todo.completed" 
              name="check" 
              class="w-3 h-3 text-white" 
            />
          </div>
          <div class="flex-1 min-w-0">
            <span 
              :class="[
                'text-sm transition-all duration-300 block',
                todo.completed 
                  ? 'text-gray-400 dark:text-gray-500 line-through' 
                  : 'text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-gray-100'
              ]"
            >
              {{ todo.text }}
            </span>
            <div v-if="!todo.completed" class="flex items-center mt-1">
              <div :class="['w-1.5 h-1.5 rounded-full mr-2', getPriorityColor(todo.priority)]"></div>
              <span :class="['text-xs capitalize', getPriorityColor(todo.priority)]">{{ todo.priority }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Notifications améliorées -->
    <div class="bg-white/80 dark:bg-slate-800/90 backdrop-blur-xl rounded-2xl shadow-lg dark:shadow-xl border border-white/20 dark:border-slate-700/50 p-6 transition-all duration-300 hover:shadow-xl dark:hover:shadow-slate-900/50">
      <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-100">Notifications</h3>
        <div class="flex items-center space-x-2">
          <div class="w-2 h-2 bg-red-400 rounded-full animate-pulse"></div>
          <Icon name="bell" class="w-5 h-5 text-gray-400 dark:text-gray-500" />
        </div>
      </div>
      
      <div class="space-y-4 max-h-64 overflow-y-auto scrollbar-hide">
        <div 
          v-for="notification in notifications" 
          :key="notification.id" 
          class="flex items-start space-x-3 p-3 rounded-lg hover:bg-gray-50 dark:hover:bg-slate-700/50 transition-colors duration-300 cursor-pointer group"
        >
          <div :class="['flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center mt-1', notification.type === 'course' ? 'bg-blue-100 dark:bg-blue-900/30' : notification.type === 'assignment' ? 'bg-orange-100 dark:bg-orange-900/30' : notification.type === 'message' ? 'bg-green-100 dark:bg-green-900/30' : 'bg-yellow-100 dark:bg-yellow-900/30']">
            <Icon 
              :name="notification.icon" 
              :class="['w-4 h-4 transition-colors duration-300', getNotificationColor(notification.type)]" 
            />
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-gray-900 dark:text-gray-100 truncate group-hover:text-gray-700 dark:group-hover:text-gray-200 transition-colors duration-300">
              {{ notification.title }}
            </p>
            <p class="text-xs text-gray-600 dark:text-gray-300 mt-1 truncate">
              {{ notification.subtitle }}
            </p>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">
              {{ notification.time }}
            </p>
          </div>
          <div class="w-2 h-2 bg-violet-400 dark:bg-violet-500 rounded-full opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
        </div>
      </div>
    </div>
  </div>
</template> 