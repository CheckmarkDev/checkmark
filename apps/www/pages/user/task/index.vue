<template>
  <main>
    <div class="home-hero">
      <div class="container mx-auto">
        <div class="flex items-center justify-between py-8">
          <div class="w-1/2">
            <h1
              class="text-3xl text-white leading-tight mb-4"
              v-text="`${user.first_name} ${user.last_name}`"
            />
            <h2
              class="text-xl text-gray-300"
              v-text="`@${user.username}`"
            />
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
        <section class="bg-white w-full md:w-9/12 h-56 rounded-lg p-6">
          <task
            :task="task"
          />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import Task from '@/components/Task/index.vue'

  export default defineComponent({
    components: {
      Task
    },
    data () {
      return {
        user: null,
        task: null
      }
    },
    head () {
      const user = this.user as any
      const task = this.task as any
      const fullName = `${user.first_name} ${user.last_name}`.trim()
      const description = this.$trans('user.paragraphs.description', {
        user: fullName || user.username
      })

      return {
        title: task.content,
        meta: [
          { hid: 'description', name: 'description', content: description },
          { hid: 'og:description', property: 'og:description', content: description },
          { hid: 'og:title', property: 'og:title', content: task.content },
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
    validate ({ route }) {
      const { username, task } = route.params
      return !!username && !!task
    },
    async asyncData ({ $axios, route }) {
      const { username, task: taskUuid } = route.params
      const [user, task] = await Promise.all([
        $axios.$get(`/users/${username}`),
        $axios.$get(`/users/${username}/tasks/${taskUuid}`)
      ])

      return {
        user,
        task
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
