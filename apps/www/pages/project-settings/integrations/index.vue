<template>
  <div>
    <h2
      v-text="$trans('project.titles.integrations')"
      class="text-2xl dark:text-white font-medium mb-6"
    />

    <div
      class="mb-6"
    >
      <h3
        class="font-medium text-base mb-3"
        v-text="$trans('project.titles.github')"
      />

      <div>
        URL: https://api.checkmark.dev/webhooks/projects/{{ slug }}
      </div>
      <div
        v-if="secret"
      >
        Secret : <AppSecretKey :secret="secret" />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, onMounted, Ref, ref } from '@nuxtjs/composition-api'

  import AppSecretKey from '@/components/AppSecretKey/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import useWait from '~/composables/useWait'
  import { Project } from '~/types/project'
  import useAxios from '~/composables/useAxios'

  export default defineComponent({
    components: {
      AppSecretKey
    },
    setup (props, { refs }) {
      const wait = useWait()
      const accessor = useAccessor()
      const axios = useAxios()

      const { slug } = accessor.project.getProject as Project

      const secret: Ref<string|null> = ref(null)

      function fetchSecret () {
        wait.start('fetching secret')
        axios.$get(`/me/projects/${slug}/github`)
          .then((res) => {
            secret.value = res.secret
          })
          .finally(() => {
            wait.end('fetching secret')
          })
      }

      onMounted(() => {
        fetchSecret()
      })

      return {
        secret,
        slug
      }
    },
    head () {
      const title = this.$trans('project.titles.integrations')

      return {
        title,
        meta: [
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>
