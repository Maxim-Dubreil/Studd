// TODO: deprecated – à supprimer quand tous les composants sont migrés.
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
  const sizeClasses: Record<SizeVariant, string> = {
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base",
    xl: "px-8 py-4 text-lg",
  };

  // mapping tokens -> classes
  const solidMap: Record<ColorVariant, string> = {
    primary: "bg-primary text-primary-foreground hover:bg-primary/90",
    secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/90",
    success: "bg-success text-success-foreground hover:bg-success/90",
    warning: "bg-warning text-warning-foreground hover:bg-warning/90",
    danger: "bg-danger text-danger-foreground hover:bg-danger/90",
    info: "bg-info text-info-foreground hover:bg-info/90",
  };

  const outlinedMap: Record<ColorVariant, string> = {
    primary: "border-2 border-primary text-primary hover:bg-primary/10",
    secondary: "border-2 border-secondary text-secondary hover:bg-secondary/10",
    success: "border-2 border-success text-success hover:bg-success/10",
    warning: "border-2 border-warning text-warning hover:bg-warning/10",
    danger: "border-2 border-danger text-danger hover:bg-danger/10",
    info: "border-2 border-info text-info hover:bg-info/10",
  };

  //Button classes
  const getButtonClasses = computed(
    () =>
      (
        variant: ColorVariant = "primary",
        size: SizeVariant = "md",
        outlined = false
      ) => {
        const base =
          "inline-flex items-center justify-center font-medium rounded-token transition-all duration-300 hover:shadow-elevate ...";

        const color = outlined ? outlinedMap[variant] : solidMap[variant];

        return `${base} ${sizeClasses[size]} ${color}`;
      }
  );



  //Card classes
  type CardVariant = "glass" | "solid" | "outlined";
  const paddingMap: Record<SizeVariant, string> = {
    sm: "p-4",
    md: "p-6",
    lg: "p-8",
    xl: "p-10",
  };
  const roundedMap: Record<SizeVariant, string> = {
    sm: "rounded-token-sm",
    md: "rounded-token-md",
    lg: "rounded-token-lg",
    xl: "rounded-token-xl",
  };
  const cardVariantMap: Record<CardVariant, string> = {
    glass:
      "backdrop-blur-lg bg-white/10 dark:bg-black/20 border border-white/20 dark:border-white/10",
    solid:
      "bg-card text-card-foreground border border-border shadow-lg",
    outlined:
      "bg-transparent border-2 border-border hover:border-border/80",
  };

  const getCardClasses = computed(
    () =>
      (
        variant: CardVariant = "glass",
        padding: SizeVariant = "md",
        rounded: SizeVariant = "lg"
      ) => {
        const base = "transition-all duration-300 hover:shadow-xl";
        return `${base} ${paddingMap[padding]} ${roundedMap[rounded]} ${cardVariantMap[variant]}`;
      }
  );

  //Icon 
  const iconSizeMap: Record<SizeVariant, string> = {
    sm: "w-4 h-4",
    md: "w-5 h-5",
    lg: "w-6 h-6",
    xl: "w-8 h-8",
  };

  const getIconClasses = computed(
    () =>
      (size: SizeVariant = "md", colorClass = "text-muted-foreground") =>
        `${iconSizeMap[size]} ${colorClass}`
  );

  //Icon Container
  const containerSizeMap: Record<SizeVariant, string> = {
    sm: "w-8 h-8",
    md: "w-10 h-10",
    lg: "w-12 h-12",
    xl: "w-16 h-16",
  };

  const getIconContainerClasses = computed(
    () =>
      (
        size: SizeVariant = "md",
        // par défaut un gradient basé sur primary/success
        bg = "bg-gradient-to-br from-primary to-success/70"
      ) =>
        `${containerSizeMap[size]} rounded-[16px] flex items-center justify-center ${bg}`
  );

  return {
    getButtonClasses,
    getCardClasses,
    getIconClasses,
    getIconContainerClasses,
  };
};