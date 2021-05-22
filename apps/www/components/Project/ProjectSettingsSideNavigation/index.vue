<template>
  <AppSideNavigation
    :items="items"
  />
</template>

<script>
  import { defineComponent, readonly, useRoute } from '@nuxtjs/composition-api'

  import useICU from '~/composables/useICU'
  import AppSideNavigation from '@/components/AppSideNavigation/index.vue'

  export default defineComponent({
    components: {
      AppSideNavigation
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
        }
      ])

      return {
        items
      }
    }
  })
</script>
