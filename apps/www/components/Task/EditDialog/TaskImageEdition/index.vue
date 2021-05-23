<template>
  <div class="task-image-edition">
    <div>
    </div>
    <div class="flex flex-wrap -m-2">
      <div
        v-for="image in editableImages"
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
            @click="remove(image)"
          >
            {{ $trans('global.buttons.delete') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, ref, toRefs } from '@nuxtjs/composition-api'

  import Task from '@/types/task'

  export default defineComponent({
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)
      const editableImages = ref(Array.from(task.value.images))

      function remove (image) {
        const index = editableImages.value.findIndex(v => v === image)
        if (index !== -1) {
          editableImages.value.splice(index, 1)
        }
      }

      return {
        editableImages,
        remove
      }
    }
  })
</script>

<style scoped>
  .task-image-edition__image {
    flex: 1 0 calc(31% - 1rem);
  }
</style>
