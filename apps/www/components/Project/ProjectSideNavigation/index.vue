<template>
  <AppSideNavigation
    :items="items"
  />
</template>


<script>
  import { defineComponent, ref, useRoute } from '@nuxtjs/composition-api'

  import useICU from '~/composables/useICU'
  import useAccessor from '~/composables/useAccessor'
  import AppSideNavigation from '@/components/AppSideNavigation/index.vue'

  export default defineComponent({
    components: {
      AppSideNavigation
    },
    setup () {
      const route = useRoute()
      const trans = useICU()
      const accessor = useAccessor()

      const { slug } = route.value.params

      const items = ref([
        {
          to: {
            name: 'ProjectTasks',
            params: {
              slug
            }
          },
          name: trans('global.titles.feed')
        },
        {
          to: {
            name: 'ProjectImages',
            params: {
              slug
            }
          },
          name: trans('project.titles.images')
        }
      ])

      const ownsTheProject = accessor.getAuthProjects.map(p => p.slug).includes(slug)
      if (accessor.isAuthenticated && ownsTheProject) {
        items.value.push({
          to: {
            name: 'ProjectSettings',
            params: {
              slug
            }
          },
          name: trans('project.titles.settings')
        })
      }

      return {
        items
      }
    }
  })
</script>
