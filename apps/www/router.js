import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from '@/pages/index.vue'
import User from '@/pages/user/index.vue'
import Task from '@/pages/user/task/index.vue'
import UserTasks from '@/pages/user/tasks/index.vue'
import SignIn from '@/pages/auth/sign-in/index.vue'
import SignUp from '@/pages/auth/sign-up/index.vue'
import Settings from '@/pages/settings/index.vue'
import SettingsNotifications from '@/pages/settings/notifications/index.vue'

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

const SETTINGS_ROUTES = [
  {
    name: 'Settings',
    path: '/settings',
    component: Settings,
    redirect: {
      name: 'SettingsNotifications'
    },
    children: [
      {
        name: 'SettingsNotifications',
        path: 'notifications',
        component: SettingsNotifications
      }
    ]
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
    component: User,
    redirect: {
      name: 'UserTasks'
    },
    children: [
      {
        name: 'UserTasks',
        path: '',
        component: UserTasks
      },
      {
        name: 'Task',
        path: 'task/:task',
        component: Task
      }
    ]
  },
]

function buildRoutes () {
  const defaultRoutes = [
    ...AUTH_ROUTES,
    ...WEBSITE_ROUTES,
    ...SETTINGS_ROUTES,
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
