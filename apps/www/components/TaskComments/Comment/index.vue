<template>
  <div>
    <div class="flex justify-between mb-2">
      <nuxt-link
        :to="{
          name: 'User',
          params: {
            username: comment.user.username
          }
        }"
        class="dark:text-white"
      >
        <UserCard
          :user="comment.user"
          class="mb-2"
        />
      </nuxt-link>
      <div
        v-text="date"
        class="text-gray-600 dark:text-gray-400 text-sm self-end mb-2"
      />
    </div>
    <div class="rounded bg-gray-200 dark:bg-gray-600 dark:text-white p-4">
      <p
        class="mb-0"
        v-text="comment.content"
      />
    </div>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

  import { Comment } from '@/types/comment'
  import UserCard from '@/components/UserCard/index.vue'

  export default defineComponent({
    components: {
      UserCard
    },
    props: {
      comment: {
        type: Object as () => Comment,
        required: true
      }
    },
    setup (props) {
      const { comment } = toRefs(props)
      const date = computed(() => dayjs(comment.value.createdAt).format('LLL'))

      return {
        date
      }
    },
  })
</script>
