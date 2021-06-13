<template>
  <div
    v-infinite-scroll="loadMore"
    class="flex flex-col dark:text-white"
  >
    <div class="flex items-center justify-between">
      <h2 class="font-medium text-2xl mb-4">
        {{ $trans('global.titles.feed') }}
      </h2>

      <TaskGroupFilter />
    </div>

    <DateGroupedTaskGroups
      :task-groups="taskGroups.data"
      class="mb-8"
    />
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { TaskGroup } from '~/types/taskGroup'
  import { User } from '~/types/user'
  import TaskGroupFilter from '@/components/TaskGroupFilter/index.vue'
  import DateGroupedTaskGroups from '@/components/DateGroupedTaskGroups/index.vue'

  export default defineComponent({
    components: {
      DateGroupedTaskGroups,
      TaskGroupFilter
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
    mounted () {
      this.$mitt.on('update-tasks', this.updateTasks)
    },
    beforeDestroy () {
      this.$mitt.off('update-tasks', this.updateTasks)
    },
    methods: {
      loadMore () {
        if (this.taskGroups.meta.current_page + 1 > this.taskGroups.meta.total_pages) return

        const { username } = this.$route.params
        const { state } = this.$accessor.project.getFilters
        this.$axios.$get(`/users/${username}/task_groups`, {
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
      },
      updateTasks () {
        const { username } = this.$route.params
        const { state } = this.$accessor.project.getFilters
        this.$axios.$get(`/users/${username}/task_groups`, {
          params: {
            state
          }
        })
          .then(res => {
            this.taskGroups = res
          })
      },
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
