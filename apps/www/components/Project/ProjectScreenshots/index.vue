<template>
  <div class="project-screenshots">
    <div class="flex items-center justify-between mb-4">
      <h2 class="font-medium text-2xl mb-4">
        {{ $trans('project.titles.images') }}
      </h2>

      <nuxt-link
        :to="{
          name: 'ProjectImages',
          params: {
            slug: $accessor.project.getProject.slug
          }
        }"
        class="flex items-center p-2"
      >
        <div
          v-text="$trans('project.buttons.view_images', {
            count: $accessor.project.getProject.screenshots.length
          })"
          class="mr-2"
        />
        <ChevronRightIcon />
      </nuxt-link>
    </div>

    <div class="-m-2 flex flex-wrap">
      <AppLightbox
        v-for="image in screenshots"
        :key="image.uuid"
        :thumbnail="image.thumbnail_url"
        :images="screenshots.map(v => v.url).sort(v => v === image.url ? -1 : 0)"
        class="m-2"
      />
    </div>
  </div>
</template>

<script>
  import { computed, defineComponent } from '@nuxtjs/composition-api'

  import AppLightbox from '@/components/AppLightbox/index.vue'
  import useAccessor from '@/composables/useAccessor'
  import { ChevronRightIcon } from 'vue-feather-icons'

  export default defineComponent({
    components: {
      AppLightbox,
      ChevronRightIcon
    },
    setup() {
      const accessor = useAccessor()

      const screenshots = computed(() => accessor.project.getProject.screenshots.slice(0, 3))

      return {
        screenshots
      }
    },
  })
</script>

<style scoped>
  .project-screenshots .app-lightbox {
    flex: 1 0 calc(31% - 1rem);
  }
</style>
