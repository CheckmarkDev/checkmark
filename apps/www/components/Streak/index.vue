<template>
  <div class="streak flex items-center bg-gray-200 rounded-full px-2 py-1">
    <div
      v-text="emoji"
      class="text-sm mr-2"
    />
    <div
      v-text="streak"
      class="font-medium text-sm text-gray-800"
    />
  </div>
</template>

<script lang="ts">
  import { defineComponent, toRefs, computed } from '@nuxtjs/composition-api'

  export default defineComponent({
    props: {
      streak: {
        type: Number,
        required: true
      }
    },
    setup (props) {
      const { streak } = toRefs(props)
      const emoji = computed(() => {
        if (streak.value === 0) return '😔'
        if (streak.value > 0 && streak.value <= 2) return '😀'
        return '🚀'
      })

      return {
        emoji
      }
    }
  })
</script>
