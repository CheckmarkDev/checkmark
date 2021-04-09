<template>
  <main>
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
          <div>
            <nuxt-link
              :to="{
                path: '/'
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
            <li>
              <a href="https://www.changelog.xyz/checkmark" class="hover:bg-gray-200 rounded p-2 w-full flex">
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

          <Task
            v-for="task in $accessor.getTasks"
            :key="task.uuid"
            :task="task"
            class="mb-4"
          />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import Task from '@/components/Task/index.vue'
  import NewTask from '@/components/NewTask/index.vue'

  export default defineComponent({
    components: {
      Task,
      NewTask
    },
    async middleware ({ store }) {
      await store.dispatch('retrieveTasks')
    },
    mounted () {
      this.$mitt.on('update-tasks', this.updateTasks)
    },
    beforeDestroy () {
      this.$mitt.off('update-tasks', this.updateTasks)
    },
    methods: {
      updateTasks () {
        this.$accessor.retrieveTasks()
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
