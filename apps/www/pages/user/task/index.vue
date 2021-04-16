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
        <section class="bg-white w-full md:w-9/12 h-56 rounded-lg p-6">
          <div class="border border-gray-300 rounded mb-8 px-8 py-4">
            <Task
              :task="task"
            />
          </div>

          <TaskComments
            :comments="comments"
          />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { NuxtAxiosInstance } from '@nuxtjs/axios'

  import TaskComponent from '@/components/Task/index.vue'
  import TaskComments from '@/components/TaskComments/index.vue'
  import { PaginateResponse, PaginateResponseMeta } from '~/types/pagination'
  import { User } from '~/types/user'
  import { Comment } from '~/types/comment'
  import { Task } from '~/types/task'

  export default defineComponent({
    components: {
      Task: TaskComponent,
      TaskComments
    },
    data () {
      return {
        user: null,
        task: null,
        comments: {
          data: [],
          meta: {}
        }
      } as {
        user: User | null,
        task: Task | null,
        comments: {
          data: Array<Comment>,
          meta: any
        }
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
      const [user, task, comments] = await Promise.all([
        $axios.$get(`/users/${username}`),
        $axios.$get(`/users/${username}/tasks/${taskUuid}`),
        $axios.$get(`/tasks/${taskUuid}/comments`),
      ])

      return {
        user,
        task,
        comments
      }
    },
    methods: {
      loadMore () {
        const { task: taskUuid } = this.$route.params
        const meta = this.comments.meta as PaginateResponseMeta
        if (!meta) return
        if (meta.current_page + 1 > meta.total_pages) return

        return (this.$axios as NuxtAxiosInstance).$get(`/tasks/${taskUuid}/comments`, {
          params: {
            page: meta.current_page + 1
          }
        })
          .then((res: PaginateResponse<Comment>) => {
            this.comments.data = [
              ...this.comments.data,
              ...res.data
            ]
            this.comments.meta = res.meta

            return res
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
