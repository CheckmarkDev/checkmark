<template>
  <div class="md:flex-col w-full md:w-3/12 mr-8">
    <nav class="bg-white dark:bg-gray-700 rounded-lg p-4 mb-4">
      <!-- Projects -->
      <div
        v-if="user.projects.length || $accessor.isAuthenticated && $accessor.getAuthUser.username === $route.params.username"
      >
        <h2
          v-text="$trans('user.titles.projects')"
          class="font-medium text-lg text-gray-700 dark:text-gray-300 mb-2"
        />
        <template
          v-if="user.projects.length"
        >
          <ul class="mb-8">
            <li
              v-for="project in user.projects"
              :key="project.uuid"
              class="mb-3"
            >
              <nuxt-link
                :to="{
                  name: 'Project',
                  params: {
                    slug: project.slug
                  }
                }"
                class="flex items-center truncate"
              >
                <AppAvatar
                  :src="project.avatar_url"
                  :width="40"
                  :height="40"
                  class="mr-3 flex-shrink-0"
                />
                <div class="flex flex-col truncate">
                  <div
                    v-text="project.name"
                    class="font-medium text-base text-gray-800 dark:text-white truncate"
                  />
                  <div
                    v-if="project.url"
                    v-text="project.url"
                    class="text-sm text-gray-700 dark:text-gray-300 truncate"
                  />
                </div>
              </nuxt-link>
            </li>
          </ul>
        </template>
        <template
          v-else-if="$accessor.isAuthenticated && $accessor.getAuthUser.username === $route.params.username"
        >
          <p
            v-text="$trans('user.paragraphs.no_projects')"
            class="text-gray-700 mb-3"
          />
        </template>

        <nuxt-link
          v-if="$accessor.isAuthenticated && $accessor.getAuthUser.username === $route.params.username"
          :to="{
            name: 'NewProject'
          }"
          class="btn btn-primary mb-6"
          v-text="$trans('user.buttons.add_project')"
        />
      </div>

      <ul
        :class="{
          'mt-2 border-t border-gray-300 dark:border-gray-600 pt-4': user.projects.length || $accessor.isAuthenticated && $accessor.getAuthUser.username === $route.params.username
        }"
        class="w-full"
      >
        <li class="mb-1">
          <nuxt-link
            :to="{
              name: 'User',
              params: {
                username: $route.params.username
              }
            }"
            :exact-active-class="'router-link-active bg-gray-200 dark:bg-gray-600 dark:text-white'"
            class="hover:bg-gray-200 dark:hover:bg-gray-600 dark:text-white rounded p-2 w-full flex mb-1"
          >
            Feed
          </nuxt-link>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script lang="ts">
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'
  import { User } from '~/types/user'
  import AppAvatar from '@/components/AppAvatar/index.vue'
  import useAccessor from '~/composables/useAccessor'

  export default defineComponent({
    components: {
      AppAvatar
    },
    props: {
      user: {
        type: Object as () => User,
        required: true
      }
    }
  })
</script>

