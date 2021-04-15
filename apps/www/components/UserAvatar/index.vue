<template>
  <div class="user-avatar w-12 h-12 rounded-full bg-gray-300 relative">
    <Streak
      :streak="user.streak"
      class="absolute"
    />
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import { User } from '~/types/user'
  import Streak from '@/components/Streak/index.vue'

  export default defineComponent({
    components: {
      Streak
    },
    props: {
      user: {
        type: Object as () => User
      }
    }
  })
</script>

<style scoped>
  .user-avatar .streak {
    right: -0.5rem;
    bottom: -0.25rem;
  }
</style>
