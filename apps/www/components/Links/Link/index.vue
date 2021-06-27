<template>
  <div
    class="rounded border border-gray-300 p-3 dark:border-gray-600"
  >
    <a
      :href="link.url"
      :title="link.title"
      rel="noopener nofollow"
      target="_blank"
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
    <div class="text-sm text-gray-500 dark:text-gray-500">
      {{ date }}
    </div>
  </div>
</template>

<script lang="ts">
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'
  import dayjs from 'dayjs'

  export default defineComponent({
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
