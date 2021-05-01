import { User } from './user'

export type Comment = {
  uuid: string
  content: string
  createdAt: string
  updatedAt: string
  user: User
}
