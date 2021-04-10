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
            <div class="flex flex-1 items-start mb-3 md:mb-0 md:mr-4">
              <button
                type="button"
                class="new-task__toggle h-12 flex items-center border border-r-0 border-gray-300 hover:bg-gray-200 rounded-tl rounded-bl"
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
              <textarea
                :disabled="$wait.is('creating task')"
                id="task"
                v-model="formData.content"
                :placeholder="$trans('home.labels.done_placeholder')"
                name=""
                class="flex-1 p-2 rounded-bl rounded-br rounded-tr appearance-none leading-relaxed border border-gray-300 border-solid"
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
                this.formData.content = ''
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
