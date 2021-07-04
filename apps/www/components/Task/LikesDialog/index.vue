<template>
  <div class="flex fixed top-0 left-0 w-full h-full bg-gray-800 bg-opacity-50 z-20">
    <div class="likes-dialog__content w-full bg-white dark:bg-gray-700 dark:text-white m-auto p-4 md:p-8">
      <div class="flex items-center justify-between mb-8">
        <h1 class="font-medium text-xl">
          {{ $trans('global.titles.reactions') }}
        </h1>
        <button
          type="button"
          @click="$emit('close')"
        >
          <XIcon
            size="24"
          />
        </button>
      </div>
      <div>
        <apollo-query
          :query="allLikes"
          :variables="{
            taskUuid: task.uuid
          }"
        >
          <template
            v-slot="{ result: { data, loading, error } }"
          >
            <template
              v-if="loading"
            >
              Loading
            </template>
            <template
              v-else-if="error"
            >
              Error
            </template>
            <template
              v-else-if="data && data.all_likes.nodes.length > 0"
            >
              <div
                v-for="like in data.all_likes.nodes"
                :key="like.uuid"
                class="mb-8"
              >
                <nuxt-link
                  :to="{
                    name: 'User',
                    params: {
                      username: like.user.username
                    }
                  }"
                >
                  <UserCard
                    :user="like.user"
                  />
                </nuxt-link>
              </div>
            </template>
            <template
              v-else
            >
              <p>
                {{ $trans('global.paragraphs.no_reactions') }}
              </p>
            </template>
          </template>
        </apollo-query>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { XIcon } from 'vue-feather-icons'
  import { Task } from '~/types/task'
  import UserCard from '@/components/UserCard/index.vue'
  import allLikesQuery from '@/apollo/queries/allLikes.gql'

  export default defineComponent({
    components: {
      XIcon,
      UserCard
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup () {
      return {
        allLikes: allLikesQuery
      }
    }
  })
</script>

<style scoped>
  .likes-dialog__content {
    max-width: 480px;
  }
</style>
