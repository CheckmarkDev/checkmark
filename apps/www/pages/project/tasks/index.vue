<template>
  <div v-infinite-scroll="loadMore">
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { TaskGroup } from '~/types/taskGroup'
  import { Project } from '~/types/project'
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'

  export default defineComponent({
    components: {
      DateGroupedTaskGroups
    },
    data () {
      return {
        project: null
      } as {
        project: Project | null
      }
    },
    head () {
      const project = this.project as any

      return {
        title: project.name,
        meta: [
          { hid: 'description', name: 'description', content: project.description },
          { hid: 'og:description', property: 'og:description', content: project.description },
          { hid: 'og:title', property: 'og:title', content: project.name },
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
      const { slug } = route.params
      const [project] = await Promise.all([
        $axios.$get(`/projects/${slug}`),
      ])

      return {
        project
      }
    },
    methods: {
      loadMore () {
        // if (this.taskGroups.meta.current_page + 1 > this.taskGroups.meta.total_pages) return

        // const { username } = this.$route.params
        // this.$axios.$get(`/users/${username}/task_groups`, {
        //   params: {
        //     page: this.taskGroups.meta.current_page + 1
        //   }
        // })
        //   .then(res => {
        //     this.taskGroups.data = [
        //       ...this.taskGroups.data,
        //       ...res.data
        //     ]
        //     this.taskGroups.meta = res.meta
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
