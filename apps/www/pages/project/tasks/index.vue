<template>
  <div v-infinite-scroll="loadMore">
    <h2 class="font-medium text-2xl mb-4">
      Feed
    </h2>

    <template
      v-if="filteredTaskGroups.data.length"
    >
      <DateGroupedTaskGroups
        :task-groups="filteredTaskGroups.data"
      />
    </template>
    <template
      v-else
    >
      <p
        v-text="$trans('project.paragraphs.no_tasks')"
      />
    </template>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { TaskGroup } from '~/types/taskGroup'
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'
  import { PaginateResponse } from '~/types/pagination'

  export default defineComponent({
    components: {
      DateGroupedTaskGroups
    },
    data () {
      return {
        taskGroups: null
      } as {
        taskGroups: PaginateResponse<TaskGroup>|null
      }
    },
    async asyncData ({ $axios, route }) {
      const { slug } = route.params
      const [taskGroups] = await Promise.all([
        $axios.$get(`/projects/${slug}/task_groups`),
      ])

      console.log('data?', taskGroups)

      return {
        taskGroups
      }
    },
    computed: {
      /**
       * Returns a filtered version of the task groups
       * excluding the tasks that do not belong to this project.
       */
      filteredTaskGroups () {
        return {
          ...this.taskGroups,
          data: this.taskGroups.data.map(taskGroup => ({
            ...taskGroup,
            tasks: taskGroup.tasks
              .filter(task => task.projects
                .map(project => project.slug)
                .includes(this.$route.params.slug)
              )
          }))
        }
      }
    },
    methods: {
      loadMore () {
        if (this.taskGroups.meta.current_page + 1 > this.taskGroups.meta.total_pages) return

        const { slug } = this.$route.params
        this.$axios.$get(`/projects/${slug}/task_groups`, {
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
