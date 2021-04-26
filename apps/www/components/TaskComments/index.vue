<template>
  <div class="border border-gray-300 border-solid rounded p-8">
    <h2 class="font-medium text-lg text-gray-800 mb-8">
      {{ $trans('user.titles.comments') }}
    </h2>

    <NewCommentForm
      v-if="$accessor.getAuthUser"
      :task="task"
      class="mb-12"
    />

    <div
      v-if="comments.data.length"
      class="border-t border-gray-300 pt-6"
    >
      <Comment
        v-for="comment in comments.data"
        :key="comment.uuid"
        :comment="comment"
        class="mb-8"
      />
    </div>
    <template
      v-else
    >
      <p
        v-text="$trans('user.paragraphs.no_comments')"
        class="text-gray-700"
      />
    </template>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import { PaginateResponse } from '~/types/pagination'
  import { Task } from '~/types/task'
  import Comment from './Comment/index.vue'

  import NewCommentForm from './NewCommentForm/index.vue'

  export default defineComponent({
    components: {
      Comment,
      NewCommentForm
    },
    props: {
      comments: {
        type: Object as () => PaginateResponse<Comment>,
        required: true
      },
      task: {
        type: Object as () => Task,
        required: true
      }
    }
  })
</script>
