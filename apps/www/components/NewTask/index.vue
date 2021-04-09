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
            class="text-base text-gray-800 mb-2"
          >
            {{ $trans('home.labels.done_label') }}
          </label>
          <div class="flex flex-col md:flex-row">
            <div class="flex flex-1 h-12 border mb-3 md:mb-0 border-solid border-gray-300 rounded md:mr-4">
              <button
                type="button"
                class="new-task__toggle flex items-center border border-t-0 border-b-0 border-l-0 border-r border-gray-300 hover:bg-gray-200"
                @click="toggleState"
              >
                <div class="flex items-center px-4">
                  <task-check
                    :state="formData.state"
                    class="mr-2"
                  />
                  <div class="whitespace-no-wrap">
                    {{ $trans(state) }}
                  </div>
                </div>
              </button>
              <textarea
                :disabled="$wait.is('creating task')"
                id="task"
                v-model="formData.content"
                :placeholder="$trans('home.labels.done_placeholder')"
                name=""
                class="flex-1 p-2 border-none rounded appearance-none leading-relaxed"
              ></textarea>
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
          content: ''
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
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { state, content } = this.formData

            this.$wait.start('creating task')
            this.$axios.post('/me/tasks', {
              state,
              content: content.trim() || null
            })
              .then(() => {
                this.$toasted.success(this.$trans('home.paragraphs.task_added'))
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
    min-width: 100px;
  }
</style>
