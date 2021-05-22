<template>
  <div class="w-full md:flex md:flex-col md:w-3/12 mr-8">
    <nav class="bg-white dark:bg-gray-700 rounded-lg p-4 mb-4">
      <ul class="flex md:flex-col">
        <li
          v-for="(item, k) in items"
          :key="k"
          class="md:mb-1 mr-2 md:mr-0"
        >
          <nuxt-link
            :to="item.to"
            :exact-active-class="'router-link-active bg-gray-200 dark:bg-gray-600 dark:text-white'"
            class="hover:bg-gray-200 dark:hover:bg-gray-600 dark:text-white rounded p-2 w-full flex "
            v-text="item.name"
          />
        </li>
      </ul>
    </nav>
  </div>
</template>

<script>
  import { defineComponent, readonly, useRoute } from '@nuxtjs/composition-api'
  import useICU from '~/composables/useICU'

  export default defineComponent({
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

