import { GetterTree } from 'vuex'

import { State } from './state'

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
