<template>
  <div>
    <apollo-query
      :query="allTaskGroups"
      :variables="{
        slug: $route.params.slug,
        state: $accessor.project.getFilters.state
      }"
    >
      <template
        v-slot="{ result: { data, loading }, query, isLoading }"
      >
        <div
          class="flex flex-col"
        >
          <!-- Screenshots -->
          <ProjectScreenshots
            v-if="$accessor.project.getProject.screenshots.length > 0"
            class="mb-8"
          />

          <div class="flex items-center justify-between">
            <h2 class="font-medium text-2xl mb-4">
              {{ $trans('global.titles.feed') }}
            </h2>

            <TaskGroupFilter />
          </div>

          <template
            v-if="data"
          >
            <template v-if="data.all_project_task_groups.nodes.length">
              <DateGroupedTaskGroups
                :task-groups="data.all_project_task_groups.nodes"
                class="mb-8"
              />

              <button
                v-if="data.all_project_task_groups.pageInfo.hasNextPage"
                :disabled="!!(loading || isLoading)"
                type="button"
                class="btn btn-primary"
                @click="loadMore(query, data, !!(loading || isLoading))"
              >
                Charger plus...
              </button>
            </template>
            <template v-else>
              <p
                v-text="$accessor.project.getFilters.state
                  ? $trans('project.paragraphs.no_tasks_filter')
                  : $trans('project.paragraphs.no_tasks')"
              />
            </template>
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
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'
  import ProjectScreenshots from '@/components/Project/ProjectScreenshots/index.vue'
  import TaskGroupFilter from '@/components/TaskGroupFilter/index.vue'

  // @ts-ignore
  import user from '@/apollo/fragments/user.gql'
  import useAccessor from '@/composables/useAccessor'

  export default defineComponent({
    components: {
      TaskGroupFilter,
      DateGroupedTaskGroups,
      ProjectScreenshots
    },
    setup () {
      const accessor = useAccessor()
      const allTaskGroups = gql`
        query GetProjectAllTaskGroups ($slug: String!, $state: String, $after: String) {
          all_project_task_groups (slug: $slug, state: $state, after: $after) {
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
                uuid
                content
                state
                source
                created_at
                updated_at
                user {
                  ...user
                }
                images {
                  uuid
                  url
                  thumbnail_url
                }
                comments {
                  nodes {
                    uuid
                  }
                }
                likes {
                  nodes {
                    uuid
                    user {
                      uuid
                    }
                  }
                }
              }
            }
          }
        }

        ${user}
      `

      const route = useRoute()
      const slug = route.value.params.slug as string

      function loadMore (query: UseQueryReturn<any, {
        slug: string,
        endCursor: string
      }>, data: any, loading: boolean) {
        if (loading) return
        if (!data) return

        const { endCursor } = data.all_project_task_groups.pageInfo

        query.fetchMore({
          variables: {
            // @ts-ignore
            after: endCursor,
            slug,
            state: accessor.project.getFilters.state
          },
          updateQuery: (previousResult, { fetchMoreResult }) => {
            return fetchMoreResult.all_project_task_groups.nodes.length ? {
              all_project_task_groups: {
                ...fetchMoreResult.all_project_task_groups,
                nodes: [
                  ...previousResult.all_project_task_groups.nodes,
                  ...fetchMoreResult.all_project_task_groups.nodes
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
