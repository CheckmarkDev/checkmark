<template>
  <img
    :src="icon"
    alt=""
    class="task-check select-none"
  >
</template>

<script lang="ts">
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'
  import { TaskSource, TaskState } from '~/types/task'

  const icons: {[x: string]: any} = {
    todo: require('@/assets/img/icons/todo.svg'),
    doing: require('@/assets/img/icons/doing.svg'),
    done: require('@/assets/img/icons/done.svg')
  }

  const githubIcons: {[x: string]: any} = {
    todo: require('@/assets/img/icons/github/todo.svg'),
    doing: require('@/assets/img/icons/github/doing.svg'),
    done: require('@/assets/img/icons/github/done.svg')
  }

  export default defineComponent({
    props: {
      state: {
        type: String as () => TaskState,
        required: true
      },
      source: {
        type: String as () => TaskSource,
        required: true
      }
    },
    setup (props) {
      const { state, source } = toRefs(props)
      const icon = computed(() => {
        if (source.value === 'github') {
          return githubIcons[state.value]
        }

        return icons[state.value]
      })

      return {
        icon
      }
    }
  })
</script>
