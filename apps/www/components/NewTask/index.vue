<template>
  <div>
    <ValidationObserver
      ref="observer"
      slim
    >
      <form
        :disabled="$wait.is('creating task')"
        @submit.prevent="submitted"
      >
        <ValidationProvider
          rules="required"
          :name="$trans('sign-in.labels.email')"
          class="flex flex-col"
        >
          <label
            for="task"
            class="text-base text-gray-800 dark:text-gray-300 mb-2"
          >
            {{ $trans('home.labels.done_label') }}
          </label>
          <div class="flex flex-col md:flex-row">
            <div class="flex flex-1 items-start mb-3 md:mb-0 md:mr-4">
              <button
                type="button"
                class="new-task__toggle h-12 flex items-center border border-r-0 border-gray-300 dark:border-gray-600 hover:bg-gray-200 dark:hover:bg-gray-600 rounded-tl rounded-bl"
                @click="toggleState"
              >
                <div class="flex items-center px-4">
                  <task-check
                    :state="formData.state"
                    class="md:mr-2"
                  />
                  <div class="hidden md:inline-block whitespace-no-wrap">
                    {{ $trans(state) }}
                  </div>
                </div>
              </button>
              <div class="flex flex-col flex-1">
                <textarea
                  :disabled="$wait.is('creating task')"
                  id="task"
                  v-model="formData.content"
                  :placeholder="$trans('home.labels.done_placeholder')"
                  name=""
                  class="p-2 rounded-bl rounded-br rounded-tr appearance-none leading-relaxed border border-gray-300 dark:border-gray-600 border-solid mb-2 dark:bg-gray-600 dark:text-white"
                ></textarea>

                <div
                  v-if="formData.content.length > 0"
                  class="flex flex-col border border-gray-300 dark:border-gray-600 border-solid rounded p-2"
                >
                  <label
                    for="file"
                    class="text-sm text-gray-700 dark:text-gray-300 mb-2"
                  >
                    {{ $trans('home.labels.images') }}
                  </label>
                  <input
                    id="file"
                    ref="files"
                    type="file"
                    name="images[]"
                    accept="image/*"
                    multiple
                    @change="updateImages"
                  >
                </div>
              </div>
            </div>
            <button
              :disabled="$wait.is('creating task')"
              class="btn btn-primary w-full md:w-auto"
              type="submit"
            >
              {{ $trans('home.buttons.send') }}
            </button>
          </div>
        </ValidationProvider>
      </form>
    </ValidationObserver>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import TaskCheck from '@/components/TaskCheck/index.vue'
  import { TaskState } from '~/types/task'

  export default defineComponent({
    components: {
      TaskCheck
    },
    data () {
      return {
        formData: {
          state: 'done' as TaskState,
          content: '',
          images: []
        }
      }
    },
    computed: {
      state () {
        const states: {
          [x: string]: string
        } = {
          done: 'home.labels.done',
          doing: 'home.labels.doing',
          todo: 'home.labels.todo'
        }

        return states[(this.formData as any).state]
      }
    },
    methods: {
      toggleState () {
        const { state } = this.formData
        switch (state) {
          case TaskState.DONE:
            this.formData.state = TaskState.TODO
            break;
          case TaskState.TODO:
            this.formData.state = TaskState.DOING
            break;
          case TaskState.DOING:
            this.formData.state = TaskState.DONE
            break;
        }
      },
      // @ts-ignore
      updateImages (e) {
        this.formData.images = e.target.files
      },
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { state, content, images } = this.formData

            const formData = new FormData()
            formData.append('state', state)
            if (content.trim()) {
              formData.append('content', content.trim())
            }

            // @ts-ignore
            if (images) {
              images.forEach((file, k) => {
                formData.append('images[]', file)
              })
            }

            this.$wait.start('creating task')
            this.$axios.post('/me/tasks', formData, {
              headers: {
                'Content-Type': 'multipart/form-data'
              }
            })
              .then(() => {
                this.formData.content = ''
                this.formData.images = ''
                this.$toasted.success(this.$trans('home.paragraphs.task_added'))
                this.$mitt.emit('update-tasks')
              })
              .finally(() => {
                this.$wait.end('creating task')
              })
          })
      }
    }
  })
</script>

<style scoped>
  .new-task__toggle {
    @screen md {
      min-width: 100px;
    }
  }
</style>
