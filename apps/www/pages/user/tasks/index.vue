<template>
  <div>
    <apollo-query
      :query="allTaskGroups"
      :variables="{
        username: $route.params.username,
        state: $accessor.project.getFilters.state
      }"
    >
      <template
        v-slot="{ result: { data, loading }, query, isLoading }"
      >
        <div
          class="flex flex-col dark:text-white"
        >
          <div class="flex items-center justify-between">
            <h2 class="font-medium text-2xl mb-4">
              {{ $trans('global.titles.feed') }}
            </h2>

            <TaskGroupFilter />
          </div>

          <template
            v-if="data"
          >
            <DateGroupedTaskGroups
              :task-groups="data.all_user_task_groups.nodes"
              class="mb-8"
            />

            <button
              v-if="data.all_user_task_groups.pageInfo.hasNextPage"
              :disabled="!!(loading || isLoading)"
              type="button"
              class="btn btn-primary"
              @click="loadMore(query, data, !!(loading || isLoading))"
            >
              Charger plus...
            </button>
          </template>
        </div>
      </template>
    </apollo-query>
  </div>
</template>

<script lang="ts">
  import { defineComponent, useRoute } from '@nuxtjs/composition-api'
  import gql from 'graphql-tag'
  import { UseQueryReturn } from '@vue/apollo-composable/dist'

  import { User } from '~/types/user'
  import TaskGroupFilter from '@/components/TaskGroupFilter/index.vue'
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'

  // @ts-ignore
  import user from '@/apollo/fragments/user.gql'
  // @ts-ignore
  import task from '@/apollo/fragments/task.gql'
  import useAccessor from '@/composables/useAccessor'

  export default defineComponent({
    components: {
      DateGroupedTaskGroups,
      TaskGroupFilter
    },
    data () {
      return {
        user: null
      } as {
        user: User | null
      }
    },
    head () {
      const user = this.user as any
      const fullName = `${user.first_name} ${user.last_name}`.trim()
      const description = this.$trans('user.paragraphs.description', {
        user: fullName || user.username
      })

      return {
        title: fullName || user.username,
        meta: [
          { hid: 'description', name: 'description', content: description },
          { hid: 'og:description', property: 'og:description', content: description },
          { hid: 'og:title', property: 'og:title', content: fullName || user.username },
          {
            hid: 'og:image:width', name: 'og:image:width', content: '1200'
          },
          {
            hid: 'og:image:height', name: 'og:image:height', content: '628'
          },
          {
            hid: 'og:image:type', name: 'og:image:type', content: 'image/png'
          }
        ]
      }
    },
    setup () {
      const accessor = useAccessor()
      const allTaskGroups = gql`
        query GetUserAllTaskGroups ($username: String!, $state: String, $after: String) {
          all_user_task_groups (username: $username, state: $state, after: $after) {
            pageInfo {
              hasNextPage
              endCursor
            }
            nodes {
              uuid
              created_at
              updated_at
              user {
                ...user
              }
              tasks (state: $state) {
                ...task
              }
            }
          }
        }

        ${user}
        ${task}
      `

      const route = useRoute()
      const username = route.value.params.username as string

      function loadMore (query: UseQueryReturn<any, {
        username: string,
        endCursor: string
      }>, data: any, loading: boolean) {
        if (loading) return
        if (!data) return

        const { endCursor } = data.all_user_task_groups.pageInfo

        query.fetchMore({
          variables: {
            // @ts-ignore
            after: endCursor,
            username,
            state: accessor.project.getFilters.state
          },
          updateQuery: (previousResult, { fetchMoreResult }) => {
            return fetchMoreResult.all_user_task_groups.nodes.length ? {
              all_user_task_groups: {
                ...fetchMoreResult.all_user_task_groups,
                nodes: [
                  ...previousResult.all_user_task_groups.nodes,
                  ...fetchMoreResult.all_user_task_groups.nodes
                ]
              }
            } : previousResult
          }
        })
      }

      return {
        loadMore,
        allTaskGroups
      }
    },
    async asyncData ({ $axios, route }) {
      const { username } = route.params
      const [user] = await Promise.all([
        $axios.$get(`/users/${username}`),
      ])

      return {
        user,
      }
    }
  })
</script>

<style scoped>
  .home-hero {
    height: 400px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
  }

  .home-container {
    margin-top: -180px;
  }
</style>
