import { User } from './user'

export enum TaskState {
  TODO = 'todo',
  DOING = 'doing',
  DONE = 'done'
}

export type Task = {
  uuid: string
  state: TaskState
  content: string
  user: User
  created_at: string
}
