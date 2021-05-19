<template>
  <div class="border border-gray-300 dark:border-gray-600 border-solid rounded p-8">
    <h2 class="font-medium text-lg text-gray-800 dark:text-gray-300 mb-8">
      {{ $trans('user.titles.comments') }}
    </h2>

    <!-- <NewCommentForm
      v-if="$accessor.getAuthUser"
      :task="task"
      class="mb-12"
    /> -->

    <div
      v-if="allComments.length"
      class="border-t border-gray-300 dark:border-gray-600 pt-6"
    >
      <Comment
        v-for="comment in allComments"
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
  </div>
</template>

<script lang="ts">
  import { defineComponent, toRefs, useRoute } from '@nuxtjs/composition-api'
  import { useQuery, useResult } from '@vue/apollo-composable/dist'
  import gql from 'graphql-tag'

  import { Comment } from '~/types/comment'

  import { PaginateResponse } from '~/types/pagination'
  import { Task } from '~/types/task'
  import CommentComponent from './Comment/index.vue'

  import NewCommentForm from './NewCommentForm/index.vue'

  export default defineComponent({
    components: {
      Comment: CommentComponent,
      NewCommentForm
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)
      const { result } = useQuery(gql`
        query {
          allComments (taskUuid: "${task.value.uuid}") {
            uuid
            content
            createdAt
            user {
              uuid
              username
              fullName
              avatarUrl
              streak
            }
          }
        }
      `)

      const allComments = useResult(result, [], data => data.allComments)

      return {
        allComments
      }
    }
  })
</script>
