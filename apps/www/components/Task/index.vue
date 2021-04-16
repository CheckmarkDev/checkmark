<template>
  <div class="task flex items-start">
    <TaskCheck
      :state="task.state"
      class="bg-white rounded-full mr-4 mt-1"
    />
    <div
      class="flex flex-col flex-1"
    >
      <p>
        {{ task.content }}
      </p>
      <MarkAsButton
        v-if="$accessor.getAuthUser && task.user.uuid === $accessor.getAuthUser.uuid && task.state !== 'done'"
        :task="task"
        class="my-4"
      />
    </div>
    <div class="hidden md:flex items-center mt-1">
      <nuxt-link
        :to="{
          name: 'Task',
          params: {
            username: task.user.username,
            task: task.uuid
          }
        }"
        class="mr-2 text-sm text-gray-600 truncate flex-shrink hover:underline"
      >
        {{ date }}
      </nuxt-link>
      <LikeButton
        :task="task"
        class="mr-4"
      />
      <TaskActions
        v-if="$accessor.getAuthUser && task.user.uuid === $accessor.getAuthUser.uuid"
        :task="task"
      />
    </div>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

  import TaskCheck from '@/components/TaskCheck/index.vue'
  import MarkAsButton from './MarkAsButton/index.vue'
  import LikeButton from './LikeButton/index.vue'
  import TaskActions from './TaskActions/index.vue'

  import { Task } from '@/types/task'

  export default defineComponent({
    name: 'Task',
    components: {
      TaskCheck,
      LikeButton,
      TaskActions,
      MarkAsButton
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)

      const date = computed(() => {
        return dayjs(task.value.created_at).format('LT')
      })

      return {
        date
      }
    }
  })
</script>
