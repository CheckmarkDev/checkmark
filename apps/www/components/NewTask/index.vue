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
          <div class="flex">
            <div class="flex flex-1 h-12 border border-solid border-gray-300 rounded mr-4">
              <textarea
                :disabled="$wait.is('creating task')"
                id="task"
                v-model="formData.content"
                name=""
                class="w-full p-2 border-none rounded appearance-none"
              ></textarea>
            </div>
            <button
              :disabled="$wait.is('creating task')"
              class="btn btn-primary"
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

  export default defineComponent({
    data () {
      return {
        formData: {
          state: 0,
          content: null
        }
      }
    },
    methods: {
      submitted () {
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { state, content } = this.formData

            this.$wait.start('creating task')
            this.$axios.post('/me/tasks', {
              state,
              content
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
