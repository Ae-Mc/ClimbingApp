import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import { auth } from '@/store/modules/auth'
import MainApp from '@/views/home/App.vue'
import Login from '@/views/Login.vue'
import Register from "@/views/Register.vue";

Vue.use(VueRouter)

const routes: Array<RouteConfig> = [
  {
    path: '/',
    name: '',
    component: MainApp,
    children: [
      {
        path: '',
        redirect: {
          path: '/tracks'
        }
      },
      {
        path: 'tracks',
        name: 'Tracks',
        // route level code-splitting
        // this generates a separate chunk (about.[hash].js) for this route
        // which is lazy-loaded when the route is visited.
        component: () => import(/* webpackChunkName: "about" */ '@/views/home/Tracks.vue')
      },
      {
        path: 'tracks/new',
        name: 'AddTrack',
        component: () => import('@/views/home/AddTrack.vue'),
        meta: {
          requiresAuth: true
        }
      },
      {
        path: 'about',
        name: 'About',
        component: () => import('@/views/home/About.vue')
      },
      {
        path: 'categories',
        name: 'Categories',
        component: () => import('@/views/home/Categories.vue')
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach(async (to, from, next) => {
  if (to.meta?.requiresAuth === true && !auth.state.status.loggedIn) {
    return next('/login')
  }
  next()
})

export default router
