<template>
  <div>
    <h2
      v-text="$trans('project.titles.informations')"
      class="text-2xl dark:text-white font-medium mb-6"
    />

    <ValidationObserver
      ref="observer"
    >
      <form
        :disabled="$wait.is('updating project informations')"
        @submit.prevent="submitted"
      >
        <div class="flex flex-col">
          <div
            class="flex flex-col md:flex-row mb-6"
          >
            <div class="text-gray-700 dark:text-gray-300">
              <h3
                v-text="$trans('project.titles.logo')"
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

          <div
            class="md:w-2/3 md:mr-8"
          >
            <h3
              v-text="$trans('project.titles.informations')"
              class="text-lg text-gray-700 dark:text-white font-medium mb-6"
            />

            <ValidationProvider
              ref="name-provider"
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
              ref="slug-provider"
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
              ref="description-provider"
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
              ref="url-provider"
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
  import { defineComponent, Ref, ref, useRoute } from '@nuxtjs/composition-api'

  import ImageRules from '@/components/ImageRules/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import useWait from '~/composables/useWait'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'
  import useFileChange from '~/composables/useFileChange'
  import { Project } from '~/types/project'

  export default defineComponent({
    components: {
      ImageRules
    },
    setup (props, { refs }) {
      const wait = useWait()
      const accessor = useAccessor()
      const trans = useICU()
      const toasted = useToasted()

      const { name, slug, description, url, avatar_url } = accessor.project.getProject as Project

      const { previews, fileChange, files, clear } = useFileChange(avatar_url)

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

      function updateProject (data: any, loader: string): Promise<any> {
        wait.start(loader)
        return accessor.project.updateProject({ slug, data })
          .then(() => {
            clear()
            toasted.success(trans('project.paragraphs.updated'))
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
              url,
              avatar: files.value[0]
            }, 'updating project informations')
          })
      }

      return {
        previews,
        fileChange,
        submitted,
        formData
      }
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

