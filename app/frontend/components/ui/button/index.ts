import '@/styles/animations/animations.css';
import { cva, type VariantProps } from 'class-variance-authority';

export const buttonVariants = cva(
  `inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md
   text-sm font-medium

   transition duration-200 ease-out           /* animé */
   hover:scale-[1.02] hover:shadow-xl         /* zoom  ombre au survol */
   active:scale-[.98]                         /* léger enfoncement au clic */

   disabled:pointer-events-none disabled:opacity-50
   [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4
   shrink-0 [&_svg]:shrink-0
   outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]
 aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive`,
  {
    variants: {
      variant: {
        success:
          'bg-gradient-to-r from-emerald-500 to-teal-500 text-white shadow-md hover:bg-emerald-600',
        default: 'bg-primary text-primary-foreground shadow-md hover:bg-primary/90',
        destructive:
          'bg-gradient-to-r from-red-500 to-red-600 text-white shadow-md hover:bg-red-700 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 dark:bg-destructive/60',
        outline:
          'border bg-background shadow-md hover:bg-accent hover:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50',
        secondary: 'bg-secondary text-secondary-foreground shadow-md hover:bg-secondary/80',
        ghost: 'hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50',
        link: 'text-primary underline-offset-4 hover:underline',
        gradient:
          'text-white bg-gradient-to-r from-indigo-500 to-purple-500 shadow-md hover:opacity-90',
        NextPrevious:
          'bg-accent text-accent-foreground shadow-md hover:bg-gradient-to-r from-indigo-500 to-purple-500  hover:text-accent animate-float',
      },

      size: {
        default: 'h-9 px-4 py-2 has-[>svg]:px-3',
        sm: 'h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5',
        lg: 'h-10 rounded-md px-6 has-[>svg]:px-4',
        icon: 'size-9',
      },
      radius: {
        sm: 'rounded-token-sm',
        md: 'rounded-token-md',
        lg: 'rounded-token-lg',
        xl: 'rounded-token-xl',
        none: 'rounded-none',
      },
    },
    defaultVariants: {
      variant: 'default',
      size: 'default',
      radius: 'xl',
    },
  }
);

export type ButtonVariants = VariantProps<typeof buttonVariants>;
export { default as Button } from './Button.vue';
