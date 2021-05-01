<template>
  <div v-infinite-scroll="loadMore">
    <div class="border border-gray-300 rounded mb-8 px-8 py-4">
      <Task
        :task="task"
        :user="user"
      />
    </div>

    <TaskComments
      :task="task"
    />
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { defineComponent, useRoute } from '@nuxtjs/composition-api'
  import { useQuery, useResult } from '@vue/apollo-composable/dist'
  import gql from 'graphql-tag'

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
    setup () {
      const route = useRoute()
      const { task: uuid, username } = route.value.params
      const { result } = useQuery(gql`
        query {
          task (uuid: "${uuid}") {
            uuid
            content
            state
            user {
              uuid
              fullName
              username
            }
          }
          user (username: "${username}") {
            uuid
            fullName
            username
            streak
            avatarUrl
          }
        }
      `)

      const task = useResult(result, null, data => data.task)
      const user = useResult(result, null, data => data.user)

      return {
        task,
        user
      }
    },
    // head () {
    //   const user = this.user as any
    //   const task = this.task as any
    //   const fullName = user.fullName.trim()
    //   const description = this.$trans('user.paragraphs.description', {
    //     user: fullName || user.username
    //   })

    //   const og = this.$socialsplash.generate('fae08fcc-d0e8-4264-a90c-47d78b9b7680', {
    //     subtitle: `${fullName} - ${dayjs(task.created_at).format('LLL')}`,
    //     title: task.content,
    //   })

    //   return {
    //     title: task.content,
    //     meta: [
    //       { hid: 'description', name: 'description', content: description },
    //       { hid: 'og:description', property: 'og:description', content: description },
    //       { hid: 'og:title', property: 'og:title', content: task.content },
    //       { hid: 'twitter:image', property: 'twitter:image', content: og },
    //       { hid: 'og:image:url', property: 'og:image:url', content: og },
    //       {
    //         hid: 'og:image:width', name: 'og:image:width', content: '1200'
    //       },
    //       {
    //         hid: 'og:image:height', name: 'og:image:height', content: '628'
    //       },
    //       {
    //         hid: 'og:image:type', name: 'og:image:type', content: 'image/png'
    //       }
    //     ]
    //   }
    // },
    // validate ({ route }) {
    //   const { username, task } = route.params
    //   return !!username && !!task
    // },
    // async asyncData ({ $axios, route }) {
    //   const { username, task: taskUuid } = route.params
    //   const [user, task, comments] = await Promise.all([
    //     $axios.$get(`/users/${username}`),
    //     $axios.$get(`/users/${username}/tasks/${taskUuid}`),
    //     $axios.$get(`/tasks/${taskUuid}/comments`),
    //   ])

    //   return {
    //     user,
    //     task,
    //     comments
    //   }
    // },
    mounted () {
      this.$mitt.on('new-comment', this.loadComments)
    },
    beforeDestroy () {
      this.$mitt.off('new-comment', this.loadComments)
    },
    methods: {
      loadComments () {
        // const { task: taskUuid } = this.$route.params
        // console.log('uuid', taskUuid)
        // return this.$axios.$get(`/tasks/${taskUuid}/comments`)
        //   .then((res) => {
        //     this.comments = res
        //   })
      },
      loadMore () {
        // const { task: taskUuid } = this.$route.params
        // const meta = this.comments.meta as PaginateResponseMeta
        // if (!meta) return
        // if (meta.current_page + 1 > meta.total_pages) return

        // return (this.$axios as NuxtAxiosInstance).$get(`/tasks/${taskUuid}/comments`, {
        //   params: {
        //     page: meta.current_page + 1
        //   }
        // })
        //   .then((res: PaginateResponse<Comment>) => {
        //     this.comments.data = [
        //       ...this.comments.data,
        //       ...res.data
        //     ]
        //     this.comments.meta = res.meta

        //     return res
        //   })
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
