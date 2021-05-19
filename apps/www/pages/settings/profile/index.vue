<template>
  <div class="pb-12">
    <h2
      v-text="$trans('settings.titles.profile')"
      class="text-2xl font-medium text-gray-800 dark:text-white mb-8"
    />

    <ValidationObserver
      ref="observer"
      slim
    >
      <form
        :disabled="$wait.is('updating profile informations')"
        class="flex flex-col mt-4"
        @submit.prevent="submitted"
      >
        <div
          class="flex flex-col md:flex-row mb-6"
        >
          <div class="text-gray-700 dark:text-gray-300">
            <h3
              v-text="$trans('settings.titles.profile_picture')"
              class="text-lg font-medium mb-2"
            />
            <div class="mb-3 border border-solid border-gray-300 dark:border-gray-600 rounded p-2">
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
            <ImageRules />
          </div>
          <div class="ml-8 flex-shrink-0 mb-4 md:mb-0">
            <AppAvatar
              v-if="previews[0]"
              :src="previews[0]"
              width="150"
              height="150"
            />
          </div>
        </div>
        <div class="flex flex-col mb-4 md:mb-0 lg:w-2/3">

          <!-- Profile informations -->
          <h3
            v-text="$trans('settings.titles.profile_infos')"
            class="text-lg text-gray-700 dark:text-white font-medium mb-2"
          />

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
                class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
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
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
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
                  class="text-left text-gray-700 dark:text-gray-300 text-base mb-1"
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
  import ImageRules from '@/components/ImageRules/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import { User } from '~/types/user'
  import useWait from '~/composables/useWait'
  import useAxios from '~/composables/useAxios'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'
  import useFileChange from '~/composables/useFileChange'

  export default defineComponent({
    components: {
      AppAvatar,
      ImageRules
    },
    setup (props, { refs }) {
      const axios = useAxios()
      const wait = useWait()
      const accessor = useAccessor()
      const trans = useICU()
      const toasted = useToasted()

      const { avatar_url, username, last_name, first_name } = accessor.getAuthUser as User

      const { previews, fileChange, files, clear } = useFileChange(avatar_url)

      const formData: Ref<{
        username: string,
        first_name: string,
        last_name: string
      }> = ref({
        username,
        first_name,
        last_name
      })

      function updateProfile (data: FormData, loader: string): Promise<any> {
        wait.start(loader)
        return axios.put('/me/profile', data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
          .then((res) => {
            clear()
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

            if (files.value && files.value[0]) data.append('avatar', files.value[0])

            updateProfile(data, 'updating profile picture')
          })
      }

      return {
        files,
        fileChange,
        submitted,
        previews,
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
