<template>
  <div class="pb-12">
    <h2
      v-text="$trans('settings.titles.account')"
      class="text-2xl font-medium text-gray-800 mb-8"
    />

    <ValidationObserver
      ref="observer"
      slim
    >
      <form
        :disabled="$wait.is('updating profile informations')"
        class="flex flex-col lg:w-2/3 mt-4"
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
                class="text-left text-gray-700 text-base mb-1"
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
                class="text-left text-gray-700 text-base mb-1"
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
        </div>
        <button
          :disabled="$wait.is('updating profile informations')"
          v-text="$trans('global.buttons.save')"
          class="btn btn-primary mt-4 mr-auto"
          type="submit"
        />
      </form>
    </ValidationObserver>
  </div>
</template>

<script lang="ts">
  import { defineComponent, Ref, ref } from '@nuxtjs/composition-api'

  import AppAvatar from '@/components/AppAvatar/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import { User } from '~/types/user'

  export default defineComponent({
    components: {
      AppAvatar
    },
    setup () {
      const accessor = useAccessor()
      const { email } = accessor.getAuthUser as User

      const formData: Ref<{
        email: string|null,
        password: string|null
      }> = ref({
        email,
        password: null
      })

      return {
        formData
      }
    },
    methods: {
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { email, password } = this.formData

            this.$wait.start('updating profile account')
            this.$axios.put('/me/profile', {
              email,
              password,
            })
              .then((res) => {
                this.formData.password = null
                // @ts-ignore
                this.$refs.observer.reset()

                this.$accessor.setAuthUser(res.data.user)
                this.$toasted.success(this.$trans('settings.paragraphs.settings_saved'))
              })
              .finally(() => {
                this.$wait.end('updating profile account')
              })
          })
      }
    },
    head () {
      const title = this.$trans('settings.titles.account')

      return {
        title,
        meta: [
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>
