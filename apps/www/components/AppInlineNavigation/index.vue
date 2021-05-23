<template>
  <div class="app-inline-navigation w-full">
    <nav class="bg-white dark:bg-gray-700 rounded-lg p-4 mb-4">
      <ul class="flex">
        <li
          v-for="(item, k) in items"
          :key="k"
          class="mr-2"
        >
          <nuxt-link
            :to="item.to"
            :active-class="item.to.name !== 'ProjectTasks' ? 'router-link-active bg-gray-200 dark:bg-gray-600 dark:text-white' : null"
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
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    props: {
      items: {
        type: Array,
        required: true
      }
    }
  })
</script>
