<template>
  <div class="border border-gray-300 dark:border-gray-600 border-solid rounded p-8">
    <h2 class="font-medium text-lg text-gray-800 dark:text-gray-300 mb-8">
      {{ $trans('user.titles.comments') }}
    </h2>

    <NewCommentForm
      v-if="$accessor.getAuthUser"
      :task="task"
      class="mb-12"
    />

    <apollo-query
      :query="allComments"
      :variables="{
        taskUuid: task.uuid
      }"
    >
      <template
        v-slot="{ result: { data, loading, error } }"
      >
        <template
          v-if="loading"
        >
          Loading
        </template>
        <template
          v-else-if="error"
        >
          Error
        </template>
        <template
          v-else
        >
          <div
            v-if="data && data.all_comments.nodes.length"
            class="border-t border-gray-300 dark:border-gray-600 pt-6"
          >
            <Comment
              v-for="comment in data.all_comments.nodes"
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
              class="text-gray-700 dark:text-gray-300"
            />
          </template>
        </template>
      </template>
    </apollo-query>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import { Task } from '~/types/task'
  import Comment from './Comment/index.vue'
  import allCommentsQuery from '@/apollo/queries/allComments.gql'

  import NewCommentForm from './NewCommentForm/index.vue'

  export default defineComponent({
    components: {
      Comment,
      NewCommentForm
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup () {
      return {
        allComments: allCommentsQuery
      }
    }
  })
</script>
