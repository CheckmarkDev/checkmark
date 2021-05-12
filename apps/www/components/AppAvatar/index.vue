<template>
  <picture
    class="app-avatar rounded-full"
  >
    <img
      v-lazy="src"
      :alt="alt"
      :width="$attrs.width"
      :height="$attrs.height"
      :style="{
        width: `${$attrs.width}px`,
        height: `${$attrs.height}px`,
      }"
      class="rounded-full object-cover bg-gray-300 dark:bg-gray-700"
    >
  </picture>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    props: {
      src: {
        type: String,
        required: true
      },
      alt: {
        type: String,
        default: ''
      }
    }
  })
</script>
