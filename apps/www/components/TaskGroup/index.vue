<template>
  <div class="task-group flex flex-col border border-solid border-gray-300 rounded-lg p-4">
    <div class="flex items-start mb-2">
      <div class="w-16">
        <div class="w-12 h-12 rounded-full bg-gray-300 relative">
        </div>
      </div>
      <div class="flex flex-col flex-1 leading-tight">
        <nuxt-link
          :to="{
            name: 'User',
            params: {
              username: taskGroup.user.username
            }
          }"
        >
          <div class="font-medium text-lg">
            {{ taskGroup.user.first_name }} {{ taskGroup.user.last_name }}
          </div>
        </nuxt-link>
        <nuxt-link
          :to="{
            name: 'User',
            params: {
              username: taskGroup.user.username
            }
          }"
          class="text-base text-gray-600"
        >
          @{{ taskGroup.user.username }}
        </nuxt-link>
      </div>
    </div>
    <div>
      <div class="task-group__content flex flex-col text-base text-gray-800">
        <Task
          v-for="task in taskGroup.tasks"
          :key="task.uuid"
          :task="task"
          class="mb-2"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

  import Task from '@/components/Task/index.vue'
  import { TaskGroup } from '@/types/taskGroup'

  export default defineComponent({
    name: 'TaskGroup',
    components: {
      Task
    },
    props: {
      taskGroup: {
        type: Object as () => TaskGroup,
        required: true
      }
    },
    setup (props) {
      const { taskGroup } = toRefs(props)
    }
  })
</script>

<style scoped>
  .task-group__content {
    padding-left: 0;

    @screen md {
      padding-left: 64px;
    }
  }

  .task-group .task:not(:last-child) {
    @apply border-b border-gray-300 border-solid pb-2;
  }
</style>
