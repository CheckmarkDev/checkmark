<template>
  <div>
    <h3
      v-text="$trans('project.titles.informations')"
      class="text-lg text-gray-700 dark:text-white font-medium mb-2"
    />

    <!-- <ValidationObserver
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
    </ValidationObserver> -->
  </div>
</template>

<script lang="ts">
  import { defineComponent, onMounted, Ref, ref, useContext, useRoute } from '@nuxtjs/composition-api'

  import AppAvatar from '@/components/AppAvatar/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import { User } from '~/types/user'
  import useWait from '~/composables/useWait'
  import useAxios from '~/composables/useAxios'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'

  export default defineComponent({
    setup (props, { refs }) {
      const { parent } = useContext()
      const axios = useAxios()
      const wait = useWait()
      const accessor = useAccessor()
      const trans = useICU()
      const toasted = useToasted()
      const route = useRoute()

      onMounted(() => {
        console.log('parent on mounted', parent)
      })

      // const { avatar_url, username, last_name, first_name } = accessor.getAuthUser as User

      const formData: Ref<{
        name: string,
        slug: string,
        description: string,
        url: string
      }> = ref({
        name: '',
        slug: '',
        description: '',
        url: ''
      })

      function updateProject (data: FormData, loader: string): Promise<any> {
        const { slug } = route

        wait.start(loader)
        return axios.put(`/me/projects/${slug}`, data, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
          .then((res) => {
            toasted.success(trans('project.paragraphs.updated'))

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

            const { name, slug, description, url } = formData.value

            updateProfile({
              name,
              slug,
              description,
              url
            }, 'updating project informations')
          })
      }

      return {
        submitted,
        formData
      }
    },
    mounted () {
      console.log('parent', this.$parent)
    },
    head () {
      const title = this.$trans('project.titles.informations')

      return {
        title,
        meta: [
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>

