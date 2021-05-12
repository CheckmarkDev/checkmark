<template>
  <main v-infinite-scroll="loadMore">
    <div class="home-hero">
      <div class="container mx-auto">
        <div class="flex flex-col md:flex-row md:items-center justify-between py-8">
          <div class="md:w-1/2">
            <h1
              class="text-3xl text-white leading-tight mb-4"
              v-text="$trans('home.titles.main')"
            />
            <h2
              class="text-xl text-gray-300"
              v-text="$trans('home.titles.subtitle')"
            />
          </div>
          <div
            v-if="!$accessor.isAuthenticated"
          >
            <nuxt-link
              :to="{
                name: 'SignUp'
              }"
              class="inline-block mt-4 md:mt-0 bg-white rounded text-blue-500 p-4 font-medium text-base hover:bg-gray-200 hover:shadow-sm"
            >
              {{ $trans('home.buttons.join') }}
            </nuxt-link>
          </div>
        </div>
      </div>
    </div>
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

          <DateGroupedTaskGroups
            :task-groups="$accessor.getTaskGroups"
            class="mb-8"
          />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'
  import NewTask from '@/components/NewTask/index.vue'
  import SideNavigation from '@/components/Home/SideNavigation/index.vue'

  export default defineComponent({
    components: {
      SideNavigation,
      DateGroupedTaskGroups,
      NewTask
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
    async middleware ({ store }) {
      await store.dispatch('retrieveTaskGroups')
    },
    mounted () {
      this.$mitt.on('update-tasks', this.updateTasks)
    },
    beforeDestroy () {
      this.$mitt.off('update-tasks', this.updateTasks)
    },
    methods: {
      updateTasks () {
        this.$accessor.retrieveTaskGroups()
      },
      loadMore () {
        this.$accessor.retrieveMoreTaskGroups()
      }
    }
  })
</script>

<style scoped>
  .home-hero {
    min-height: 320px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
    padding-bottom: 100px;

    @screen md {
      min-height: 400px;
    }
  }

  .home-container {
    margin-top: -100px;

    @screen md {
      margin-top: -180px;
    }
  }
</style>
