<template>
  <div>
    <h2
      v-text="$trans('project.titles.images')"
      class="text-2xl dark:text-white font-medium mb-6"
    />

    <ValidationObserver
      ref="observer"
    >
      <form
        :disabled="$wait.is('adding project images')"
        @submit.prevent="submitted"
      >
        <h3
          v-text="$trans('project.titles.images.upload')"
          class="text-lg font-medium mb-2 text-gray-700 dark:text-white "
        />
        <div class="flex flex-col md:flex-row w-full mb-4 md:mb-0">
          <div class="mb-3 border border-solid border-gray-300 dark:border-gray-600 rounded p-2 flex-1 md:mr-4">
            <ValidationProvider
              ref="screenshots-provider"
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
                multiple
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
          <button
            :disabled="$wait.is('adding project images')"
            type="submit"
            class="btn btn-primary"
            v-text="$trans('global.buttons.upload')"
          />
        </div>
        <div
          v-if="previews.length"
          class="images__previews flex flex-wrap -m-2 mb-4"
        >
          <div
            v-for="(preview, k) in previews"
            :key="k"
            class="m-2"
          >
            <img
              :src="preview"
              alt=""
              class="object-cover w-full border border-gray-300 rounded"
            >
          </div>
        </div>
        <div
          v-if="!previews.length"
          class="text-gray-700 dark:text-gray-300 md:w-2/3"
        >
          <ImageRules />
        </div>
      </form>
    </ValidationObserver>

    <div>
      <h3
        v-text="$trans('project.titles.images.my_images')"
        class="text-lg font-medium mb-2 text-gray-700 dark:text-white "
      />
      <template
        v-if="$accessor.project.getProject.screenshots.length"
      >
        <div
          class="flex flex-wrap -m-4"
        >
          <ProjectSettingsScreenshot
            v-for="(image, k) in $accessor.project.getProject.screenshots"
            :key="k"
            :screenshot="image"
            :project="$accessor.project.getProject"
            class="m-4"
          />
        </div>
      </template>
      <template
        v-else
      >
        <p
          v-text="$trans('project.paragraphs.no_screenshots')"
        />
      </template>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, Ref, ref, useRoute } from '@nuxtjs/composition-api'

  import ImageRules from '@/components/ImageRules/index.vue'
  import ProjectSettingsScreenshot from '@/components/Project/ProjectSettingsScreenshot/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import useWait from '~/composables/useWait'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'
  import useFileChange from '~/composables/useFileChange'
  import useValidationProvider from '~/composables/useValidationProvider'
  import { Project } from '~/types/project'

  export default defineComponent({
    components: {
      ImageRules,
      ProjectSettingsScreenshot
    },
    setup (props, { refs }) {
      const wait = useWait()
      const accessor = useAccessor()
      const trans = useICU()
      const toasted = useToasted()
      const route = useRoute()

      const { previews, fileChange, files, clear } = useFileChange()

      function submitted () {
        // @ts-ignore
        refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            wait.start('adding project images')
            accessor.project.addImages({ slug: route.value.params.slug, images: files.value })
              .then(() => {
                clear()
                toasted.success(trans('project.paragraphs.updated'))
              })
              .catch(err => {
                if (!err.response) return

                useValidationProvider(err, refs)
              })
              .finally(() => {
                wait.end('adding project images')
              })
          })
      }

      return {
        previews,
        fileChange,
        submitted,
      }
    },
    head () {
      const title = this.$trans('project.titles.images')

      return {
        title,
        meta: [
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>

<style scoped>
  .project-settings-screenshot {
    flex: 1 0 calc(31% - 1rem);
  }
</style>

<style>
  .images__previews > div {
    flex: 1 0 calc(31% - 16px);
  }

  .images__previews > div img {
    height: fit-content;
    max-height: 160px;
  }
</style>
