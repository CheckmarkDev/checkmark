<template>
  <main v-infinite-scroll="loadMore">
    <HomeHero />
    <div class="home-container">
      <div class="container mx-auto flex items-start">
        <SideNavigation />
        <section class="flex flex-col bg-white dark:bg-gray-700 dark:text-white rounded-lg w-full md:w-9/12 p-6">
          <h2 class="font-medium text-2xl mb-4">
            Feed
          </h2>

          <NewTask
            v-if="$accessor.isAuthenticated"
            class="mb-8"
          />

          <apollo-query
            :query="allTaskGroups"
          >
            <template
              v-slot="{ result: { data, loading } }"
            >
              <DateGroupedTaskGroups
                v-if="data"
                :task-groups="data.all_task_groups.nodes"
                class="mb-8"
              />
            </template>
          </apollo-query>
          <!-- <DateGroupedTaskGroups
            :task-groups="$accessor.getTaskGroups"
            class="mb-8"
          /> -->
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import gql from 'graphql-tag'

  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'
  import NewTask from '@/components/NewTask/index.vue'
  import SideNavigation from '@/components/Home/SideNavigation/index.vue'
  import HomeHero from '@/components/Home/HomeHero/index.vue'
  import user from '@/apollo/fragments/user.gql'

  export default defineComponent({
    components: {
      SideNavigation,
      DateGroupedTaskGroups,
      NewTask,
      HomeHero
    },
    head () {
      const title = this.$trans('home.titles.title')
      const description = this.$trans('home.paragraphs.description')

      return {
        title: title,
        titleTemplate: 'Checkmark - %s',
        meta: [
          { hid: 'description', name: 'description', content: description },
          { hid: 'og:description', property: 'og:description', content: description },
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    },
    setup () {
      const allTaskGroups = gql`
        query GetAllTaskGroups {
          all_task_groups {
            nodes {
              uuid
              created_at
              updated_at
              user {
                ...user
              }
              tasks {
                uuid
                content
                state
                source
                created_at
                updated_at
                user {
                  ...user
                }
              }
            }
          }
        }

        ${user}
      `

      return {
        allTaskGroups
      }
    },
    // async middleware ({ store }) {
    //   await store.dispatch('retrieveTaskGroups')
    // },
    // mounted () {
    //   this.$mitt.on('update-tasks', this.updateTasks)
    // },
    // beforeDestroy () {
    //   this.$mitt.off('update-tasks', this.updateTasks)
    // },
    methods: {
      // updateTasks () {
      //   this.$accessor.retrieveTaskGroups()
      // },
      loadMore () {
        this.$accessor.retrieveMoreTaskGroups()
      }
    }
  })
</script>

<style scoped>

  .home-container {
    margin-top: -100px;
  }

  @screen md {
    .home-container {
      margin-top: -180px;
    }
  }
</style>
