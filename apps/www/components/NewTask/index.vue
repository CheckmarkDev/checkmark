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
        <div>
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
                    source="checkmark"
                    class="md:mr-2"
                  />
                  <div class="hidden md:inline-block whitespace-no-wrap">
                    {{ $trans(state) }}
                  </div>
                </div>
              </button>
              <div class="flex flex-col flex-1">
                <ValidationProvider
                  ref="content-provider"
                  rules="required|min:2|max:1000"
                  :name="$trans('home.fields.content')"
                  class="flex flex-col"
                  v-slot="{ invalid, errors }"
                >
                  <textarea
                    :disabled="$wait.is('creating task')"
                    :placeholder="$trans('home.labels.done_placeholder')"
                    id="task"
                    v-model="formData.content"
                    name="content"
                    minlength="2"
                    maxlength="1000"
                    class="p-2 rounded-bl rounded-br rounded-tr appearance-none leading-relaxed border border-gray-300 dark:border-gray-600 border-solid mb-2 dark:bg-gray-600 dark:text-white"
                    required
                  ></textarea>
                  <span
                    v-if="invalid"
                    v-text="errors[0]"
                    role="alert"
                    class="text-left text-sm text-red-500 mb-3"
                  />
                </ValidationProvider>

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
        </div>
      </form>
    </ValidationObserver>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import TaskCheck from '@/components/TaskCheck/index.vue'
  import { TaskState } from '~/types/task'
  import useValidationProvider from '~/composables/useValidationProvider'

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
                this.formData.images = []
                this.$toasted.success(this.$trans('home.paragraphs.task_added'))
                this.$mitt.emit('update-tasks')

                // @ts-ignore
                this.$refs.observer.reset()
              })
              .catch(err => {
                if (!err.response) return

                useValidationProvider(err, this.$refs)
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
  @screen md {
    .new-task__toggle {
      min-width: 100px;
    }
  }
</style>
