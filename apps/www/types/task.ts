import { Comment } from './comment'
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
  createdAt: string
  likes: User[]
  comments: Comment[]
  commentsCount: number
  likesCount: number
  images: Array<{
    uuid: string
    url: string
    thumbnailUrl: string
  }>
  projects?: Array<Project>,
  mentions?: Array<User>,
  metrics: {
    comments: number
    likes: string[]
  }
}
