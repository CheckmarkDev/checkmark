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
        <nav class="bg-white hidden md:flex rounded-lg w-3/12 mr-8 p-4">
          <ul class="w-full">
            <li class="mb-1">
              <a href="https://discord.gg/VM3rH2X68P" target="_blank" rel="noopener" class="hover:bg-gray-200 rounded p-2 w-full flex">
                Discord
              </a>
            </li>
            <li class="mb-1">
              <a href="https://www.twitter.com/checkmarkdev" target="_blank" rel="noopener" class="hover:bg-gray-200 rounded p-2 w-full flex">
                Twitter
              </a>
            </li>
            <li class="mb-1">
              <a href="https://www.changelog.xyz/checkmark" target="_blank" rel="noopener" class="hover:bg-gray-200 rounded p-2 w-full flex">
                Changelog
              </a>
            </li>
          </ul>
        </nav>
        <section class="bg-white rounded-lg w-full md:w-9/12 p-6">
          <h2 class="font-medium text-2xl mb-4">
            Feed
          </h2>
          <!-- <h3 class="text-xl font-medium mb-4">
            Aujourd'hui
          </h3> -->

          <NewTask
            v-if="$accessor.isAuthenticated"
            class="mb-8"
          />

          <DateGroupedTaskGroups
            :task-groups="$accessor.getTaskGroups"
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

  export default defineComponent({
    components: {
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
    height: 400px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
  }

  .home-container {
    margin-top: -180px;
  }

  @media only screen and (max-width: 720px) {
    .home-container {
      margin-top: -100px;
    }
  }
</style>
