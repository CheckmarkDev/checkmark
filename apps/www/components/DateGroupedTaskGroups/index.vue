<template>
  <div>
    <template
      v-if="groups.length"
    >
      <div
        v-for="(group, k) in groups"
        :key="k"
      >
        <div class="flex items-center mb-4">
          <div
            class="text-2xl mr-3 font-semibold text-gray-700 dark:text-white"
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
    </template>
    <template
      v-else
    >
      <p
        v-text="$accessor.project.getFilters.state
          ? $trans('user.paragraphs.no_tasks_filter')
          : $trans('user.paragraphs.no_tasks')"
      />
    </template>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

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
    props: {
      taskGroups: {
        type: Array as () => Array<TaskGroup>,
        required: true
      }
    },
    setup (props) {
      const { taskGroups } = toRefs(props)
      const groups = computed(() => {
        const groups: Array<Group> = []

        taskGroups.value.forEach(taskGroup => {
          const date = dayjs(taskGroup.created_at).tz('Europe/Paris').format('YYYY-MM-DD')

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

        return groups.map(group => ({
          ...group,
          taskGroups: group.taskGroups.sort((a, b) => {
            return dayjs(b.updated_at).isAfter(dayjs(a.updated_at)) ? 1 : -1
          })
        }))
      })

      return {
        dayjs,
        groups
      }
    }
  })
</script>
