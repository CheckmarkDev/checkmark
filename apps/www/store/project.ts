import { NuxtAxiosInstance } from '@nuxtjs/axios'
import { getAccessorType } from 'nuxt-typed-vuex'
import { ActionTree, GetterTree, MutationTree, ActionContext } from 'vuex'

import { Project } from '~/types/project'
import { TaskState } from '~/types/task'

export interface State {
  projects: Array<Project>,
  project: Project|null,
  filters: {
    state: TaskState|null
  }
}

export const strict = false

export const state = (): State => ({
  projects: [],
  project: null,
  filters: {
    state: null
  }
})

export type RootState = ReturnType<typeof state>

export enum MutationTypes {
  SET_PROJECTS = 'SET_PROJECTS',
  SET_PROJECT = 'SET_PROJECT',
  SET_FILTER = 'SET_FILTER'
}

export type Mutations<S = State> = {
  [MutationTypes.SET_PROJECTS](state: S, projects: Array<Project>): void
  [MutationTypes.SET_PROJECT](state: S, project: Project): void
  [MutationTypes.SET_FILTER](state: S, params: { name: string, value: TaskState|null }): void
}

export const mutations: MutationTree<State> & Mutations = {
  [MutationTypes.SET_PROJECTS] (state, projects) {
    state.projects = projects
  },
  [MutationTypes.SET_PROJECT] (state, project) {
    state.project = project
  },
  [MutationTypes.SET_FILTER] (state, { name, value }) {
    (state.filters as {
      [x: string]: any
    })[name] = value
  }
}

export enum GetterTypes {
  getProjects = 'getProjects',
  getProject = 'getProject',
  getFilters = 'getFilters',
}

export type Getters<S = State> = {
  [GetterTypes.getProjects]: (state: S) => any
  [GetterTypes.getProject]: (state: S) => Project|null,
  [GetterTypes.getFilters]: (state: S) => { state: TaskState|null }
}

export const getters: GetterTree<State, State> & Getters<State> = {
  getProjects: state => '',
  getProject: state => state.project,
  getFilters: state => state.filters
}

export enum ActionTypes {
  retrieveProject = 'retrieveProject',
  updateProject = 'updateProject',
  addImages = 'addImages',
  setFilter = 'setFilter',
}

type AugmentedActionContext = {
  commit<K extends keyof Mutations>(
    key: K,
    payload: Parameters<Mutations[K]>[1]
  ): ReturnType<Mutations[K]>
}
& Omit<ActionContext<State, State>, 'commit'>
& Omit<ActionContext<State, State>, 'getters'>

export interface Actions<R = State> {
  [ActionTypes.retrieveProject]({ commit }: AugmentedActionContext, slug: string): Promise<any>
  // TODO: Use type for data
  [ActionTypes.updateProject]({ commit }: AugmentedActionContext, params: { slug: string, data: any }): Promise<any>
  [ActionTypes.addImages]({ commit }: AugmentedActionContext, params: { slug: string, images: any }): Promise<any>
  [ActionTypes.setFilter]({ commit }: AugmentedActionContext, params: { name: string, value: TaskState|null }): void
}

export const actions: ActionTree<State, State> & Actions = {
  [ActionTypes.setFilter] ({ commit }, { name, value }) {
    commit(MutationTypes.SET_FILTER, {
      name,
      value
    })
  },
  [ActionTypes.retrieveProject] ({ commit }, slug) {
    return (this.$axios as NuxtAxiosInstance).$get(`/projects/${slug}`)
      .then((project: Project) => {
        commit(MutationTypes.SET_PROJECT, project)

        return project
      })
  },
  [ActionTypes.updateProject] ({ commit }, { slug, data }) {
    const formData = new FormData()
    Object.keys(data).forEach(key => {
      if (data[key]) formData.append(key, data[key])
    })

    return (this.$axios as NuxtAxiosInstance).put(`/me/projects/${slug}`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
      .then(res => {
        commit(MutationTypes.SET_PROJECT, res.data)

        return res
      })
  },
  [ActionTypes.addImages] ({ commit }, { slug, images }) {
    const formData = new FormData()
    images.forEach((image: any) => {
      formData.append('screenshots[]', image)
    })

    return (this.$axios as NuxtAxiosInstance).post(`/me/projects/${slug}/screenshots`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
      .then(res => {
        commit(MutationTypes.SET_PROJECT, res.data)

        return res
      })
  }
}

export const accessorType = getAccessorType({
  state,
  getters,
  mutations,
  actions
})
