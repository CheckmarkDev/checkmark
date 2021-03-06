import { Project } from "./project"

export type User = {
  uuid: string
  username: string
  first_name: string
  last_name: string
  streak: number
  avatar_url: string
  email: string

  projects?: Array<Project>
}
