<template>
  <div class="border border-gray-300 border-solid rounded p-8">
    <h2 class="font-medium text-lg text-gray-800 mb-8">
      {{ $trans('user.titles.comments') }}
    </h2>

    <template
      v-if="comments.data.length"
    >
      <Comment
        v-for="comment in comments.data"
        :key="comment.uuid"
        :comment="comment"
        class="mb-8"
      />
    </template>
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
  import Comment from './Comment/index.vue'

  export default defineComponent({
    components: {
      Comment
    },
    props: {
      comments: {
        type: Object as () => PaginateResponse<Comment>,
        required: true
      }
    }
  })
</script>
