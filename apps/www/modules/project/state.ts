import { Project } from "~/types/project"

export interface State {
  projects: Array<Project>
}

export const strict = false

export const state = (): State => ({
  projects: []
})

export type RootState = ReturnType<typeof state>
