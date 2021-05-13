import { getAccessorType } from 'nuxt-typed-vuex'
import { ActionTree, GetterTree, MutationTree, ActionContext } from 'vuex'

import { Project } from '~/types/project'

export interface State {
  projects: Array<Project>
}

export const strict = false

export const state = (): State => ({
  projects: []
})

export type RootState = ReturnType<typeof state>

export enum MutationTypes {
  SET_PROJECTS = 'SET_PROJECTS'
}

export type Mutations<S = State> = {
  [MutationTypes.SET_PROJECTS](state: S, projects: Array<Project>): void
}

export const mutations: MutationTree<State> & Mutations = {
  [MutationTypes.SET_PROJECTS] (state, projects) {
    state.projects = projects
  }
}

export enum GetterTypes {
  getProjects = 'getProjects',
  // getAuthUser = 'getAuthUser',
  // getTaskGroups = 'getTaskGroups',
  // getTaskGroupsMeta = 'getTaskGroupsMeta'
}

export type Getters<S = State> = {
  [GetterTypes.getProjects]: (state: S) => any
  // [GetterTypes.getAuthUser]: (state: S) => User | null
  // [GetterTypes.getTaskGroups]: (state: S) => Array<TaskGroup>
  // [GetterTypes.getTaskGroupsMeta]: (state: S) => PaginateResponseMeta | null
}

export const getters: GetterTree<State, State> & Getters<State> = {
  getProjects: state => '',
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
    // TODO: Add retrive project request
    return Promise.resolve()
  }
}

export const accessorType = getAccessorType({
  state,
  getters,
  mutations,
  actions
})
