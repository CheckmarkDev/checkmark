<template>
  <div class="task-group flex flex-col border border-solid border-gray-300 dark:border-gray-600 rounded-lg p-4">
    <nuxt-link
      :to="{
        name: 'User',
        params: {
          username: taskGroup.user.username
        }
      }"
      class="mr-auto mb-4 w-full md:w-auto"
    >
      <UserCard
        :user="taskGroup.user"
        class="mb-2"
      />
    </nuxt-link>
    <div>
      <div class="task-group__content flex flex-col text-base text-gray-800">
        <Task
          v-for="task in taskGroup.tasks"
          :key="task.uuid"
          :task="task"
          :user="taskGroup.user"
          class="mb-2"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import Task from '@/components/Task/index.vue'
  import UserCard from '@/components/UserCard/index.vue'
  import { TaskGroup } from '@/types/taskGroup'

  export default defineComponent({
    name: 'TaskGroup',
    components: {
      Task,
      UserCard
    },
    props: {
      taskGroup: {
        type: Object as () => TaskGroup,
        required: true
      }
    }
  })
</script>

<style scoped>
  .task-group__content {
    padding-left: 0;
  }

  @screen md {
    .task-group__content {
      padding-left: 64px;
    }
  }

  .task-group .task:not(:last-child) {
    @apply border-b border-gray-300 border-solid pb-2 dark:border-gray-600;
  }
</style>
