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
            {{ $trans('home.labels.done') }}
          </label>
          <div class="flex flex-col md:flex-row">
            <div class="flex flex-1 h-12 border mb-3 md:mb-0 border-solid border-gray-300 rounded md:mr-4">
              <button
                type="button"
                class="border border-t-0 border-b-0 border-l-0 border-r border-gray-300 px-4 hover:bg-gray-200"
                @click="toggleState"
              >
                <task-check
                  :state="formData.state"
                />
              </button>
              <textarea
                :disabled="$wait.is('creating task')"
                id="task"
                v-model="formData.content"
                name=""
                class="w-full p-2 border-none rounded appearance-none leading-relaxed"
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

  export default defineComponent({
    components: {
      TaskCheck
    },
    data () {
      return {
        formData: {
          state: 'done',
          content: ''
        }
      }
    },
    methods: {
      toggleState () {
        const { state } = this.formData
        switch (state) {
          case 'done':
            this.formData.state = 'todo'
            break;
          case 'todo':
            this.formData.state = 'doing'
            break;
          case 'doing':
            this.formData.state = 'done'
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
