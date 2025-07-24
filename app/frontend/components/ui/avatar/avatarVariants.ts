// avatarVariants.ts
import { cva, type VariantProps } from 'class-variance-authority'

export const avatarWrapper = cva(
  'relative inline-block',
  {
    variants: {
      clickable: {
        true: 'cursor-pointer hover:scale-105 transition-transform duration-200',
        false: ''
      },
    },
    defaultVariants: { clickable: false },
  }
)

export const AVATAR_SIZE = {
  sm: 'h-8 w-8',        
  md: 'h-9 w-9',      
  lg: 'h-10 w-10',         
  xl: 'h-16 w-16',         
} as const

export const AVATAR_RADIUS = {
  sm: 'rounded-token-sm',
  md: 'rounded-token-md',
  lg: 'rounded-token-lg',
  xl: 'rounded-token-xl',
  full: 'rounded-full'
} as const

export const avatarRoot = cva(
  'overflow-hidden ring-2 ring-ring/20',
  {
    variants: {
      size: AVATAR_SIZE,
      radius: AVATAR_RADIUS,
    },
    defaultVariants: {
      size: 'sm',
      radius: 'xl',
    },
  }
)

export const notifyDot = cva(
  'absolute -top-0.5 -right-0.5 rounded-full border-2 border-background dark:border-background bg-destructive',
  {
    variants: {
      size: {
        sm: 'w-2 h-2',
        md: 'w-2.5 h-2.5',
        lg: 'w-3 h-3',
        xl: 'w-3.5 h-3.5',
      },
    },
    defaultVariants: {
      size: 'lg',
    },
  }
)
export type AvatarWrapperProps = VariantProps<typeof avatarWrapper>;
export type AvatarRootProps = VariantProps<typeof avatarRoot>;
export type NotifyDotProps = VariantProps<typeof notifyDot>;