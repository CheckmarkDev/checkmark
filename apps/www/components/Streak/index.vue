<template>
  <div class="streak flex items-center bg-gray-200 rounded-full">
    <div
      v-text="emoji"
      class="text-xs mr-2"
    />
    <div
      v-text="streak"
      class="font-medium text-xs text-gray-800"
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
        if (streak.value > 3 && streak.value <= 21) return '🚀'
        return '🔥'
      })

      return {
        emoji
      }
    }
  })
</script>

<style scoped>
  .streak {
    padding: 2px 4px;
  }
</style>
