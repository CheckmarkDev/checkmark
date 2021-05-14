<template>
  <main>
    <div class="container dark:text-white mx-auto pt-4 md:pt-12">
      <h1 class="text-2xl font-medium">
        {{ $trans('sign-up.titles.main') }}
      </h1>

      <ValidationObserver
        ref="observer"
        slim
      >
        <form
          :disabled="$wait.is('signing up')"
          class="flex flex-col md:w-1/2 mt-4"
          @submit.prevent="submitted"
        >
          <div class="flex flex-col mb-4 md:mb-0">
            <ValidationProvider
              rules="email|required"
              :name="$trans('sign-up.labels.email').toLowerCase()"
              v-slot="{ invalid, errors }"
              class="mb-2"
              slim
            >
              <div class="flex flex-col">
                <label
                  for="email"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('sign-up.labels.email') }} *
                </label>
                <input
                  v-model="formData.email"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('signing up')"
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
              rules="required|min:2|max:32"
              :name="$trans('sign-up.labels.username').toLowerCase()"
              v-slot="{ invalid, errors }"
              class="mb-2"
              slim
            >
              <div class="flex flex-col">
                <label
                  for="username"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('sign-up.labels.username') }} *
                </label>
                <input
                  v-model="formData.username"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('signing up')"
                  type="text"
                  id="username"
                  class="input mb-1"
                  required
                  autocomplete="username"
                >
                <div
                  v-text="$trans('global.paragraphs.max_chars', {
                    chars: 32
                  })"
                  class="text-gray-700 dark:text-gray-300 text-sm"
                />
                <span
                  v-if="invalid"
                  v-text="errors[0]"
                  role="alert"
                  class="text-left text-sm text-red-500"
                />
              </div>
            </ValidationProvider>
            <div class="flex flex-col md:flex-row mb-2">
              <ValidationProvider
                rules="required"
                :name="$trans('sign-up.labels.first_name').toLowerCase()"
                v-slot="{ invalid, errors }"
                class="md:w-1/2 md:mr-4"
                slim
              >
                <div class="flex flex-col">
                  <label
                    for="first_name"
                    class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                  >
                    {{ $trans('sign-up.labels.first_name') }} *
                  </label>
                  <input
                    v-model="formData.first_name"
                    :class="{
                      'input--invalid': invalid && errors[0]
                    }"
                    :disabled="$wait.is('signing up')"
                    type="text"
                    id="first_name"
                    class="input mb-1"
                    required
                    autocomplete="given-name"
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
                rules="required"
                :name="$trans('sign-up.labels.last_name').toLowerCase()"
                v-slot="{ invalid, errors }"
                class="md:w-1/2"
                slim
              >
                <div class="flex flex-col">
                  <label
                    for="last_name"
                    class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                  >
                    {{ $trans('sign-up.labels.last_name') }} *
                  </label>
                  <input
                    v-model="formData.last_name"
                    :class="{
                      'input--invalid': invalid && errors[0]
                    }"
                    :disabled="$wait.is('signing up')"
                    type="text"
                    id="last_name"
                    class="input mb-1"
                    required
                    autocomplete="family-name"
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
            <ValidationProvider
              vid="password"
              rules="required|min:6"
              :name="$trans('sign-up.labels.password').toLowerCase()"
              v-slot="{ invalid, errors }"
              class="mb-2"
              slim
            >
              <div class="flex flex-col">
                <label
                  for="password"
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
                >
                  {{ $trans('sign-up.labels.password') }} *
                </label>
                <input
                  v-model="formData.password"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('signing up')"
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

            <div>
              <input
                v-model="formData.tos"
                type="checkbox"
                name="tos"
                id="tos"
                required
              >
              <label for="tos">
                J'ai lu et j'accepte les <nuxt-link :to="{ name: 'Terms' }" class="text-blue-500 underline" target="_blank">conditions générales d'utilisation</nuxt-link>.
              </label>
            </div>
          </div>
          <button
            :disabled="$wait.is('signing up')"
            class="btn btn-primary mt-4 md:w-1/2"
            type="submit"
          >
            {{ $trans('sign-up.buttons.sign-up') }}
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
        title: this.$trans('sign-up.titles.main'),
        meta: [
          { hid: 'description', name: 'description', content: this.$trans('sign-up.paragraphs.description') }
        ]
      }
    },
    data () {
      return {
        formData: {
          tos: false,
          email: null,
          username: null,
          first_name: null,
          last_name: null,
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

            const { email, username, first_name, last_name, password } = this.formData

            this.$wait.start('signing up')
            this.$axios.post('/auth/register', {
              email,
              username,
              first_name,
              last_name,
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
              .finally(() => {
                this.$wait.end('signing up')
              })
          })
      }
    }
  })
</script>
