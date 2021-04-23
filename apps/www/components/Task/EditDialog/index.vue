<template>
  <div class="flex fixed top-0 left-0 w-full h-full bg-gray-800 bg-opacity-50 z-20">
    <div class="edit-dialog__content w-full bg-white m-auto p-4 md:p-8">
      <div class="flex items-center justify-between mb-8">
        <h1 class="font-medium text-xl">
          {{ $trans('global.titles.edit_task') }}
        </h1>
        <button
          type="button"
          @click="$emit('close')"
        >
          <XIcon
            size="24"
          />
        </button>
      </div>
      <div>
        <ValidationObserver
          ref="observer"
          slim
        >
          <form
            :disabled="$wait.is('updating task')"
            @submit.prevent="submitted"
          >
            <ValidationProvider
              rules="required"
              :name="$trans('sign-in.labels.email')"
              class="flex flex-col"
            >
              <div class="flex flex-col">
                <pre>
                  {{ formData.state }}
                </pre>
                <TaskStateSwitch
                  v-model="formData.state"
                  class="mb-4"
                />
                <div class="w-full">
                  <textarea
                    :disabled="$wait.is('updating task')"
                    id="task"
                    v-model="formData.content"
                    :placeholder="$trans('home.labels.done_placeholder')"
                    name=""
                    class="w-full mb-2 p-2 rounded-bl rounded-br rounded-tr appearance-none leading-relaxed border border-gray-300 border-solid"
                  ></textarea>
                </div>
                <button
                  :disabled="$wait.is('updating task')"
                  class="btn btn-primary w-full md:w-auto"
                  type="submit"
                >
                  {{ $trans('home.buttons.edit') }}
                </button>
              </div>
            </ValidationProvider>
          </form>
        </ValidationObserver>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, toRefs, reactive } from '@nuxtjs/composition-api'
  import { XIcon } from 'vue-feather-icons'
  import { Task } from '~/types/task'
  import UserCard from '@/components/UserCard/index.vue'
  import TaskStateSwitch from './TaskStateSwitch/index.vue'

  export default defineComponent({
    components: {
      XIcon,
      UserCard,
      TaskStateSwitch
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)
      const formData = reactive({
        content: task.value.content,
        state: task.value.state
      })

      return {
        formData
      }
    },
    methods: {
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { content, state } = this.formData

            this.$wait.start('updating task')
            this.$axios.put(`/me/tasks/${this.task.uuid}`, {
              content: content.trim() || null,
              state: state
            })
              .then(() => {
                this.formData.content = ''
                this.$toasted.success(this.$trans('home.paragraphs.task_edited'))
                this.$mitt.emit('update-tasks')
                this.$emit('close')
              })
              .finally(() => {
                this.$wait.end('updating task')
              })
          })
      }
    }
  })
</script>

<style scoped>
  .edit-dialog__content {
    max-width: 480px;
  }
</style>
