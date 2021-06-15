import { User } from './user'
import { Project } from './project'

export enum TaskState {
  TODO = 'todo',
  DOING = 'doing',
  DONE = 'done'
}

export enum TaskSource {
  CHECKMARK = 'checkmark',
  GITHUB = 'github'
}

export type Task = {
  uuid: string
  state: TaskState
  source: TaskSource
  content: string
  user: User
  created_at: string
  likes: string[]
  images: Array<{
    uuid: string
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
