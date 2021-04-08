<template>
  <img
    :src="icon"
    alt=""
    class="task-check select-none"
  >
</template>

<script lang="ts">
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

  const icons: {[x: string]: any} = {
    todo: require('@/assets/img/icons/todo.svg'),
    doing: require('@/assets/img/icons/doing.svg'),
    done: require('@/assets/img/icons/done.svg')
  }

  export default defineComponent({
    props: {
      state: {
        type: String,
        required: true
      }
    },
    setup (props) {
      const { state } = toRefs(props)
      const icon = computed(() => icons[state.value])

      return {
        icon
      }
    }
  })
</script>
