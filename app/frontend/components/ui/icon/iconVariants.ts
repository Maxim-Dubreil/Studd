import { cva, type VariantProps } from 'class-variance-authority'

export const iconVariants = cva('', {
    variants: {
        size: {
            sm: 'w-4 h-4',
            md: 'w-5 h-5',
            lg: 'w-6 h-6',
            xl: 'w-8 h-8',
        },
        spin: {
            true: 'animate-spin',
            false: '',
        },
    },
    defaultVariants: {
        size: 'md',
        spin: false,
    },
})

export type IconVariants = VariantProps<typeof iconVariants>