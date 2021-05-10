import { User } from './user'
import { Project } from './project'

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
  likes: string[]
  images: Array<{
    url: string
    thumbnail_url: string
  }>
  projects?: Array<Project>,
  mentions?: Array<User>,
  metrics: {
    comments: number
    likes: string[]
  }
}
