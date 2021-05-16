<template>
  <div class="task-images flex flex-col md:flex-row">
    <AppLightbox
      v-for="(image, k) in task.images"
      :key="k"
      :thumbnail="image.thumbnailUrl"
      :images="task.images.map(v => v.url).sort(v => v === image.url ? -1 : 0)"
      class="md:w-1/3"
    />
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { Task } from '~/types/task'

  import AppLightbox from '@/components/AppLightbox/index.vue'

  export default defineComponent({
    components: {
      AppLightbox
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    }
  })
</script>

<style scoped>
  .task-images .app-lightbox:not(:last-child) {
    @apply mb-4;
    @apply md:mr-4 md:mb-0;
  }
</style>
