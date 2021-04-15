import { User } from './user'

export type Comment = {
  content: string
  created_at: string
  updated_at: string
  user: User
}
