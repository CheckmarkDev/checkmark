<template>
  <div class="flex flex-col border border-solid border-gray-300 rounded-lg p-4">
    <div class="flex items-start mb-2">
      <div class="w-16">
        <div class="w-12 h-12 rounded-full bg-gray-300 relative">
          <task-check
            :state="task.state"
            class="absolute bottom-0 right-0 bg-white rounded-full"
          />
        </div>
      </div>
      <div class="flex flex-col flex-1 leading-tight">
        <nuxt-link
          :to="{
            name: 'User',
            params: {
              username: task.user.username
            }
          }"
        >
          <div class="font-medium text-lg">
            {{ task.user.first_name }} {{ task.user.last_name }}
          </div>
        </nuxt-link>
        <nuxt-link
          :to="{
            name: 'User',
            params: {
              username: task.user.username
            }
          }"
          class="text-base text-gray-600"
        >
          @{{ task.user.username }}
        </nuxt-link>
      </div>
      <nuxt-link
        :to="{
          name: 'Task',
          params: {
            username: task.user.username,
            task: task.uuid
          }
        }"
        class="text-sm text-gray-600 truncate flex-shrink hover:underline"
      >
        {{ date }}
      </nuxt-link>
    </div>
    <div>
      <div class="task__content text-base text-gray-800">
        <p>
          {{ task.content }}
        </p>
        <button
          v-if="$accessor.getAuthUser && task.user.uuid === $accessor.getAuthUser.uuid && task.state !== 'done'"
          :disabled="$wait.is(`marking ${task.uuid} as done`)"
          type="button"
          class="border border-solid border-gray-300 hover:bg-gray-200 px-2 py-1 rounded mt-4 text-sm"
          @click="done"
        >
          <div class="flex items-center">
            <task-check
              state="done"
              class="mr-2 w-4 h-4"
            />
            <div
              v-text="$trans('home.buttons.mark-as-done')"
            />
          </div>
        </button>
      </div>
    </div>
    <div>
    </div>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

  import useWait from '@/composables/useWait'
  import useAxios from '@/composables/useAxios'
  import TaskCheck from '@/components/TaskCheck/index.vue'

  import { Task } from '@/types/task'

  export default defineComponent({
    components: {
      TaskCheck
    },
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

      const date = computed(() => {
        return dayjs(task.value.created_at).format('lll')
      })


      function done () {
        const { uuid } = task.value
        wait.start(`marking ${uuid} as done`)
        axios.put(`/me/tasks/${uuid}`, {
          state: 'done'
        })
          .finally(() => {
            wait.end(`marking ${uuid} as done`)
          })
      }

      return {
        date,
        done
      }
    }
  })
</script>

<style scoped>
  .task__content {
    padding-left: 0;

    @screen md {
      padding-left: 64px;
    }
  }
</style>
