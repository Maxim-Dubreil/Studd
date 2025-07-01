import { reactive, computed } from "vue";

interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  status: "online" | "offline" | "away" | "busy";
}

interface AppState {
  user: User | null;
  loading: boolean;
  sidebarCollapsed: boolean;
  notifications: Notification[];
}

interface Notification {
  id: string;
  title: string;
  message: string;
  type: "success" | "error" | "warning" | "info";
  timestamp: Date;
  read: boolean;
}

export const useAppState = () => {
  const state = reactive<AppState>({
    user: null,
    loading: false,
    sidebarCollapsed: false,
    notifications: [],
  });

  const setUser = (user: User) => {
    state.user = user;
  };

  const clearUser = () => {
    state.user = null;
  };

  const updateUserStatus = (status: User["status"]) => {
    if (state.user) {
      state.user.status = status;
    }
  };

  const setLoading = (loading: boolean) => {
    state.loading = loading;
  };

  const toggleSidebar = () => {
    state.sidebarCollapsed = !state.sidebarCollapsed;
  };

  const setSidebarCollapsed = (collapsed: boolean) => {
    state.sidebarCollapsed = collapsed;
  };

  const addNotification = (
    notification: Omit<Notification, "id" | "timestamp" | "read">
  ) => {
    const newNotification: Notification = {
      ...notification,
      id: Date.now().toString(),
      timestamp: new Date(),
      read: false,
    };
    state.notifications.unshift(newNotification);
  };

  const markNotificationAsRead = (id: string) => {
    const notification = state.notifications.find((n) => n.id === id);
    if (notification) {
      notification.read = true;
    }
  };

  const markAllNotificationsAsRead = () => {
    state.notifications.forEach((n) => (n.read = true));
  };

  const removeNotification = (id: string) => {
    const index = state.notifications.findIndex((n) => n.id === id);
    if (index > -1) {
      state.notifications.splice(index, 1);
    }
  };

  const clearAllNotifications = () => {
    state.notifications = [];
  };

  const isAuthenticated = computed(() => state.user !== null);

  const unreadNotificationsCount = computed(
    () => state.notifications.filter((n) => !n.read).length
  );

  const hasUnreadNotifications = computed(
    () => unreadNotificationsCount.value > 0
  );

  return {
    state,

    setUser,
    clearUser,
    updateUserStatus,
    isAuthenticated,

    setLoading,

    toggleSidebar,
    setSidebarCollapsed,

    addNotification,
    markNotificationAsRead,
    markAllNotificationsAsRead,
    removeNotification,
    clearAllNotifications,
    unreadNotificationsCount,
    hasUnreadNotifications,
  };
};
