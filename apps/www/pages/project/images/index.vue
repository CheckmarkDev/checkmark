<template>
  <div
    class="flex flex-col"
  >
    <h2 class="font-medium text-2xl mb-4">
      {{ $trans('project.titles.images') }}
    </h2>

    <template
      v-if="$accessor.project.getProject.screenshots.length"
    >
      <div class="-m-2 flex flex-wrap">
        <AppLightbox
          v-for="image in $accessor.project.getProject.screenshots"
          :key="image.uuid"
          :thumbnail="image.thumbnail_url"
          :images="$accessor.project.getProject.screenshots.map(v => v.url).sort(v => v === image.url ? -1 : 0)"
          class="m-2"
        />
      </div>
    </template>
    <template
      v-else
    >
      <p
        v-text="$trans('project.paragraphs.no_screenshots')"
      />
    </template>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import AppLightbox from '@/components/AppLightbox/index.vue'

  export default defineComponent({
    components: {
      AppLightbox
    }
  })
</script>

<style scoped>
  .app-lightbox {
    flex: 1 0 calc(31% - 1rem);
  }
</style>
