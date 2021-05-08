<template>
  <picture
    class="app-avatar rounded-full"
  >
    <img
      :src="src"
      :alt="alt"
      class="rounded-full"
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
