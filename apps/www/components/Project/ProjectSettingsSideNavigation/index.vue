<template>
  <AppInlineNavigation
    :items="items"
  />
</template>

<script>
  import { defineComponent, readonly, useRoute } from '@nuxtjs/composition-api'

  import useICU from '~/composables/useICU'
  import AppInlineNavigation from '@/components/AppInlineNavigation/index.vue'

  export default defineComponent({
    components: {
      AppInlineNavigation
    },
    setup () {
      const route = useRoute()
      const trans = useICU()

      const { slug } = route.value.params

      const items = readonly([
        {
          to: {
            name: 'ProjectSettingsInformations',
            params: {
              slug
            }
          },
          name: trans('project.titles.informations')
        },
        {
          to: {
            name: 'ProjectSettingsImages',
            params: {
              slug
            }
          },
          name: trans('project.titles.images')
        },
        {
          to: {
            name: 'ProjectSettingsWebhooks',
            params: {
              slug
            }
          },
          name: trans('project.titles.webhooks')
        },
        {
          to: {
            name: 'ProjectSettingsIntegrations',
            params: {
              slug
            }
          },
          name: trans('project.titles.integrations')
        }
      ])

      return {
        items
      }
    }
  })
</script>
