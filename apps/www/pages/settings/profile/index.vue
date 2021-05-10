<template>
  <div class="pb-12">
    <h2
      v-text="$trans('settings.titles.profile')"
      class="text-2xl font-medium text-gray-800 mb-8"
    />

    <!-- Profile picture -->
    <ValidationObserver
      ref="observer"
    >
      <form
        :disabled="$wait.is('updating profile picture')"
        class="flex flex-col md:flex-row mb-12"
        @submit.prevent="submitted"
      >
        <div class="mr-8 flex-shrink-0 mb-4 md:mb-0">
          <AppAvatar
            :src="previewUrl"
            width="150"
            height="150"
          />
        </div>
        <div>
          <h3
            v-text="$trans('settings.titles.profile_picture')"
            class="text-lg text-gray-700 font-medium mb-2"
          />
          <div class="mb-3 border border-solid border-gray-300 rounded p-2">
            <input
              type="file"
              name="image"
              id="image"
              accept="image/*"
              class="w-full"
              @change="fileChange"
            >
          </div>
          <h3
            v-text="$trans('settings.titles.profile_rules')"
            class="text-base text-gray-700 font-medium mb-2"
          />
          <p
            v-text="$trans('settings.paragraphs.profile_rules')"
            class="text-base text-gray-700 mb-1"
          />
          <ul class="text-base text-gray-700 list-disc pl-4 mb-8">
            <li
              v-text="$trans('settings.paragraphs.profile_rules.racism')"
            />
            <li
              v-text="$trans('settings.paragraphs.profile_rules.nsfw')"
            />
          </ul>

          <button
            :disabled="$wait.is('updating profile picture') || !formData.image"
            v-text="$trans('global.buttons.save')"
            type="submit"
            class="btn btn-primary"
          />
        </div>
      </form>
    </ValidationObserver>

    <!-- Profile informations -->
    <h3
      v-text="$trans('settings.titles.profile_infos')"
      class="text-lg text-gray-700 font-medium mb-2"
    />

    <ValidationObserver
      ref="observer"
      slim
    >
      <form
        :disabled="$wait.is('updating profile informations')"
        class="flex flex-col lg:w-2/3 mt-4"
        @submit.prevent="submittedInformations"
      >
        <div class="flex flex-col mb-4 md:mb-0">
          <ValidationProvider
            rules="required|min:2|max:32"
            :name="$trans('sign-up.labels.username').toLowerCase()"
            v-slot="{ invalid, errors }"
            class="mb-3"
            slim
          >
            <div class="flex flex-col">
              <label
                for="username"
                class="text-left text-gray-700 text-base mb-1"
              >
                {{ $trans('sign-up.labels.username') }} *
              </label>
              <input
                v-model="formData.username"
                :class="{
                  'input--invalid': invalid && errors[0]
                }"
                :disabled="$wait.is('updating profile informations')"
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
                class="text-gray-700 text-sm"
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
                  class="text-left text-gray-700 text-base mb-1"
                >
                  {{ $trans('sign-up.labels.first_name') }} *
                </label>
                <input
                  v-model="formData.first_name"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('updating profile informations')"
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
                  class="text-left text-gray-700 text-base mb-1"
                >
                  {{ $trans('sign-up.labels.last_name') }} *
                </label>
                <input
                  v-model="formData.last_name"
                  :class="{
                    'input--invalid': invalid && errors[0]
                  }"
                  :disabled="$wait.is('updating profile informations')"
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
      const { avatar_url, username, last_name, first_name } = accessor.getAuthUser as User

      const previewUrl = ref(avatar_url)
      const formData: Ref<{
        image: Blob|null,
        username: string,
        first_name: string,
        last_name: string
      }> = ref({
        image: null,
        username,
        first_name,
        last_name
      })

      return {
        previewUrl,
        formData
      }
    },
    methods: {
      fileChange (e: Event) {
        if (e) {
          const file = (e.target as HTMLInputElement).files[0]

          this.formData.image = file
          const reader = new FileReader()
          reader.onload = v => {
            this.previewUrl = v.target.result
          }

          reader.readAsDataURL(file)
        }
      },
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { image } = this.formData

            const formData = new FormData()
            formData.append('avatar', image)

            this.$wait.start('updating profile picture')
            this.$axios.put('/me/profile', formData, {
              headers: {
                'Content-Type': 'multipart/form-data'
              }
            })
              .then((res) => {
                this.$accessor.setAuthUser(res.data)

                this.formData.image = null
                this.$toasted.success(this.$trans('settings.paragraphs.settings_saved'))
              })
              .finally(() => {
                this.$wait.end('updating profile picture')
              })
          })
      },
      submittedInformations () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { username, last_name, first_name } = this.formData

            this.$wait.start('updating profile informations')
            this.$axios.put('/me/profile', {
              username,
              last_name,
              first_name
            })
              .then((res) => {
                this.$accessor.setAuthUser(res.data)
                this.$toasted.success(this.$trans('settings.paragraphs.settings_saved'))
              })
              .finally(() => {
                this.$wait.end('updating profile informations')
              })
          })
      }
    },
    head () {
      const title = this.$trans('settings.titles.profile')

      return {
        title,
        meta: [
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>
