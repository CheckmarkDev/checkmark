<template>
  <form
    :disabled="$wait.is('creating a comment')"
    class="flex flex-col md:flex-row items-start"
    @submit.prevent="submitted"
  >
    <UserAvatar
      :user="task.user"
      class="hidden md:flex mr-8"
    />
    <div class="flex flex-1 w-full mb-4 md:mb-0 md:mr-4">
      <label
        for="content"
        v-text="$trans('global.labels.comment')"
        class="hidden"
      />
      <textarea
        v-model="formData.content"
        name="content"
        class="flex-1 p-2 rounded-bl rounded-br rounded-tr appearance-none leading-relaxed border border-gray-300 border-solid"
        id="content"
      ></textarea>
    </div>
    <button
      :disabled="$wait.is('creating a comment')"
      :title="$trans('global.buttons.send')"
      type="submit"
      class="btn btn-primary w-full md:w-auto"
    >
      <div class="flex items-center">
        <img src="@/assets/img/icons/send.svg" alt="">
        <span
          v-text="$trans('global.buttons.send')"
          class="md:hidden ml-2"
        />
      </div>
    </button>
  </form>
</template>

<script lang="ts">
  import { defineComponent, ref, toRefs } from '@nuxtjs/composition-api'
  import useAxios from '~/composables/useAxios'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'
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
    setup (props) {
      const { task } = toRefs(props)
      const wait = useWait()
      const axios = useAxios()
      const toasted = useToasted()
      const trans = useICU()
      const mitt = useMitt()

      const formData = ref({
        content: null
      })

      function submitted () {
        wait.start('creating a comment')
        axios.post(`/tasks/${task.value.uuid}/comments`, {
          content: formData.value.content
        })
          .then(() => {
            mitt.emit('new-comment')
            formData.value.content = null
            toasted.success(trans('user.paragraphs.commented'))
          })
          .finally(() => {
            wait.end('creating a comment')
          })
      }

      return {
        formData,
        submitted
      }
    },
  })
</script>
