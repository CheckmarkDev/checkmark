import { Task } from './task'
import { User } from './user'

export type TaskGroup = {
  uuid: string
  user: User
  tasks: Array<Task>
  created_at: string
  updated_at: string
}
