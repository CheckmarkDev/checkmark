<template>
  <div class="task-image-edition">
    <div
      class="flex flex-col border border-gray-300 dark:border-gray-600 border-solid rounded p-2 mb-4"
    >
      <label
        for="file"
        class="text-sm text-gray-700 dark:text-gray-300 mb-2"
      >
        {{ $trans('home.labels.images') }}
      </label>
      <input
        id="file"
        ref="files"
        type="file"
        name="images[]"
        accept="image/*"
        multiple
        @change="fileChange"
      >
    </div>
    <div class="flex flex-wrap -m-2">
      <div
        v-for="image in images"
        :key="image.uuid"
        class="task-image-edition__image m-2"
      >
        <img
          v-lazy="image.thumbnail_url"
          alt=""
          class="rounded-tl rounded-tr border border-gray-300 dark:border-gray-600 border-b-0"
        >
        <div class="flex border border-gray-300 dark:border-gray-600 rounded-bl rounded-br p-1">
          <button
            type="button"
            class="btn btn-danger btn-sm w-full"
            @click="$emit('remove', image)"
          >
            {{ $trans('global.buttons.delete') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, watch, toRefs } from '@nuxtjs/composition-api'

  import useFileChange from '@/composables/useFileChange'

  export default defineComponent({
    props: {
      images: {
        type: Array,
        required: true
      }
    },
    setup (props, { emit }) {
      const { images } = toRefs(props)
      const { fileChange, files, previews } = useFileChange()

      watch(files, (v) => {
        const filePromises = []
        Array.from(v).forEach(file => {
          const filePromise = new Promise(resolve => {
            const reader = new FileReader()
            reader.onload = e => {
              if (e.target && e.target.result) {
                resolve({
                  file,
                  thumbnail_url: e.target.result as string
                })
              }
            }

            reader.readAsDataURL(file)
          })

          filePromises.push(filePromise)
        })

        Promise.all(filePromises)
          .then(files => {
            emit('update:images', [
              ...images.value,
              ...files
            ])
          })
      })

      return {
        fileChange,
        files,
        previews
      }
    }
  })
</script>

<style scoped>
  .task-image-edition__image {
    flex: 1 0 calc(31% - 1rem);
  }
</style>
