import { createApp } from 'vue'
import Navbar from '@/components/layout/Navbar.vue'

const el = document.querySelector('#navbar')
if (el) {
  createApp(Navbar).mount(el)
}