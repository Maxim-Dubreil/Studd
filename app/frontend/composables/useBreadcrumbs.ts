import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

export type Crumb = { label: string; href?: string }
type LabelMap = Record<string, string | ((segment: string) => string)>

function humanize(segment: string) {
  if (/^\d+$/.test(segment)) return `#${segment}`
  return segment.replace(/[-_]+/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase())
}

export function useBreadcrumbs(labels: LabelMap = {}) {
  const loc = ref<string>('')

  const update = () => {
    if (typeof window === 'undefined') return
    const { pathname, search } = window.location
    loc.value = `${pathname.replace(/\/+$/, '')}${search || ''}`
  }

  onMounted(() => {
    update()
    window.addEventListener('popstate', update)
    window.addEventListener('hashchange', update)
    // Turbo (Rails)
    window.addEventListener('turbo:load', update as EventListener)
    window.addEventListener('turbo:render', update as EventListener)
  })

  onBeforeUnmount(() => {
    window.removeEventListener('popstate', update)
    window.removeEventListener('hashchange', update)
    window.removeEventListener('turbo:load', update as EventListener)
    window.removeEventListener('turbo:render', update as EventListener)
  })

  const items = computed<Crumb[]>(() => {
    const [path, query = ''] = loc.value.split('?')
    const segments = path.split('/').filter(Boolean)

    // Crumb racine (utile si tu veux l’utiliser plus tard)
    const acc: Crumb[] = [{ label: (labels[''] as string) ?? 'Dashboard', href: '/' }]

    let current = ''
    segments.forEach((seg, i) => {
      current += `/${seg}`
      const isLast = i === segments.length - 1
      const raw = labels[seg]
      const label =
        typeof raw === 'function' ? raw(seg) :
        typeof raw === 'string'   ? raw     :
        humanize(seg)

      acc.push({ label, href: isLast ? undefined : current })
    })

    // Paramètre id en suffixe (#123)
    const params = new URLSearchParams(query)
    const id = params.get('id')
    if (id) acc.push({ label: `#${id}` })

    // Le dernier crumb ne doit pas avoir de href
    if (acc.length) acc[acc.length - 1].href = undefined
    return acc
  })

  return { items }
}