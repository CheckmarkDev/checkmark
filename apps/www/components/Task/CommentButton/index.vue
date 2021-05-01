<template>
  <nuxt-link
    :to="{
      name: 'Task',
      params: {
        username: user.username,
        task: task.uuid
      }
    }"
    type="button"
    class="comment-button relative h-8 w-8 border border-solid border-gray-400 hover:bg-gray-200 rounded-full"
  >
    <div class="flex items-center justify-center h-full">
      <img
        src="@/assets/img/icons/comment.svg"
        alt=""
        class="select-none"
      >
      <div
        v-if="task.commentsCount > 0"
        v-text="task.commentsCount"
        class="comment-button__badge absolute flex items-center justify-center bg-blue-500 text-white rounded-full w-5 h-5 text-xs"
      />
    </div>
  </nuxt-link>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { Task } from '~/types/task'
  import { User } from '~/types/user'

  export default defineComponent({
    props: {
      task: {
        type: Object as () => Task,
        required: true
      },
      user: {
        type: Object as () => User,
        required: true
      }
    }
  })
</script>

<style scoped>
  .comment-button__badge {
    bottom: -6px;
    right: -6px;
  }
</style>
