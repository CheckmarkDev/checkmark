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

          <DateGroupedTaskGroups
            :task-groups="taskGroups.data"
          />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { TaskGroup } from '~/types/taskGroup'
  import { User } from '~/types/user'
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'

  export default defineComponent({
    components: {
      DateGroupedTaskGroups
    },
    data () {
      return {
        user: null,
        taskGroups: {
          data: [],
          meta: null
        }
      } as {
        user: User | null,
        taskGroups: {
          data: Array<TaskGroup>,
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
    async asyncData ({ $axios, route }) {
      const { username } = route.params
      const [user, taskGroups] = await Promise.all([
        $axios.$get(`/users/${username}`),
        $axios.$get(`/users/${username}/task_groups`)
      ])

      return {
        user,
        taskGroups
      }
    },
    methods: {
      loadMore () {
        if (this.taskGroups.meta.current_page + 1 > this.taskGroups.meta.total_pages) return

        const { username } = this.$route.params
        this.$axios.$get(`/users/${username}/task_groups`, {
          params: {
            page: this.taskGroups.meta.current_page + 1
          }
        })
          .then(res => {
            this.taskGroups.data = [
              ...this.taskGroups.data,
              ...res.data
            ]
            this.taskGroups.meta = res.meta
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
