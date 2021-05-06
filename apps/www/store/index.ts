import { ActionTree, GetterTree, MutationTree, ActionContext } from 'vuex'
import cookieparser from 'cookieparser'
import Cookie from 'js-cookie'
import { getAccessorType } from 'typed-vuex'
import { User } from '~/types/user'
import { Task } from '~/types/task'
import { NuxtAxiosInstance } from '@nuxtjs/axios'
import { TaskGroup } from '~/types/taskGroup'
import { PaginateResponse, PaginateResponseMeta } from '~/types/pagination'

export interface State {
  auth: {
    token: string | null
    user: User | null
  },
  taskGroups: {
    items: Array<TaskGroup>
    meta: PaginateResponseMeta | null
  }
}

export const strict = false

export const state = (): State => ({
  auth: {
    token: null,
    user: null
  },
  taskGroups: {
    items: [],
    meta: null
  }
})

export type RootState = ReturnType<typeof state>

export enum GetterTypes {
  isAuthenticated = 'isAuthenticated',
  getAuthUser = 'getAuthUser',
  getTaskGroups = 'getTaskGroups',
  getTaskGroupsMeta = 'getTaskGroupsMeta'
}

export type Getters<S = RootState> = {
  [GetterTypes.isAuthenticated]: (state: S) => boolean
  [GetterTypes.getAuthUser]: (state: S) => User | null
  [GetterTypes.getTaskGroups]: (state: S) => Array<TaskGroup>
  [GetterTypes.getTaskGroupsMeta]: (state: S) => PaginateResponseMeta | null
}

export type InnerGetter = {
  [Property in GetterTypes]: ReturnType<Getters<RootState>[Property]>
}

export const getters: GetterTree<RootState, RootState> & Getters<RootState> = {
  isAuthenticated: state => !!state.auth.token,
  getAuthUser: state => state.auth.user,
  getTaskGroups: state => state.taskGroups.items,
  getTaskGroupsMeta: state => state.taskGroups.meta
}

export enum MutationTypes {
  SET_AUTH_TOKEN = 'SET_AUTH_TOKEN',
  SET_AUTH_USER = 'SET_AUTH_USER',
  SET_TASK_GROUPS = 'SET_TASK_GROUPS',
  PUSH_TASK_GROUPS = 'PUSH_TASK_GROUPS',
  SET_TASK_GROUPS_META = 'SET_TASK_GROUPS_META'
}

export type Mutations<S = RootState> = {
  [MutationTypes.SET_AUTH_TOKEN](state: S, token: string | null): void
  [MutationTypes.SET_AUTH_USER](state: S, user: User | null): void
  [MutationTypes.SET_TASK_GROUPS](state: S, taskGroups: Array<TaskGroup>): void
  [MutationTypes.PUSH_TASK_GROUPS](state: S, taskGroups: Array<TaskGroup>): void
  [MutationTypes.SET_TASK_GROUPS_META](state: S, meta: PaginateResponseMeta): void
}

export const mutations: MutationTree<RootState> & Mutations = {
  [MutationTypes.SET_AUTH_TOKEN] (state, token) {
    state.auth.token = token
  },
  [MutationTypes.SET_AUTH_USER] (state, user) {
    state.auth.user = user
  },
  [MutationTypes.SET_TASK_GROUPS] (state, taskGroups) {
    state.taskGroups.items = taskGroups
  },
  [MutationTypes.PUSH_TASK_GROUPS] (state, taskGroups) {
    state.taskGroups.items = [
      ...state.taskGroups.items,
      ...taskGroups
    ]
  },
  [MutationTypes.SET_TASK_GROUPS_META] (state, meta) {
    state.taskGroups.meta = meta
  }
}

export enum ActionTypes {
  setAuthToken = 'setAuthToken',
  setAuthUser = 'setAuthUser',
  signOut = 'signOut',
  retrieveMe = 'retrieveMe',
  retrieveTaskGroups = 'retrieveTaskGroups',
  retrieveMoreTaskGroups = 'retrieveMoreTaskGroups',
  createTask = 'createTask',
}

type AugmentedActionContext = {
  commit<K extends keyof Mutations>(
    key: K,
    payload: Parameters<Mutations[K]>[1]
  ): ReturnType<Mutations[K]>
}
& Omit<ActionContext<State, State>, 'commit'>
& Omit<ActionContext<State, State>, 'getters'>

export interface Actions<R = RootState> {
  [ActionTypes.setAuthToken]({ commit }: AugmentedActionContext, token: string | null): void
  [ActionTypes.setAuthUser]({ commit }: AugmentedActionContext, user: User | null): void
  [ActionTypes.signOut]({ commit }: AugmentedActionContext): void
  [ActionTypes.retrieveMe]({ commit }: AugmentedActionContext): void
  [ActionTypes.retrieveTaskGroups]({ commit }: AugmentedActionContext): Promise<PaginateResponse<Task>>
  [ActionTypes.retrieveMoreTaskGroups]({ commit }: AugmentedActionContext): Promise<PaginateResponse<Task>> | void
}

export const actions: ActionTree<RootState, RootState> & Actions = {
  [ActionTypes.setAuthToken] ({ commit }, token) {
    commit(MutationTypes.SET_AUTH_TOKEN, token)
  },
  [ActionTypes.setAuthUser] ({ commit }, user) {
    commit(MutationTypes.SET_AUTH_USER, user)
  },
  [ActionTypes.signOut] ({ dispatch }) {
    Cookie.remove('token')
    Cookie.remove('user')

    dispatch(ActionTypes.setAuthToken, null)
    dispatch(ActionTypes.setAuthUser, null)
  },
  [ActionTypes.retrieveMe] ({ commit }) {
    return (this.$axios as NuxtAxiosInstance).$get('/auth/me')
      .then((res: {
        user: User
      }) => {
        commit(MutationTypes.SET_AUTH_USER, res.user)

        return res
      })
  },
  [ActionTypes.retrieveTaskGroups] ({ commit }) {
    return (this.$axios as NuxtAxiosInstance).$get('/task_groups')
      .then((res: PaginateResponse<Task>) => {
        commit(MutationTypes.SET_TASK_GROUPS, res.data)
        commit(MutationTypes.SET_TASK_GROUPS_META, res.meta)

        return res
      })
  },
  [ActionTypes.retrieveMoreTaskGroups] ({ commit, getters }) {
    const meta = getters[GetterTypes.getTaskGroupsMeta]
    if (!meta) return
    if (meta.current_page + 1 > meta.total_pages) return

    return (this.$axios as NuxtAxiosInstance).$get('/task_groups', {
      params: {
        page: meta.current_page + 1
      }
    })
      .then((res: PaginateResponse<Task>) => {
        commit(MutationTypes.PUSH_TASK_GROUPS, res.data)
        commit(MutationTypes.SET_TASK_GROUPS_META, res.meta)

        return res
      })
  },
  nuxtServerInit ({ commit, dispatch }, { req }) {
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
    if (user && token) {
      dispatch(ActionTypes.retrieveMe)
    }
  }
}

export const accessorType = getAccessorType({
  state,
  getters,
  mutations,
  actions
})
