<template>
  <main>
    <div class="container dark:text-white mx-auto pt-4 md:pt-12">
      <h1 class="text-2xl font-medium">
        {{ $trans('reset-password.titles.main') }}
      </h1>

      <ValidationObserver
        ref="observer"
        slim
      >
        <form
          :disabled="$wait.is('resetting password')"
          class="flex flex-col md:w-1/2 mt-4"
          @submit.prevent="submitted"
        >
          <p class="mb-8">
            {{ $trans('reset-password.paragraphs.main') }}
          </p>

          <div class="flex flex-col mb-4 md:mb-0">
            <ValidationProvider
              vid="password"
              rules="required"
              :name="$trans('reset-password.labels.password').toLowerCase()"
              v-slot="{ invalid, errors }"
              slim
            >
              <div class="flex flex-col mb-4">
                <label
                  for="password"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('reset-password.labels.password') }} *
                </label>
                <input
                  v-model="formData.password"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('resetting password')"
                  type="password"
                  id="password"
                  class="input mb-1"
                  autocomplete="new-password"
                  required
                >
                <span
                  v-if="invalid"
                  v-text="errors[0]"
                  role="alert"
                  class="text-left text-sm text-red-500"
                />
              </div>
            </ValidationProvider>
            <ValidationProvider
              vid="passwordConfirmation"
              rules="required|confirmed:password"
              :name="$trans('reset-password.labels.password').toLowerCase()"
              v-slot="{ invalid, errors }"
              slim
            >
              <div class="flex flex-col">
                <label
                  for="passwordConfirmation"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('reset-password.labels.passwordConfirmation') }} *
                </label>
                <input
                  v-model="formData.passwordConfirmation"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('resetting password')"
                  type="password"
                  id="passwordConfirmation"
                  class="input mb-1"
                  autocomplete="new-password"
                  required
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
            :disabled="$wait.is('resetting password')"
            class="btn btn-primary mt-4 md:w-1/2"
            type="submit"
          >
            {{ $trans('reset-password.buttons.submit') }}
          </button>
        </form>
      </ValidationObserver>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    middleware: ['notAuthenticated', ({ route, redirect }) => {
      if (!route.query.token) redirect({ name: 'SignIn' })
    }],
    head () {
      return {
        title: this.$trans('reset-password.titles.main')
      }
    },
    data () {
      return {
        formData: {
          password: null,
          passwordConfirmation: null
        }
      }
    },
    methods: {
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return false

            const { password, passwordConfirmation } = this.formData

            this.$wait.start('resetting password')
            this.$axios.post('/auth/reset-password', {
              password,
              password_confirmation: passwordConfirmation
            }, {
              headers: {
                'Authorization': `Bearer ${this.$route.query.token}`
              }
            })
              .then(() => {
                this.$toasted.success(this.$trans('reset-password.paragraphs.success'))

                this.$router.push({
                  name: 'SignIn'
                })
                  .catch(() => {})
              })
              .catch((err) => {
                this.$toasted.error(this.$trans('reset-password.paragraphs.error'))
              })
              .finally(() => {
                this.$wait.end('resetting password')
              })
          })
      }
    }
  })
</script>
