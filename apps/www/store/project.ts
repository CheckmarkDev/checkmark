import { NuxtAxiosInstance } from '@nuxtjs/axios'
import { getAccessorType } from 'nuxt-typed-vuex'
import { ActionTree, GetterTree, MutationTree, ActionContext } from 'vuex'

import { Project } from '~/types/project'

export interface State {
  projects: Array<Project>,
  project: Project|null
}

export const strict = false

export const state = (): State => ({
  projects: [],
  project: null
})

export type RootState = ReturnType<typeof state>

export enum MutationTypes {
  SET_PROJECTS = 'SET_PROJECTS',
  SET_PROJECT = 'SET_PROJECT'
}

export type Mutations<S = State> = {
  [MutationTypes.SET_PROJECTS](state: S, projects: Array<Project>): void
  [MutationTypes.SET_PROJECT](state: S, project: Project): void
}

export const mutations: MutationTree<State> & Mutations = {
  [MutationTypes.SET_PROJECTS] (state, projects) {
    state.projects = projects
  },
  [MutationTypes.SET_PROJECT] (state, project) {
    state.project = project
  }
}

export enum GetterTypes {
  getProjects = 'getProjects',
  getProject = 'getProject',
  // getAuthUser = 'getAuthUser',
  // getTaskGroups = 'getTaskGroups',
  // getTaskGroupsMeta = 'getTaskGroupsMeta'
}

export type Getters<S = State> = {
  [GetterTypes.getProjects]: (state: S) => any
  [GetterTypes.getProject]: (state: S) => Project|null
  // [GetterTypes.getAuthUser]: (state: S) => User | null
  // [GetterTypes.getTaskGroups]: (state: S) => Array<TaskGroup>
  // [GetterTypes.getTaskGroupsMeta]: (state: S) => PaginateResponseMeta | null
}

export const getters: GetterTree<State, State> & Getters<State> = {
  getProjects: state => '',
  getProject: state => state.project,
  // getAuthUser: state => state.auth.user,
  // getTaskGroups: state => state.taskGroups.items,
  // getTaskGroupsMeta: state => state.taskGroups.meta
}

export enum ActionTypes {
  retrieveProject = 'retrieveProject'
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
}

export const actions: ActionTree<State, State> & Actions = {
  [ActionTypes.retrieveProject] ({ commit }, slug) {
    return (this.$axios as NuxtAxiosInstance).$get(`/me/projects/${slug}`)
      .then((project: Project) => {
        commit(MutationTypes.SET_PROJECT, project)

        return project
      })
  }
}

export const accessorType = getAccessorType({
  state,
  getters,
  mutations,
  actions
})
