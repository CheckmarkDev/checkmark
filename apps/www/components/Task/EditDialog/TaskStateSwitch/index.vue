<template>
  <div class="task-state-switch rounded border border-gray-300 dark:border-gray-600 flex items-center mr-auto">
    <button
      v-for="state in states"
      :key="state.key"
      :class="{
        'task-state-switch__item--active bg-gray-300 hover:bg-gray-300 dark:bg-gray-600': state.key === value
      }"
      type="button"
      class="task-state-switch__item focus:outline-none flex p-2 hover:bg-gray-200 dark:hover:bg-gray-600 dark:text-white dark:border-gray-600"
      @click="$emit('input', state.key)"
    >
      <div class="flex items-center">
        <TaskCheck
          :state="state.key"
          class="mr-2"
        />
        <div
          v-text="state.label"
        />
      </div>
    </button>
  </div>
</template>

<script lang="ts">
  import { defineComponent, readonly } from '@nuxtjs/composition-api'

  import TaskCheck from '@/components/TaskCheck/index.vue'
  import useICU from '~/composables/useICU'

  export default defineComponent({
    components: {
      TaskCheck
    },
    props: {
      value: {
        type: String,
        required: true
      }
    },
    setup() {
      const trans = useICU()
      const states = readonly([
        {
          key: 'done',
          label: trans('home.labels.done')
        },
        {
          key: 'doing',
          label: trans('home.labels.doing')
        },
        {
          key: 'todo',
          label: trans('home.labels.todo')
        }
      ])

      return {
        states
      }
    },
  })
</script>

<style scoped>
  .task-state-switch__item:not(:last-child) {
    @apply border-gray-300 dark:border-gray-600;

    border-right-style: solid;
    border-right-width: 1px;
  }
</style>
