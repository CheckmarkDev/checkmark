<template>
  <button
    :disabled="$wait.is(`liking ${task.uuid}`)"
    :class="{
      'like-button--liked': hasLiked
    }"
    type="button"
    class="like-button relative h-8 w-8 border border-solid border-gray-400 hover:bg-gray-200 rounded-full"
    @click="like"
  >
    <div class="flex items-center justify-center">
      <template
        v-if="hasLiked"
      >
        <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M12.8933 2.07333C12.5528 1.73267 12.1485 1.46243 11.7036 1.27805C11.2586 1.09368 10.7817 0.998779 10.3 0.998779C9.81834 0.998779 9.3414 1.09368 8.89643 1.27805C8.45145 1.46243 8.04717 1.73267 7.70666 2.07333L7 2.78L6.29333 2.07333C5.60554 1.38553 4.67269 0.999136 3.7 0.999136C2.72731 0.999136 1.79446 1.38553 1.10666 2.07333C0.41887 2.76112 0.0324707 3.69397 0.0324707 4.66666C0.0324707 5.63935 0.41887 6.5722 1.10666 7.26L1.81333 7.96666L7 13.1533L12.1867 7.96666L12.8933 7.26C13.234 6.91949 13.5042 6.51521 13.6886 6.07023C13.873 5.62526 13.9679 5.14832 13.9679 4.66666C13.9679 4.185 13.873 3.70807 13.6886 3.26309C13.5042 2.81812 13.234 2.41383 12.8933 2.07333Z" fill="#2589C7"/>
        </svg>
      </template>
      <template
        v-else
      >
        <svg width="16" height="14" viewBox="0 0 16 14" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M13.8933 2.07333C13.5528 1.73267 13.1485 1.46243 12.7036 1.27805C12.2586 1.09368 11.7817 0.998779 11.3 0.998779C10.8183 0.998779 10.3414 1.09368 9.89643 1.27805C9.45145 1.46243 9.04717 1.73267 8.70666 2.07333L8 2.78L7.29333 2.07333C6.60554 1.38553 5.67269 0.999136 4.7 0.999136C3.72731 0.999136 2.79446 1.38553 2.10666 2.07333C1.41887 2.76112 1.03247 3.69397 1.03247 4.66666C1.03247 5.63935 1.41887 6.5722 2.10666 7.26L2.81333 7.96666L8 13.1533L13.1867 7.96666L13.8933 7.26C14.234 6.91949 14.5042 6.51521 14.6886 6.07023C14.873 5.62526 14.9679 5.14832 14.9679 4.66666C14.9679 4.185 14.873 3.70807 14.6886 3.26309C14.5042 2.81812 14.234 2.41383 13.8933 2.07333Z" stroke="#E2E8F0" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      </template>
      <div
        v-if="task.likes.length > 0"
        class="like-button__badge absolute bg-blue-500 text-white rounded-full w-4 h-4 text-xs"
      >
        {{ task.likes.length }}
      </div>
    </div>
  </button>
</template>

<script lang="ts">
  import { defineComponent, toRefs, computed } from '@nuxtjs/composition-api'
  import useAccessor from '~/composables/useAccessor'
  import useAxios from '~/composables/useAxios'
  import useWait from '~/composables/useWait'
  import useMitt from '~/composables/useMitt'
  import { Task } from '~/types/task'

  export default defineComponent({
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup(props) {
      const { task } = toRefs(props)
      const accessor = useAccessor()
      const axios = useAxios()
      const wait = useWait()
      const mitt = useMitt()

      const hasLiked = computed(() => accessor.getAuthUser && task.value.likes.includes(accessor.getAuthUser.uuid))
      const isSelfTask = computed(() => accessor.getAuthUser && task.value.user.uuid === accessor.getAuthUser.uuid)

      function like () {
        if (!accessor.isAuthenticated || !isSelfTask.value) {
          mitt.emit(`like dialog for ${task.value.uuid}`, task.value)
          return
        }

        if (hasLiked.value) {
          wait.start(`liking ${task.value.uuid}`)
          axios.delete(`/tasks/${task.value.uuid}/like`)
            .then(() => {
              mitt.emit('update-tasks')
            })
            .finally(() => {
              wait.end(`liking ${task.value.uuid}`)
            })
        } else {
          wait.start(`liking ${task.value.uuid}`)
          axios.post(`/tasks/${task.value.uuid}/like`)
            .then(() => {
              mitt.emit('update-tasks')
            })
            .finally(() => {
              wait.end(`liking ${task.value.uuid}`)
            })
        }
      }

      return {
        like,
        hasLiked,
        isSelfTask
      }
    }
  })
</script>

<style scoped>
  .like-button path {
    @apply text-gray-400 stroke-current;
  }

  .like-button--liked {
    @apply border-blue-500;
  }

  .like-button__badge {
    bottom: -6px;
    right: -6px;
  }
</style>