import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from '@/pages/index.vue'
import Roadmap from '@/pages/roadmap/index.vue'
import RoadmapProject from '@/pages/roadmap/project/index.vue'
import User from '@/pages/user/index.vue'
import Tos from '@/pages/tos/index.vue'
import Project from '@/pages/project/index.vue'
import NewProject from '@/pages/new-project/index.vue'
import Task from '@/pages/user/task/index.vue'
import UserTasks from '@/pages/user/tasks/index.vue'
import ProjectTasks from '@/pages/project/tasks/index.vue'
import SignIn from '@/pages/auth/sign-in/index.vue'
import SignUp from '@/pages/auth/sign-up/index.vue'
import Settings from '@/pages/settings/index.vue'
import SettingsNotifications from '@/pages/settings/notifications/index.vue'
import SettingsProfile from '@/pages/settings/profile/index.vue'
import SettingsAccount from '@/pages/settings/account/index.vue'

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
      name: 'SettingsProfile'
    },
    children: [
      {
        name: 'SettingsNotifications',
        path: 'notifications',
        component: SettingsNotifications
      },
      {
        name: 'SettingsProfile',
        path: 'profile',
        component: SettingsProfile
      },
      {
        name: 'SettingsAccount',
        path: 'account',
        component: SettingsAccount
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
    name: 'Roadmap',
    path: '/roadmap',
    component: Roadmap,
    redirect: {
      name: 'RoadmapProject',
      params: {
        slug: 'weekly_summary'
      }
    },
    children: [
      {
        name: 'RoadmapProject',
        path: ':slug',
        component: RoadmapProject
      }
    ]
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
  {
    name: 'Project',
    path: '/p/:slug',
    component: Project,
    redirect: {
      name: 'ProjectTasks'
    },
    children: [
      {
        name: 'ProjectTasks',
        path: '',
        component: ProjectTasks
      }
    ]
  },
  {
    name: 'NewProject',
    path: '/new/project',
    component: NewProject
  },
  {
    name: 'Terms',
    path: '/terms',
    component: Tos
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
