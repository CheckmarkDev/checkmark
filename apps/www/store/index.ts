import { ActionTree, GetterTree, MutationTree, ActionContext } from 'vuex'
import cookieparser from 'cookieparser'
import { getAccessorType } from 'typed-vuex'

export type User = {
}

export interface State {
  auth: {
    token: string | null
    user: User | null
  }
}

export const strict = false

export const state = (): State => ({
  auth: {
    token: null,
    user: null
  }
})

export type RootState = ReturnType<typeof state>

export enum GetterTypes {
  isAuthenticated = 'isAuthenticated',
  getAuthUser = 'getAuthUser'
}

export type Getters<S> = {
  [GetterTypes.isAuthenticated]: (state: S) => boolean
  [GetterTypes.getAuthUser]: (state: S) => User | null
}

export type InnerGetter = {
  [Property in GetterTypes]: ReturnType<Getters<RootState>[Property]>
}

export const getters: GetterTree<RootState, RootState> & Getters<RootState> = {
  isAuthenticated: state => !!state.auth.token,
  getAuthUser: state => state.auth.user
}

export enum MutationTypes {
  SET_AUTH_TOKEN = 'SET_AUTH_TOKEN',
  SET_AUTH_USER = 'SET_AUTH_USER'
}

export type Mutations<S = RootState> = {
  [MutationTypes.SET_AUTH_TOKEN](state: S, token: string | null): void
  [MutationTypes.SET_AUTH_USER](state: S, user: User | null): void
}

export const mutations: MutationTree<RootState> & Mutations = {
  [MutationTypes.SET_AUTH_TOKEN] (state, token) {
    state.auth.token = token
  },
  [MutationTypes.SET_AUTH_USER] (state, user) {
    state.auth.user = user
  }
}

export enum ActionTypes {
  setAuthToken = 'setAuthToken',
  setAuthUser = 'setAuthUser',
}

type AugmentedActionContext = {
  commit<K extends keyof Mutations>(
    key: K,
    payload: Parameters<Mutations[K]>[1]
  ): ReturnType<Mutations[K]>
} & Omit<ActionContext<State, State>, 'commit'>

export interface Actions<R = RootState> {
  [ActionTypes.setAuthToken]({ commit }: AugmentedActionContext, token: string | null): void
  [ActionTypes.setAuthUser]({ commit }: AugmentedActionContext, user: User | null): void
}

export const actions: ActionTree<RootState, RootState> & Actions = {
  [ActionTypes.setAuthToken] ({ commit }, token) {
    commit(MutationTypes.SET_AUTH_TOKEN, token)
  },
  [ActionTypes.setAuthUser] ({ commit }, user) {
    commit(MutationTypes.SET_AUTH_USER, user)
  },
  nuxtServerInit ({ commit }, { req }) {
    let token = null
    let user = null

    if (req.headers.cookie) {
      const parsed = cookieparser.parse(req.headers.cookie)
      try {
        if (parsed.token) {
          token = parsed.token
        }

        if (parsed.user) {
          user = JSON.parse(parsed.user)
        }
      } catch (err) {
        // No valid cookie found
        console.error('Some error occured here?', err)
      }
    }

    commit(MutationTypes.SET_AUTH_TOKEN, token)
    commit(MutationTypes.SET_AUTH_USER, user)
  }
}

export const accessorType = getAccessorType({
  state,
  getters,
  mutations,
  actions
})
