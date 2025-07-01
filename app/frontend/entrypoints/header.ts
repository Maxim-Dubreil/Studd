import { createApp } from 'vue'
import Header from '@/components/layout/Header.vue'

const el = document.querySelector('#header')
if (el) {
  createApp(Header).mount(el)
}