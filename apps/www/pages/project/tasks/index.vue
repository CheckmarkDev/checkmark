<template>
  <div
    v-infinite-scroll="loadMore"
    class="flex flex-col"
  >
    <!-- Screenshots -->
    <ProjectScreenshots
      v-if="$accessor.project.getProject.screenshots.length > 0"
      class="mb-8"
    />

    <div class="flex items-center justify-between">
      <h2 class="font-medium text-2xl mb-4">
        {{ $trans('global.titles.feed') }}
      </h2>

      <TaskGroupFilter />
    </div>

    <template
      v-if="filteredTaskGroups.data.length"
    >
      <DateGroupedTaskGroups
        :task-groups="filteredTaskGroups.data"
        class="mb-8"
      />
    </template>
    <template
      v-else
    >
      <p
        v-text="$accessor.project.getFilters.state
          ? $trans('project.paragraphs.no_tasks_filter')
          : $trans('project.paragraphs.no_tasks')"
      />
    </template>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { TaskGroup } from '~/types/taskGroup'
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'
  import ProjectScreenshots from '@/components/Project/ProjectScreenshots/index.vue'
  import TaskGroupFilter from '@/components/TaskGroupFilter/index.vue'
  import { PaginateResponse } from '~/types/pagination'

  export default defineComponent({
    components: {
      TaskGroupFilter,
      DateGroupedTaskGroups,
      ProjectScreenshots
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
    mounted () {
      this.$mitt.on('update-tasks', this.fetchTaskGroups)
    },
    beforeDestroy () {
      this.$mitt.off('update-tasks', this.fetchTaskGroups)
    },
    methods: {
      fetchTaskGroups (params = {}) {
        const { state } = this.$accessor.project.getFilters

        const { slug } = this.$route.params
        return this.$axios.$get(`/projects/${slug}/task_groups`, {
          params: {
            ...params,
            state
          }
        })
          .then(res => {
            this.taskGroups = res
          })
      },
      loadMore () {
        if (this.taskGroups.meta.current_page + 1 > this.taskGroups.meta.total_pages) return

        const { state } = this.$accessor.project.getFilters

        const { slug } = this.$route.params
        this.$wait.start('fetching task groups')
        this.$axios.$get(`/projects/${slug}/task_groups`, {
          params: {
            page: this.taskGroups.meta.current_page + 1,
            state
          }
        })
          .then(res => {
            this.taskGroups.data = [
              ...this.taskGroups.data,
              ...res.data
            ]
            this.taskGroups.meta = res.meta
          })
          .finally(() => {
            this.$wait.end('fetching task groups')
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
