<template>
  <main>
    <HomeHero />
    <div class="links-container">
      <div class="container mx-auto flex items-start">
        <SideNavigation />
        <section class="flex flex-col bg-white dark:bg-gray-700 dark:text-white rounded-lg w-full md:w-9/12 p-6">
          <h2 class="font-medium text-2xl mb-4">
            Liens
          </h2>

          <NewLink
            v-if="$accessor.isAuthenticated"
            class="mb-8"
          />

          <apollo-query
            :query="allLinks"
          >
            <template v-slot="{ result: { loading, error, data }, query }">
              <template
                v-if="loading"
              >
                Loading...
              </template>
              <template
                v-else-if="error"
              >
                Error: {{ error }}
              </template>
              <template
                v-else
              >
                <Link
                  v-for="link in data.allLinks.nodes"
                  :key="link.uuid"
                  :link="link"
                  class="mb-4"
                />

                <button
                  v-if="data.allLinks && data.allLinks.pageInfo.hasNextPage"
                  key="load-more"
                  class="btn btn-primary w-full"
                  @click="loadMore(query, data.allLinks.pageInfo.endCursor)"
                >
                  Charger plus de liens
                </button>
              </template>
            </template>
          </apollo-query>
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import allLinks from '~/apollo/queries/allLinks'

  import Link from '@/components/Links/Link/index.vue'
  import SideNavigation from '@/components/Home/SideNavigation/index.vue'
  import HomeHero from '@/components/Home/HomeHero/index.vue'
  import NewLink from '@/components/Links/NewLink/index.vue'

  export default defineComponent({
    components: {
      HomeHero,
      Link,
      SideNavigation,
      NewLink
    },
    setup () {
      // @ts-ignore
      async function loadMore (query, cursor: string) {
        await query.fetchMore({
          variables: {
            cursor
          },
          // @ts-ignore
          updateQuery: (prev, { fetchMoreResult }) => {
            if (!fetchMoreResult || fetchMoreResult.allLinks.nodes.length === 0) {
              return prev
            }

            /**
             * Here we take the current "allLinks" data and append our new fetched
             * data. Keep the pageInfo from the last fetch.
             */
            return Object.assign({}, prev, {
              allLinks: {
                ...prev.allLinks,
                nodes: [
                  ...prev.allLinks.nodes,
                  ...fetchMoreResult.allLinks.nodes
                ],
                pageInfo: fetchMoreResult.allLinks.pageInfo
              }
            })
          }
        })
      }

      return {
        allLinks,
        loadMore
      }
    }
  })
</script>

<style scoped>
  .links-container {
    margin-top: -100px;
  }

  @screen md {
    .links-container {
      margin-top: -180px;
    }
  }
</style>
