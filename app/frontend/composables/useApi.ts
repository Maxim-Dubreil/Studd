import { ref, computed } from "vue";

export interface ApiResponse<T = any> {
  data?: T;
  error?: string;
  loading: boolean;
  success: boolean;
}

export const useApi = () => {
  const baseURL = ref("/api");
  const defaultHeaders = ref<Record<string, string>>({
    "Content-Type": "application/json",
    Accept: "application/json",
  });

  const setBaseURL = (url: string) => {
    baseURL.value = url;
  };

  const setDefaultHeaders = (headers: Record<string, string>) => {
    defaultHeaders.value = { ...defaultHeaders.value, ...headers };
  };

  const setAuthToken = (token: string) => {
    setDefaultHeaders({ Authorization: `Bearer ${token}` });
  };

  const clearAuthToken = () => {
    const { Authorization, ...rest } = defaultHeaders.value;
    defaultHeaders.value = rest;
  };

  const makeRequest = async <T = any>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<ApiResponse<T>> => {
    const result: ApiResponse<T> = {
      loading: true,
      success: false,
    };

    try {
      const url = `${baseURL.value}${endpoint}`;
      const config: RequestInit = {
        headers: { ...defaultHeaders.value, ...options.headers },
        ...options,
      };

      const response = await fetch(url, config);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();

      return {
        data,
        loading: false,
        success: true,
      };
    } catch (error) {
      return {
        error: error instanceof Error ? error.message : "An error occurred",
        loading: false,
        success: false,
      };
    }
  };

  const get = async <T = any>(
    endpoint: string,
    params?: Record<string, any>
  ) => {
    const url = params
      ? `${endpoint}?${new URLSearchParams(params).toString()}`
      : endpoint;

    return makeRequest<T>(url, { method: "GET" });
  };

  const post = async <T = any>(endpoint: string, data?: any) => {
    return makeRequest<T>(endpoint, {
      method: "POST",
      body: data ? JSON.stringify(data) : undefined,
    });
  };

  const put = async <T = any>(endpoint: string, data?: any) => {
    return makeRequest<T>(endpoint, {
      method: "PUT",
      body: data ? JSON.stringify(data) : undefined,
    });
  };

  const patch = async <T = any>(endpoint: string, data?: any) => {
    return makeRequest<T>(endpoint, {
      method: "PATCH",
      body: data ? JSON.stringify(data) : undefined,
    });
  };

  const del = async <T = any>(endpoint: string) => {
    return makeRequest<T>(endpoint, { method: "DELETE" });
  };

  return {
    setBaseURL,
    setDefaultHeaders,
    setAuthToken,
    clearAuthToken,
    makeRequest,
    get,
    post,
    put,
    patch,
    delete: del,
  };
};

export const useAsyncState = <T = any>(asyncFunction: () => Promise<T>) => {
  const data = ref<T | null>(null);
  const error = ref<string | null>(null);
  const loading = ref(false);

  const execute = async () => {
    try {
      loading.value = true;
      error.value = null;
      data.value = await asyncFunction();
    } catch (err) {
      error.value = err instanceof Error ? err.message : "An error occurred";
    } finally {
      loading.value = false;
    }
  };

  const reset = () => {
    data.value = null;
    error.value = null;
    loading.value = false;
  };

  const isReady = computed(
    () => !loading.value && !error.value && data.value !== null
  );

  return {
    data,
    error,
    loading,
    isReady,
    execute,
    reset,
  };
};
