<template>
  <div>
    <div
      v-for="(group, k) in groups"
      :key="k"
    >
      <div class="flex items-center mb-4">
        <!-- v-if="group.isToday" -->
        <div
          class="text-2xl mr-3"
        >
          <!-- {{ $trans('home.titles.today') }} -->
          {{ dayjs(group.date).utc(true).format('LL') }}
        </div>
        <!-- <div class="text-gray-700">
          {{ dayjs(group.date).format('LL') }}
        </div> -->
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
          const date = dayjs(taskGroup.created_at).utc().format('YYYY-MM-DD')

          const groupIndex = groups.findIndex(group => group.date === date)
          if (groupIndex !== -1) {
            groups[groupIndex].taskGroups.push(taskGroup)
          } else {
            groups.push({
              date,
              // isToday: dayjs().utc().format('YYYY-MM-DD') === dayjs(date).utc(true).startOf('day').format('YYYY-MM-DD'),
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
