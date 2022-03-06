<template>
  <main>
    <div class="container dark:text-white mx-auto pt-4 md:pt-12">
      <h1 class="text-2xl font-medium">
        {{ $trans('forgot-password.titles.main') }}
      </h1>

      <ValidationObserver
        v-if="!sent"
        ref="observer"
        slim
      >
        <form
          :disabled="$wait.is('forgot password')"
          class="flex flex-col md:w-1/2 mt-4"
          @submit.prevent="submitted"
        >
          <p class="mb-8">
            {{ $trans('forgot-password.paragraphs.main') }}
          </p>

          <div class="flex flex-col mb-4 md:mb-0">
            <ValidationProvider
              rules="email|required"
              :name="$trans('forgot-password.labels.email').toLowerCase()"
              v-slot="{ invalid, errors }"
              slim
            >
              <div class="flex flex-col">
                <label
                  for="email"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('forgot-password.labels.email') }} *
                </label>
                <input
                  v-model="formData.email"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('forgot password')"
                  type="email"
                  id="email"
                  class="input mb-1"
                  required
                  autocomplete="email"
                >
                <span
                  v-if="invalid"
                  v-text="errors[0]"
                  role="alert"
                  class="text-left text-sm text-red-500"
                />
              </div>
            </ValidationProvider>
          </div>

          <button
            :disabled="$wait.is('forgot password')"
            class="btn btn-primary mt-4 md:w-1/2"
            type="submit"
          >
            {{ $trans('forgot-password.buttons.submit') }}
          </button>
        </form>
      </ValidationObserver>
      <div v-else class="md:w-1/2">
        <p class="mt-4 mb-8">
          {{ $trans('forgot-password.paragraphs.sent') }}
        </p>
        <button
          class="btn btn-primary"
          @click="sent = false"
        >
          {{ $trans('forgot-password.buttons.retry') }}
        </button>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    middleware: ['notAuthenticated'],
    head () {
      return {
        title: this.$trans('forgot-password.titles.main')
      }
    },
    data () {
      return {
        formData: {
          email: null
        },
        sent: false
      }
    },
    methods: {
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return false

            const { email } = this.formData

            this.$wait.start('forgot password')
            this.$axios.post('/auth/forgot-password', {
              email
            })
              .finally(() => {
                this.sent = true
                this.$wait.end('forgot password')
              })
          })
      }
    }
  })
</script>
