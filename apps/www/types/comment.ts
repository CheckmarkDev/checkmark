import { User } from './user'

export type Comment = {
  uuid: string
  content: string
  created_at: string
  updated_at: string
  user: User
}
