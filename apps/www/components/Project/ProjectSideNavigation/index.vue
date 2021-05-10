<template>
  <div class="hidden md:flex md:flex-col w-3/12 mr-8">
    <nav class="bg-white rounded-lg p-4 mb-4">
      <ul class="w-full">
        <li class="mb-1">
          <nuxt-link
            :to="{
              name: 'ProjectTasks',
              params: {
                slug: $route.params.slug
              }
            }"
            :exact-active-class="'router-link-active bg-gray-200'"
            class="hover:bg-gray-200 rounded p-2 w-full flex mb-1"
          >
            Feed
          </nuxt-link>
        </li>
      </ul>
    </nav>
  </div>
</template>
