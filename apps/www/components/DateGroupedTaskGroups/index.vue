<template>
  <div>
    <div
      v-for="(group, k) in groups"
      :key="k"
    >
      <div class="flex items-center mb-4">
        <div
          class="text-2xl mr-3"
          v-text="dayjs(group.date).format('LL')"
        />
      </div>
      <TaskGroup
        v-for="taskGroup in group.taskGroups"
        :key="taskGroup.uuid"
        :task-group="taskGroup"
        class="mb-4"
      />
    </div>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'
  import gql from 'graphql-tag'
  import { useQuery, useResult } from '@vue/apollo-composable/dist'

  import { TaskGroup } from '~/types/taskGroup'
  import TaskGroupComponent from '@/components/TaskGroup/index.vue'

  type Group = {
    date: string
    isToday?: boolean
    taskGroups: Array<TaskGroup>
  }

  export default defineComponent({
    name: 'DateGroupedTaskGroups',
    components: {
      TaskGroup: TaskGroupComponent
    },
    setup () {
      const { result } = useQuery(gql`
        query {
          allTaskGroups {
            nodes {
              uuid
              createdAt
              user {
                uuid
                fullName
                username
                streak
                avatarUrl
              }
              tasks {
                uuid
                state
                content
                createdAt
                commentsCount
                likesCount
                likes
                images {
                  url
                  thumbnailUrl
                }
                user {
                  uuid
                  username
                }
              }
            }
          }
        }
      `)

      const groups = computed(() => {
        const groups: Array<Group> = []

        const taskGroups = useResult(result, [], data => data.allTaskGroups && data.allTaskGroups.nodes)
        taskGroups.value.forEach(taskGroup => {
          const date = dayjs(taskGroup.createdAt).tz('Europe/Paris').format('YYYY-MM-DD')

          const groupIndex = groups.findIndex(group => group.date === date)
          if (groupIndex !== -1) {
            groups[groupIndex].taskGroups.push(taskGroup)
          } else {
            groups.push({
              date,
              taskGroups: [
                taskGroup
              ]
            })
          }
        })

        return groups
      })

      return {
        dayjs,
        groups
      }
    }
  })
</script>
