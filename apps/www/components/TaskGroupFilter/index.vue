<template>
  <div
    v-click-outside="() => open = false"
    class="task-group-filter relative"
  >
    <button
      type="button"
      class="flex items-center justify-center border border-solid border-gray-300 text-gray-700 dark:text-white dark:border-gray-600 dark:hover:bg-gray-600 rounded hover:bg-gray-200 py-2 px-3"
      @click="open = true"
    >
      <div
        class="mr-4"
        v-text="$accessor.project.getFilters.state
          ? $trans('global.labels.filter_value', {
            value: $trans(`home.labels.${$accessor.project.getFilters.state}`)
          })
          : $trans('global.labels.filter')"
      />
      <ChevronDownIcon
        :class="{
          'rotate-180': open
        }"
        size="20"
        class="text-gray-600 dark:text-gray-300 transform transition-transform"
      />
    </button>

    <transition
      name="fade"
    >
      <ul
        v-if="open"
        class="task-group-filter__menu absolute right-0 bg-white dark:bg-gray-600 dark:text-white rounded border border-solid border-gray-300 dark:border-gray-600 p-3 shadow-lg z-10"
      >
        <li
          v-for="(filter, k) in filters"
          :key="k"
          class="mb-2"
        >
          <button
            :disabled="$wait.is('fetching task groups')"
            :class="{
              'bg-gray-200 dark:bg-gray-500': filter.state === $accessor.project.getFilters.state
            }"
            type="button"
            class="w-full text-left text-sm py-2 px-3 rounded hover:bg-gray-200 dark:hover:bg-gray-500"
            @click="applyFilter(filter.state)"
          >
            <div class="flex items-center">
              <TaskCheck
                v-if="filter.state"
                :state="filter.state"
                :source="'checkmark'"
                class="mr-4"
              />
              <div
                v-text="filter.title"
              />
            </div>
          </button>
        </li>
      </ul>
    </transition>
  </div>
</template>

<script lang="ts">
  import { defineComponent, readonly, ref, toRefs } from '@nuxtjs/composition-api'
  import { ChevronDownIcon } from 'vue-feather-icons'
  import useAxios from '~/composables/useAxios'
  import useWait from '~/composables/useWait'
  import useToasted from '~/composables/useToasted'
  import useMitt from '~/composables/useMitt'
  import useICU from '~/composables/useICU'
  import useAccessor from '~/composables/useAccessor'
  import { Task, TaskState } from '~/types/task'
  import TaskCheck from '@/components/TaskCheck/index.vue'

  export default defineComponent({
    components: {
      ChevronDownIcon,
      TaskCheck
    },
    setup (props) {
      const open = ref(false)
      const mitt = useMitt()
      const trans = useICU()
      const accessor = useAccessor()

      const filters = readonly([
        {
          title: trans('global.labels.all_tasks'),
          state: null
        },
        {
          title: trans('home.labels.todo'),
          state: TaskState.TODO
        },
        {
          title: trans('home.labels.doing'),
          state: TaskState.DOING
        },
        {
          title: trans('home.labels.done'),
          state: TaskState.DONE
        }
      ])

      function applyFilter (state: TaskState|null) {
        accessor.project.setFilter({
          name: 'state',
          value: state
        })

        mitt.emit('update-tasks')
        open.value = false
      }

      return {
        open,
        filters,
        applyFilter
      }
    }
  })
</script>

<style scoped>
  .task-group-filter__menu {
    min-width: 250px;
  }
</style>
