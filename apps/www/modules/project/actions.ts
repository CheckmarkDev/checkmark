
import { ActionTree, ActionContext } from 'vuex'

import { State } from './state'
import { Mutations } from './mutations'

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
