<template>
  <div class="hidden md:flex md:flex-col w-3/12 mr-8">
    <nav class="bg-white dark:bg-gray-700 rounded-lg p-4 mb-4">
      <ul class="w-full">
        <li class="mb-1">
          <nuxt-link
            :to="{
              name: 'ProjectTasks',
              params: {
                slug: $route.params.slug
              }
            }"
            :exact-active-class="'router-link-active bg-gray-200 dark:bg-gray-600 dark:text-white'"
            class="hover:bg-gray-200 dark:hover:bg-gray-600 dark:text-white rounded p-2 w-full flex mb-1"
          >
            Feed
          </nuxt-link>
        </li>
        <li
          v-if="$accessor.isAuthenticated && $accessor.getAuthProjects.map(p => p.slug).includes($route.params.slug)"
          class="mb-1"
        >
          <nuxt-link
            :to="{
              name: 'ProjectSettings',
              params: {
                slug: $route.params.slug
              }
            }"
            :exact-active-class="'router-link-active bg-gray-200 dark:bg-gray-600 dark:text-white'"
            class="hover:bg-gray-200 dark:hover:bg-gray-600 dark:text-white rounded p-2 w-full flex mb-1"
          >
            {{ $trans('project.titles.settings') }}
          </nuxt-link>
        </li>
      </ul>
    </nav>
  </div>
</template>
