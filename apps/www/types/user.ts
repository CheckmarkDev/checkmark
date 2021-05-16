import { Project } from "./project"

export type User = {
  uuid: string
  username: string
  firstName: string
  lastName: string
  fullName: string
  streak: number
  avatarUrl: string
  email: string

  projects?: Array<Project>
}
