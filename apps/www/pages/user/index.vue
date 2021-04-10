<template>
  <main v-infinite-scroll="loadMore">
    <div class="home-hero">
      <div class="container mx-auto">
        <div class="flex items-center justify-between py-8">
          <div
            v-if="user"
            class="w-1/2"
          >
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
        <section class="bg-white w-full h-56 rounded-lg p-6">
          <h2 class="font-medium text-2xl mb-4">
            Feed
          </h2>

          <Task
            v-for="task in tasks.data"
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
  import { Task } from '~/types/task'
  import { User } from '~/types/user'

  export default defineComponent({
    data () {
      return {
        user: null,
        tasks: {
          data: [],
          meta: null
        }
      } as {
        user: User | null,
        tasks: {
          data: Array<Task>,
          meta: any
        }
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
          { hid: 'description', name: 'description', content: description }
        ]
      }
    },
    async asyncData ({ $axios, route }) {
      const { username } = route.params
      const [user, tasks] = await Promise.all([
        $axios.$get(`/users/${username}`),
        $axios.$get(`/users/${username}/tasks`)
      ])

      return {
        user,
        tasks
      }
    },
    methods: {
      loadMore () {
        if (this.tasks.meta.current_page + 1 > this.tasks.meta.total_pages) return

        const { username } = this.$route.params
        this.$axios.$get(`/users/${username}/tasks`, {
          params: {
            page: this.tasks.meta.current_page + 1
          }
        })
          .then(res => {
            this.tasks.data = [
              ...this.tasks.data,
              ...res.data
            ]
            this.tasks.meta = res.meta
          })
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
