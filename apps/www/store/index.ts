import { ActionTree, GetterTree, MutationTree, ActionContext } from 'vuex'
import cookieparser from 'cookieparser'
import { getAccessorType } from 'typed-vuex'
import { User } from '~/types/user'
import { Task } from '~/types/task'
import { NuxtAxiosInstance } from '@nuxtjs/axios'

type PaginateResponseMeta = {
  current_page: number,
  total_pages: number,
  count: number
}

export interface State {
  auth: {
    token: string | null
    user: User | null
  },
  tasks: {
    items: Array<Task>
    meta: PaginateResponseMeta | null
  }
}

type PaginateResponse<T> = {
  data: Array<T>,
  meta: PaginateResponseMeta
}

export const strict = false

export const state = (): State => ({
  auth: {
    token: null,
    user: null
  },
  tasks: {
    items: [],
    meta: null
  }
})

export type RootState = ReturnType<typeof state>

export enum GetterTypes {
  isAuthenticated = 'isAuthenticated',
  getAuthUser = 'getAuthUser',
  getTasks = 'getTasks',
  getTasksMeta = 'getTasksMeta'
}

export type Getters<S = RootState> = {
  [GetterTypes.isAuthenticated]: (state: S) => boolean
  [GetterTypes.getAuthUser]: (state: S) => User | null
  [GetterTypes.getTasks]: (state: S) => Array<Task>
  [GetterTypes.getTasksMeta]: (state: S) => PaginateResponseMeta | null
}

export type InnerGetter = {
  [Property in GetterTypes]: ReturnType<Getters<RootState>[Property]>
}

export const getters: GetterTree<RootState, RootState> & Getters<RootState> = {
  isAuthenticated: state => !!state.auth.token,
  getAuthUser: state => state.auth.user,
  getTasks: state => state.tasks.items,
  getTasksMeta: state => state.tasks.meta
}

export enum MutationTypes {
  SET_AUTH_TOKEN = 'SET_AUTH_TOKEN',
  SET_AUTH_USER = 'SET_AUTH_USER',
  SET_TASKS = 'SET_TASKS',
  PUSH_TASKS = 'PUSH_TASKS',
  SET_TASKS_META = 'SET_TASKS_META'
}

export type Mutations<S = RootState> = {
  [MutationTypes.SET_AUTH_TOKEN](state: S, token: string | null): void
  [MutationTypes.SET_AUTH_USER](state: S, user: User | null): void
  [MutationTypes.SET_TASKS](state: S, tasks: Array<Task>): void
  [MutationTypes.PUSH_TASKS](state: S, tasks: Array<Task>): void
  [MutationTypes.SET_TASKS_META](state: S, meta: PaginateResponseMeta): void
}

export const mutations: MutationTree<RootState> & Mutations = {
  [MutationTypes.SET_AUTH_TOKEN] (state, token) {
    state.auth.token = token
  },
  [MutationTypes.SET_AUTH_USER] (state, user) {
    state.auth.user = user
  },
  [MutationTypes.SET_TASKS] (state, tasks) {
    state.tasks.items = tasks
  },
  [MutationTypes.PUSH_TASKS] (state, tasks) {
    state.tasks.items = [
      ...state.tasks.items,
      ...tasks
    ]
  },
  [MutationTypes.SET_TASKS_META] (state, meta) {
    state.tasks.meta = meta
  }
}

export enum ActionTypes {
  setAuthToken = 'setAuthToken',
  setAuthUser = 'setAuthUser',
  retrieveTasks = 'retrieveTasks',
  retrieveMoreTasks = 'retrieveMoreTasks',
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
  [ActionTypes.retrieveTasks]({ commit }: AugmentedActionContext): Promise<PaginateResponse<Task>>
  [ActionTypes.retrieveMoreTasks]({ commit }: AugmentedActionContext): Promise<PaginateResponse<Task>> | void
}

export const actions: ActionTree<RootState, RootState> & Actions = {
  [ActionTypes.setAuthToken] ({ commit }, token) {
    commit(MutationTypes.SET_AUTH_TOKEN, token)
  },
  [ActionTypes.setAuthUser] ({ commit }, user) {
    commit(MutationTypes.SET_AUTH_USER, user)
  },
  [ActionTypes.retrieveTasks] ({ commit }) {
    return (this.$axios as NuxtAxiosInstance).$get('/tasks')
      .then((res: PaginateResponse<Task>) => {
        commit(MutationTypes.SET_TASKS, res.data)
        commit(MutationTypes.SET_TASKS_META, res.meta)

        return res
      })
  },
  [ActionTypes.retrieveMoreTasks] ({ commit, getters }) {
    const meta = getters[GetterTypes.getTasksMeta]
    if (!meta) return
    if (meta.current_page + 1 > meta.total_pages) return

    return (this.$axios as NuxtAxiosInstance).$get('/tasks', {
      params: {
        page: meta.current_page + 1
      }
    })
      .then((res: PaginateResponse<Task>) => {
        commit(MutationTypes.PUSH_TASKS, res.data)
        commit(MutationTypes.SET_TASKS_META, res.meta)

        return res
      })
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
