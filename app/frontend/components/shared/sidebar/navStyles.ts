// app/frontend/components/shared/sidebar/navStyles.ts
export const NAV_BTN =
  'w-full h-10 px-2 flex items-center gap-2 rounded-md transition-colors ' +
  'hover:bg-violet-50 dark:hover:bg-violet-950/30 ' +
  'text-gray-700 dark:text-gray-300 ' +
  'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-violet-500/40 ' +
  'data-[active=true]:bg-violet-50 dark:data-[active=true]:bg-violet-950/30 ' +
  'data-[active=true]:text-violet-700 dark:data-[active=true]:text-violet-300 ' +
  'group-data-[state=collapsed]:px-0 group-data-[state=collapsed]:gap-0 ' +
  'group-data-[state=collapsed]:justify-center';

export const NAV_ICON =
  'h-6 w-6 shrink-0 ' +
  'text-violet-600 dark:text-violet-400 ' +
  'group-hover:text-violet-700 dark:group-hover:text-violet-300 ' +
  'group-data-[active=true]:text-violet-700 dark:group-data-[active=true]:text-violet-300 ' +
  'group-data-[state=collapsed]:mx-auto';

export const ICON_BASE   = 'h-6 w-6 shrink-0 group-data-[state=collapsed]:mx-auto'
export const ICON_VIOLET = 'text-violet-600 dark:text-violet-400 group-hover:text-violet-700 dark:group-hover:text-violet-300 group-data-[active=true]:text-violet-700 dark:group-data-[active=true]:text-violet-300'
export const ICON_DANGER = 'text-red-600 dark:text-red-400 group-hover:text-red-700 dark:group-hover:text-red-300 group-data-[active=true]:text-red-700 dark:group-data-[active=true]:text-red-300'

export const NAV_AVATAR =
  'h-6 w-6 rounded-lg shrink-0 group-data-[state=collapsed]:mx-auto';
