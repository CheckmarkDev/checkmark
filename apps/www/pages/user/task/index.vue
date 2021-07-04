<template>
  <div
    class=""
  >
    <div class="border border-gray-300 dark:border-gray-600 rounded mb-8 px-8 py-4">
      <Task
        :task="task"
      />
    </div>

    <TaskComments
      :task="task"
    />
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
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
        task: null
      } as {
        user: User | null,
        task: Task | null
      }
    },
    head () {
      const user = this.user as any
      const task = this.task as any
      const fullName = `${user.first_name} ${user.last_name}`.trim()
      const description = this.$trans('user.paragraphs.description', {
        user: fullName || user.username
      })

      const og = this.$socialsplash.generate('fae08fcc-d0e8-4264-a90c-47d78b9b7680', {
        subtitle: `${fullName} - ${dayjs(task.created_at).format('LLL')}`,
        title: task.content,
      })

      return {
        title: task.content,
        meta: [
          { hid: 'description', name: 'description', content: description },
          { hid: 'og:description', property: 'og:description', content: description },
          { hid: 'og:title', property: 'og:title', content: task.content },
          { hid: 'twitter:image', property: 'twitter:image', content: og },
          { hid: 'og:image:url', property: 'og:image:url', content: og },
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
        task,
      }
    },
    mounted () {
      this.$mitt.on('update-task', (task) => {
        this.task = task
      })
    },
    beforeDestroy () {
      this.$mitt.off('update-task')
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
