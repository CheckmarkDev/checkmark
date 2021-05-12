<template>
  <div class="pb-12">
    <h2
      v-text="$trans('settings.titles.profile')"
      class="text-2xl font-medium text-gray-800 mb-8"
    />

    <!-- Profile picture -->
    <ValidationObserver
      ref="pictureObserver"
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
            <ValidationProvider
              ref="avatar-provider"
              rules="image|size:10000"
              v-slot="{ invalid, errors }"
            >
              <input
                ref="fileInput"
                type="file"
                name="image"
                id="image"
                accept="image/*"
                class="w-full"
                @change="fileChange"
              >
              <span
                v-if="invalid"
                v-text="errors[0]"
                role="alert"
                class="text-left text-sm text-red-500"
              />
            </ValidationProvider>
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
            ref="username-provider"
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
              ref="first_name-provider"
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
              ref="last_name-provider"
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
  import useWait from '~/composables/useWait'
  import useAxios from '~/composables/useAxios'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'

  export default defineComponent({
    components: {
      AppAvatar
    },
    setup (props, { refs }) {
      const axios = useAxios()
      const wait = useWait()
      const accessor = useAccessor()
      const trans = useICU()
      const toasted = useToasted()

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

      function fileChange (e: Event) {
        if (e) {
          const files = (e.target as HTMLInputElement).files
          if (files && files.length) {
            const file = files[0]

            formData.value.image = file
            const reader = new FileReader()
            reader.onload = v => {
              if (v.target && v.target.result) {
                previewUrl.value = v.target.result as string
              }
            }
            reader.readAsDataURL(file)
          }
        }
      }

      function updateProfile (data: FormData, loader: string): Promise<any> {
        wait.start(loader)
        return axios.put('/me/profile', data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
          .then((res) => {
            accessor.setAuthUser(res.data.user)
            toasted.success(trans('settings.paragraphs.settings_saved'))

            return Promise.resolve(res)
          })
          .catch(err => {
            if (!err.response) return

            const { errors } = err.response.data
            if (errors) {
              Object.keys(errors).forEach(key => {
                const provider = refs[`${key}-provider`]
                if (provider) {
                  // @ts-ignore
                  provider.setErrors(errors[key])
                }
              })
            }
          })
          .finally(() => {
            wait.end(loader)
          })
      }

      function submitted () {
        // @ts-ignore
        refs.pictureObserver.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { image } = formData.value
            if (!image) return

            const data = new FormData()
            data.append('avatar', image)

            updateProfile(data, 'updating profile picture')
              .then(() => {
                formData.value.image = null
                const input = refs.fileInput as HTMLInputElement
                input.value = ''
              })
          })
      }

      function submittedInformations () {
        // @ts-ignore
        refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { username, last_name, first_name } = formData.value
            const data = new FormData()
            if (username && last_name && first_name) {
              data.append('username', username)
              data.append('last_name', last_name)
              data.append('first_name', first_name)
            }

            updateProfile(data, 'updating profile picture')
          })
      }

      return {
        fileChange,
        submitted,
        submittedInformations,
        previewUrl,
        formData
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
