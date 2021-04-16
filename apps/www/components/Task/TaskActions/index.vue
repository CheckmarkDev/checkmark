<template>
  <div
    v-click-outside="() => open = false"
    class="relative"
  >
    <button
      type="button"
      class="border border-solid border-gray-300 rounded-full p-2"
      @click="open = true"
    >
      <more-horizontal-icon
        size="20"
        class="text-gray-700"
      />
    </button>
    <transition
      name="fade"
    >
      <ul
        v-if="open"
        class="absolute right-0 bg-white rounded border border-solid border-gray-300 p-3 shadow-lg z-10"
      >
        <li>
          <button
            :disabled="$wait.is(`deleting task ${task.uuid}`)"
            type="button"
            class="text-sm py-2 px-3 rounded hover:bg-gray-200 text-red-600"
            @click="removeTask"
          >
            {{ $trans('home.buttons.delete') }}
          </button>
        </li>
      </ul>
    </transition>
  </div>
</template>

<script lang="ts">
  import { defineComponent, ref, toRefs } from '@nuxtjs/composition-api'
  import { MoreHorizontalIcon } from 'vue-feather-icons'
  import useAxios from '~/composables/useAxios'
  import useWait from '~/composables/useWait'
  import useToasted from '~/composables/useToasted'
  import useMitt from '~/composables/useMitt'
  import useICU from '~/composables/useICU'
  import { Task } from '~/types/task'

  export default defineComponent({
    components: {
      MoreHorizontalIcon
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const open = ref(false)
      const { task } = toRefs(props)

      const wait = useWait()
      const axios = useAxios()
      const toasted = useToasted()
      const mitt = useMitt()
      const trans = useICU()

      function removeTask () {
        if (window.confirm(trans('home.paragraphs.confirm_task_deletion'))) {
          wait.start(`deleting task ${task.value.uuid}`)
          axios.delete(`/me/tasks/${task.value.uuid}`)
            .then(() => {
              toasted.success(trans('home.paragraphs.task_deleted'))
              mitt.emit('update-tasks')
            })
            .finally(() => {
              open.value = false
              wait.end(`deleting task ${task.value.uuid}`)
            })
        }
      }

      return {
        open,
        removeTask
      }
    }
  })
</script>
