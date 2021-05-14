<template>
  <main>
    <div class="container dark:text-white mx-auto pt-4 md:pt-12">
      <h1 class="text-2xl font-medium">
        {{ $trans('sign-in.titles.main') }}
      </h1>

      <ValidationObserver
        ref="observer"
        slim
      >
        <form
          :disabled="$wait.is('signing in')"
          class="flex flex-col md:w-1/2 mt-4"
          @submit.prevent="submitted"
        >
          <div class="flex flex-col mb-4 md:mb-0">
            <ValidationProvider
              rules="email|required"
              :name="$trans('sign-in.labels.email').toLowerCase()"
              v-slot="{ invalid, errors }"
              slim
            >
              <div class="flex flex-col">
                <label
                  for="email"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('sign-in.labels.email') }} *
                </label>
                <input
                  v-model="formData.email"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('signing in')"
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
            <ValidationProvider
              vid="password"
              rules="required"
              :name="$trans('sign-in.labels.password').toLowerCase()"
              v-slot="{ invalid, errors }"
              slim
            >
              <div class="flex flex-col">
                <label
                  for="password"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('sign-in.labels.password') }} *
                </label>
                <input
                  v-model="formData.password"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('signing in')"
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
          </div>
          <button
            :disabled="$wait.is('signing in')"
            class="btn btn-primary mt-4 md:w-1/2"
            type="submit"
          >
            {{ $trans('sign-in.buttons.sign-in') }}
          </button>
        </form>
      </ValidationObserver>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import Cookie from 'js-cookie'

  export default defineComponent({
    middleware: ['notAuthenticated'],
    head () {
      return {
        title: this.$trans('sign-in.titles.main'),
        meta: [
          { hid: 'description', name: 'description', content: this.$trans('sign-in.paragraphs.description') }
        ]
      }
    },
    data () {
      return {
        formData: {
          email: null,
          password: null
        }
      }
    },
    methods: {
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return false

            const { email, password } = this.formData

            this.$wait.start('signing in')
            this.$axios.post('/auth/login', {
              email,
              password
            })
              .then(response => {
                const { token, user, projects } = response.data
                this.$accessor.setAuthToken(token)
                this.$accessor.setAuthUser(user)
                this.$accessor.setAuthProjects(projects)
                Cookie.set('token', token)
                Cookie.set('user', JSON.stringify(user))

                this.$router.push({
                  name: 'Home'
                })
                  .catch(() => {})
              })
              .catch(() => {
                this.$toasted.error(this.$trans('sign-in.paragraphs.email-password-mismatch'))
              })
              .finally(() => {
                this.$wait.end('signing in')
              })
          })
      }
    }
  })
</script>
