import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from '@/pages/index.vue'
import User from '@/pages/user/index.vue'
import Task from '@/pages/user/task/index.vue'
import SignIn from '@/pages/auth/sign-in/index.vue'
import SignUp from '@/pages/auth/sign-up/index.vue'

Vue.use(VueRouter)

const AUTH_ROUTES = [
  {
    name: 'SignIn',
    path: '/auth/sign-in',
    component: SignIn
  },
  {
    name: 'SignUp',
    path: '/auth/sign-up',
    component: SignUp
  }
]

const WEBSITE_ROUTES = [
  {
    name: 'Home',
    path: '/',
    component: Home
  },
  {
    name: 'User',
    path: '/u/:username',
    component: User
  },
  {
    name: 'Task',
    path: '/u/:username/task/:task',
    component: Task
  }
]

function buildRoutes () {
  const defaultRoutes = [
    ...AUTH_ROUTES,
    ...WEBSITE_ROUTES
  ]

  const localizedRoutes = defaultRoutes.map(route => ({
    ...route,
    // path: `/:locale(${locales.join('|')})${route.path}`,
    meta: {
      localized: true
    }
  }))

  // const redirectRoutes = defaultRoutes.map(route => ({
  //   ...route,
  //   name: `${route.name}-redirect`,
  //   redirect: `/fr${route.path}`
  // }))

  return [
    ...localizedRoutes,
    // ...redirectRoutes
  ]
}

export function createRouter() {
  const router = new VueRouter({
    mode: 'history',
    routes: buildRoutes(),
    scrollBehavior: () => ({ x: 0, y: 0 })
  })

  return router
}
