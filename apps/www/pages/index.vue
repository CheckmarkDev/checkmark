<template>
  <main>
    <div class="home-hero">
      <div class="container mx-auto">
        <div class="flex items-center justify-between py-8">
          <div class="w-1/2">
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
            >
              {{ $trans('home.buttons.join') }}
            </nuxt-link>
          </div>
        </div>
      </div>
    </div>
    <div class="home-container">
      <div class="container mx-auto flex items-start">
        <nav class="bg-white rounded-lg w-3/12 mr-8 p-4">
          azeaze
        </nav>
        <section class="bg-white rounded-lg w-9/12 p-6">
          <h2 class="font-medium text-2xl">
            Feed
          </h2>
          <h3>
            Aujourd'hui
          </h3>

          <Task
            v-for="task in tasks"
            :key="task.uuid"
            :task="task"
            class="mb-4"
          />

          <pre>
            {{ tasks }}
          </pre>
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import Task from '@/components/Task/index.vue'

  export default {
    components: {
      Task
    },
    data () {
      return {
        tasks: []
      }
    },
    async asyncData ({ $axios }) {
      const res = await $axios.$get('/tasks')

      return {
        tasks: res.data
      }
    }
  }
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
