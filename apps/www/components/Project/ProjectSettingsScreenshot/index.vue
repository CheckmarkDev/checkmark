<template>
  <div class="project-settings-screenshot">
    <AppLightbox
      :thumbnail="screenshot.thumbnail_url"
      :images="[screenshot.url]"
    />
    <div class="flex justify-end border border-gray-300 p-1">
      <button
        :disabled="$wait.is(`deleting screenshot ${screenshot.uuid}`)"
        type="button"
        class="btn btn-danger btn-sm"
        @click="remove"
      >
        {{ $trans('global.buttons.delete') }}
      </button>
    </div>
  </div>
</template>

<script>
  import { defineComponent, toRefs } from '@nuxtjs/composition-api'

  import AppLightbox from '@/components/AppLightbox/index.vue'
  import useICU from '~/composables/useICU'
  import useWait from '~/composables/useWait'
  import useMitt from '~/composables/useMitt'
  import useAxios from '~/composables/useAxios'
  import useAccessor from '~/composables/useAccessor'

  export default defineComponent({
    components: {
      AppLightbox
    },
    props: {
      screenshot: {
        type: Object,
        required: true
      },
      project: {
        type: Object,
        required: true
      }
    },
    setup (props) {
      const { screenshot, project } = toRefs(props)
      const trans = useICU()
      const wait = useWait()
      const mitt = useMitt()
      const axios = useAxios()
      const accessor = useAccessor()

      function remove () {
        const { uuid } = screenshot.value
        const { slug } = project.value

        if (window.confirm(trans('project.paragraphs.screenshot_delete'))) {
          wait.start(`deleting screenshot ${uuid}`)
          axios.delete(`/me/projects/${slug}/screenshots/${uuid}`)
            .then(() => {
              accessor.project.retrieveProject(slug)
            })
            .finally(() => {
              wait.end(`deleting screenshot ${uuid}`)
            })
        }
      }

      return {
        remove
      }
    }
  })
</script>
