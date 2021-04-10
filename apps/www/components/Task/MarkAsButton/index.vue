<template>
  <div
    class="border border-solid border-gray-300 px-2 rounded mt-4 text-sm mr-auto"
  >
    <div class="flex items-center">
      <div
        class="mr-2 text-gray-600"
        v-text="$trans('home.buttons.mark-as')"
      />
      <div class="flex">
        <button
          v-if="task.state !== 'doing'"
          :disabled="$wait.is(`marking ${task.uuid} as doing`)"
          class="hover:bg-gray-200 p-2 border border-solid border-gray-300 border-t-0 border-b-0"
          type="button"
          @click="markAs(TaskState.DOING)"
        >
          <div class="flex items-center">
            <task-check
              state="doing"
              class="w-4 h-4 mr-2"
            />
            <div
              v-text="$trans('home.labels.doing')"
            />
          </div>
        </button>
        <button
          :disabled="$wait.is(`marking ${task.uuid} as done`)"
          class="hover:bg-gray-200 p-2 border border-solid border-gray-300 border-t-0 border-b-0"
          type="button"
          @click="markAs(TaskState.DONE)"
        >
          <div class="flex items-center">
            <task-check
              state="done"
              class="w-4 h-4 mr-2"
            />
            <div
              v-text="$trans('home.labels.done')"
            />
          </div>
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, toRefs } from '@nuxtjs/composition-api'

  import useWait from '@/composables/useWait'
  import useAxios from '@/composables/useAxios'
  import useMitt from '@/composables/useMitt'
  import { Task, TaskState } from '@/types/task'

  export default defineComponent({
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)
      const wait = useWait()
      const axios = useAxios()
      const mitt = useMitt()

      function markAs (state: TaskState) {
        const { uuid } = task.value
        console.log('ok?', state)
        wait.start(`marking ${uuid} as ${state}`)
        axios.put(`/me/tasks/${uuid}`, {
          state
        })
          .then(() => {
            mitt.emit('update-tasks')
          })
          .finally(() => {
            wait.end(`marking ${uuid} as ${state}`)
          })
      }

      return {
        TaskState,
        markAs
      }
    }
  })
</script>
