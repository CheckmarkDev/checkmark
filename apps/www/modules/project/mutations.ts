import { MutationTree } from 'vuex'

import { Project } from '~/types/project'

import { State } from './state'

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
