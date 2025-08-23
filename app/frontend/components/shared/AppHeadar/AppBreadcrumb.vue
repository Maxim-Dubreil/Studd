<!-- src/components/shared/AppHeadar/AppBreadcrumb.vue -->
<script setup lang="ts">
import { computed } from 'vue'
import {
    Breadcrumb,
    BreadcrumbItem,
    BreadcrumbList,
    BreadcrumbPage,
} from '@/components/ui/breadcrumb'
import { useBreadcrumbs, type Crumb } from '@/composables/useBreadcrumbs'

const props = withDefaults(defineProps<{
    labels?: Record<string, string | ((segment: string) => string)>
    items?: Crumb[] 
}>(), {
    labels: () => ({}),
    items: undefined,
})

const auto = useBreadcrumbs(props.labels)
const raw = computed<Crumb[]>(() => (props.items?.length ? props.items : auto.items.value))
const current = computed<Crumb>(() => raw.value[raw.value.length - 1] ?? { label: '' })
</script>

<template>
    <Breadcrumb>
        <BreadcrumbList>
            <BreadcrumbItem>
                <BreadcrumbPage>{{ current.label }}</BreadcrumbPage>
            </BreadcrumbItem>
        </BreadcrumbList>
    </Breadcrumb>
</template>
