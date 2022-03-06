import Vue from 'vue'
import VueRouter from 'vue-router'

import Home from '@/pages/index.vue'
import Roadmap from '@/pages/roadmap/index.vue'
import RoadmapProject from '@/pages/roadmap/project/index.vue'
import User from '@/pages/user/index.vue'
import Tos from '@/pages/tos/index.vue'
import Project from '@/pages/project/index.vue'
import NewProject from '@/pages/new-project/index.vue'
import ProjectSettings from '@/pages/project-settings/index.vue'
import ProjectSettingsInformations from '@/pages/project-settings/informations/index.vue'
import ProjectSettingsImages from '@/pages/project-settings/images/index.vue'
import ProjectSettingsWebhooks from '@/pages/project-settings/webhooks/index.vue'
import ProjectSettingsIntegrations from '@/pages/project-settings/integrations/index.vue'
import Task from '@/pages/user/task/index.vue'
import UserTasks from '@/pages/user/tasks/index.vue'
import ProjectTasks from '@/pages/project/tasks/index.vue'
import ProjectImages from '@/pages/project/images/index.vue'
import SignIn from '@/pages/auth/sign-in/index.vue'
import SignUp from '@/pages/auth/sign-up/index.vue'
import ForgotPassword from '@/pages/auth/forgot-password/index.vue'
import ResetPassword from '@/pages/auth/reset-password/index.vue'
import EmailValidation from '@/pages/auth/email-validation/index.vue'
import Settings from '@/pages/settings/index.vue'
import SettingsNotifications from '@/pages/settings/notifications/index.vue'
import SettingsProfile from '@/pages/settings/profile/index.vue'
import SettingsAccount from '@/pages/settings/account/index.vue'
import SettingsWebhooks from '@/pages/settings/webhooks/index.vue'
import Links from '@/pages/links/index.vue'

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
  },
  {
    name: 'EmailValidation',
    path: '/auth/email-validation',
    component: EmailValidation
  },
  {
    name: 'ForgotPassword',
    path: '/auth/forgot-password',
    component: ForgotPassword
  },
  {
    name: 'ResetPassword',
    path: '/auth/reset-password',
    component: ResetPassword
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
      },
      {
        name: 'SettingsWebhooks',
        path: 'webhooks',
        component: SettingsWebhooks
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
      },
      {
        name: 'ProjectImages',
        path: 'images',
        component: ProjectImages
      }
    ]
  },
  {
    name: 'NewProject',
    path: '/new/project',
    component: NewProject
  },
  {
    name: 'ProjectSettings',
    path: '/p/:slug/settings',
    component: ProjectSettings,
    redirect: {
      name: 'ProjectSettingsInformations'
    },
    children: [
      {
        name: 'ProjectSettingsInformations',
        component: ProjectSettingsInformations,
        path: 'informations'
      },
      {
        name: 'ProjectSettingsImages',
        component: ProjectSettingsImages,
        path: 'images'
      },
      {
        name: 'ProjectSettingsWebhooks',
        component: ProjectSettingsWebhooks,
        path: 'webhooks'
      },
      {
        name: 'ProjectSettingsIntegrations',
        component: ProjectSettingsIntegrations,
        path: 'integrations'
      }
    ]
  },
  {
    name: 'Links',
    path: '/links',
    component: Links
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
