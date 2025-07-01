import { computed } from "vue";

export type SizeVariant = "sm" | "md" | "lg" | "xl";
export type ColorVariant =
  | "primary"
  | "secondary"
  | "success"
  | "warning"
  | "danger"
  | "info";

export const useStyleUtils = () => {
  const getButtonClasses = computed(
    () =>
      (
        variant: ColorVariant = "primary",
        size: SizeVariant = "md",
        outlined: boolean = false
      ) => {
        const baseClasses =
          "inline-flex items-center justify-center font-medium rounded-[16px] transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-offset-2";

        const sizeClasses = {
          sm: "px-3 py-1.5 text-sm",
          md: "px-4 py-2 text-sm",
          lg: "px-6 py-3 text-base",
          xl: "px-8 py-4 text-lg",
        };

        const colorClasses = {
          primary: outlined
            ? "border-2 border-violet-500 text-violet-500 hover:bg-violet-50"
            : "bg-gradient-to-r from-violet-500 to-purple-500 text-white hover:from-violet-600 hover:to-purple-600 shadow-lg",
          secondary: outlined
            ? "border-2 border-gray-500 text-gray-500 hover:bg-gray-50"
            : "bg-gray-500 text-white hover:bg-gray-600",
          success: outlined
            ? "border-2 border-green-500 text-green-500 hover:bg-green-50"
            : "bg-green-500 text-white hover:bg-green-600",
          warning: outlined
            ? "border-2 border-yellow-500 text-yellow-500 hover:bg-yellow-50"
            : "bg-yellow-500 text-white hover:bg-yellow-600",
          danger: outlined
            ? "border-2 border-red-500 text-red-500 hover:bg-red-50"
            : "bg-gradient-to-r from-red-400 to-pink-500 text-white hover:from-red-500 hover:to-pink-600 shadow-lg",
          info: outlined
            ? "border-2 border-blue-500 text-blue-500 hover:bg-blue-50"
            : "bg-blue-500 text-white hover:bg-blue-600",
        };

        return `${baseClasses} ${sizeClasses[size]} ${colorClasses[variant]}`;
      }
  );

  const getCardClasses = computed(
    () =>
      (
        variant: "glass" | "solid" | "outlined" = "glass",
        padding: SizeVariant = "md",
        rounded: SizeVariant = "lg"
      ) => {
        const baseClasses = "transition-all duration-300 hover:shadow-xl";

        const paddingClasses = {
          sm: "p-4",
          md: "p-6",
          lg: "p-8",
          xl: "p-10",
        };

        const roundedClasses = {
          sm: "rounded-[16px]",
          md: "rounded-[20px]",
          lg: "rounded-[24px]",
          xl: "rounded-[28px]",
        };

        const variantClasses = {
          glass:
            "bg-white/70 backdrop-blur-lg shadow-lg border border-white/20",
          solid: "bg-white shadow-lg border border-gray-200",
          outlined:
            "bg-transparent border-2 border-gray-200 hover:border-gray-300",
        };

        return `${baseClasses} ${paddingClasses[padding]} ${roundedClasses[rounded]} ${variantClasses[variant]}`;
      }
  );

  const getIconClasses = computed(
    () =>
      (size: SizeVariant = "md", color: string = "text-gray-500") => {
        const sizeClasses = {
          sm: "w-4 h-4",
          md: "w-5 h-5",
          lg: "w-6 h-6",
          xl: "w-8 h-8",
        };

        return `${sizeClasses[size]} ${color}`;
      }
  );

  const getIconContainerClasses = computed(
    () =>
      (
        size: SizeVariant = "md",
        bgColor: string = "bg-gradient-to-br from-violet-400 to-purple-500"
      ) => {
        const sizeClasses = {
          sm: "w-8 h-8",
          md: "w-10 h-10",
          lg: "w-12 h-12",
          xl: "w-16 h-16",
        };

        return `${sizeClasses[size]} rounded-[16px] flex items-center justify-center ${bgColor}`;
      }
  );

  return {
    getButtonClasses,
    getCardClasses,
    getIconClasses,
    getIconContainerClasses,
  };
};
