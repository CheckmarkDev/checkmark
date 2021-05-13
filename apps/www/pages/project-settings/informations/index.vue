<template>
  <div>
    <h3
      v-text="$trans('project.titles.informations')"
      class="text-lg text-gray-700 dark:text-white font-medium mb-2"
    />

    <ValidationObserver
      ref="observer"
    >
      <form
        :disabled="$wait.is('updating project informations')"
        @submit.prevent="submitted"
      >
        <div class="flex flex-col md:flex-row">
          <div
            class="md:w-1/2 md:mr-8"
          >
            <ValidationProvider
              rules="required"
              :name="$trans('project.labels.name').toLowerCase()"
              v-slot="{ errors, invalid, dirty }"
              tag="div"
              class="flex flex-col mb-4"
            >
              <label
                for="project-name"
                v-text="`${$trans('project.labels.name')} *`"
                class="mb-2"
              />
              <input
                v-model="formData.name"
                :class="{
                  'input--invalid': errors.length || (invalid && dirty)
                }"
                type="text"
                name="project-name"
                id="project-name"
                class="input"
                required
              >
              <div
                v-if="errors.length || (invalid && dirty)"
                v-text="errors[0]"
                class="text-red-600 text-sm"
              />
            </ValidationProvider>

            <ValidationProvider
              rules="required|min:2|max:32"
              :name="$trans('project.labels.slug').toLowerCase()"
              v-slot="{ errors, invalid, dirty }"
              tag="div"
              class="flex flex-col mb-4"
            >
              <label
                for="slug"
                v-text="`${$trans('project.labels.slug')} *`"
                class="mb-2"
              />
              <input
                v-model="formData.slug"
                :class="{
                  'input--invalid': errors.length || (invalid && dirty)
                }"
                type="text"
                name="slug"
                id="slug"
                class="input"
                required
              >
              <div
                v-text="$trans('global.paragraphs.max_chars', {
                  chars: 32
                })"
                class="text-gray-600 dark:text-gray-400 text-sm"
              />
              <div
                v-if="errors.length || (invalid && dirty)"
                v-text="errors[0]"
                class="text-red-600 text-sm"
              />
            </ValidationProvider>

            <ValidationProvider
              rules="max:255"
              :name="$trans('project.labels.description').toLowerCase()"
              v-slot="{ errors, invalid, dirty }"
              tag="div"
              class="flex flex-col mb-4"
            >
              <label
                for="description"
                v-text="$trans('project.labels.description')"
                class="mb-2"
              />
              <textarea
                v-model="formData.description"
                :class="{
                  'textarea--invalid': errors.length || (invalid && dirty)
                }"
                name="description"
                id="description"
                class="textarea"
              ></textarea>
              <div
                v-text="$trans('global.paragraphs.max_chars', {
                  chars: 255
                })"
                class="text-gray-600 dark:text-gray-400 text-sm"
              />
              <div
                v-if="errors.length || (invalid && dirty)"
                v-text="errors[0]"
                class="text-red-600 text-sm"
              />
            </ValidationProvider>


            <ValidationProvider
              :name="$trans('project.labels.url').toLowerCase()"
              v-slot="{ errors, invalid, dirty }"
              tag="div"
              class="flex flex-col mb-4"
            >
              <label
                for="url"
                v-text="$trans('project.labels.url')"
                class="mb-2"
              />
              <input
                v-model="formData.url"
                :class="{
                  'input--invalid': errors.length || (invalid && dirty)
                }"
                type="url"
                name="url"
                id="url"
                class="input"
              >
              <div
                v-if="errors.length || (invalid && dirty)"
                v-text="errors[0]"
                class="text-red-600 text-sm"
              />
            </ValidationProvider>
          </div>
        </div>
        <div>
          <button
            :disabled="$wait.is('updating project informations')"
            type="submit"
            class="btn btn-primary"
            v-text="$trans('global.buttons.save')"
          />
        </div>
      </form>
    </ValidationObserver>
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
import { Project } from '~/types/project'

  export default defineComponent({
    setup (props, { refs }) {
      const axios = useAxios()
      const wait = useWait()
      const accessor = useAccessor()
      const trans = useICU()
      const toasted = useToasted()
      const route = useRoute()

      const { name, slug, description, url } = accessor.project.getProject as Project

      const formData: Ref<{
        name: string,
        slug: string,
        description: string,
        url: string
      }> = ref({
        name,
        slug,
        description,
        url
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

            updateProject({
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

