import { User } from './user'

export type Like = {
  uuid: string
  created_at: string
  updated_at: string
  user: User
}
