<template>
  <apollo-mutation
    :mutation="updateTask"
  >
    <template v-slot="{ mutate, loading }">
      <div
        class="border border-solid border-gray-300 dark:border-gray-600 md:pl-2 rounded text-sm mr-auto"
      >
        <div class="flex items-center">
          <div
            class="hidden md:block mr-2 text-gray-600 dark:text-gray-300"
            v-text="$trans('home.buttons.mark-as')"
          />
          <div class="flex">
            <button
              v-if="task.state !== 'doing'"
              :disabled="loading"
              class="hover:bg-gray-200 dark:hover:bg-gray-600 dark:text-white p-2 border border-solid border-gray-300 dark:border-gray-600 border-l-0 md:border-l border-r-0 border-t-0 border-b-0"
              type="button"
              @click="mutate({ variables: {
                taskUuid: task.uuid,
                state: TaskState.DOING
              }})"
            >
              <div class="flex items-center">
                <task-check
                  state="doing"
                  source="checkmark"
                  class="w-4 h-4 mr-2"
                />
                <div
                  v-text="$trans('home.labels.doing')"
                  class=""
                />
              </div>
            </button>
            <button
              :disabled="loading"
              class="hover:bg-gray-200 dark:hover:bg-gray-600 dark:text-white dark:border-gray-600 p-2 border border-solid border-gray-300 border-r-0 md:border-l border-t-0 border-b-0"
              type="button"
              @click="mutate({ variables: {
                taskUuid: task.uuid,
                state: TaskState.DONE
              }})"
            >
              <div class="flex items-center">
                <task-check
                  state="done"
                  source="checkmark"
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
  </apollo-mutation>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import gql from 'graphql-tag'

  import { Task, TaskState } from '@/types/task'

  // @ts-ignore
  import user from '@/apollo/fragments/user.gql'
  // @ts-ignore
  import task from '@/apollo/fragments/task.gql'

  export default defineComponent({
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props, { refs }) {
      const updateTask = gql`
        mutation updateTask ($taskUuid: String!, $content: String, $state: String) {
          update_task (input: {taskUuid: $taskUuid, content: $content, state: $state }) {
            task {
              ...task
              task_group {
                uuid
              }
            }
          }
        }

        ${user}
        ${task}
      `

      return {
        TaskState,
        updateTask
      }
    }
  })
</script>
