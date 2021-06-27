<template>
  <article
    class="rounded border border-gray-300 p-3 dark:border-gray-600"
  >
    <a
      :href="link.url"
      :title="link.title"
      rel="noopener nofollow"
      target="_blank"
      class="flex flex-col mb-2"
    >
      <div
        v-text="link.title"
        class="text-blue-500 dark:text-blue-400 dark:underline font-medium text-lg hover:underline"
      />
      <div
        v-text="link.url"
        class="text-base text-gray-700 dark:text-gray-300"
      />
    </a>
    <div class="flex items-center text-sm text-gray-500 dark:text-gray-500">
      <nuxt-link
        :to="{
          name: 'User',
          params: {
            username: link.user.username
          }
        }"
        class="flex items-center mr-3"
      >
        <AppAvatar
          :src="link.user.avatarUrl"
          :alt="link.user.username"
          width="20"
          height="20"
          class="mr-2"
        />
        <div
          v-text="`@${link.user.username}`"
        />
      </nuxt-link>
      <time
        :datetime="link.createdAt"
        v-text="date"
      />
    </div>
  </article>
</template>

<script lang="ts">
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'
  import dayjs from 'dayjs'

  import AppAvatar from '@/components/AppAvatar/index.vue'

  export default defineComponent({
    components: {
      AppAvatar
    },
    props: {
      link: {
        type: Object,
        required: true
      }
    },
    setup (props) {
      const { link } = toRefs(props)
      const date = computed(() => dayjs(link.value.createdAt).format('lll'))

      return {
        date
      }
    }
  })
</script>
