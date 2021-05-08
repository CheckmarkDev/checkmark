<template>
  <div class="user-avatar w-12 h-12 rounded-full bg-gray-300 relative">
    <AppAvatar
      :src="user.avatar_url"
      width="48"
      height="48"
    />
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
  import AppAvatar from '@/components/AppAvatar/index.vue'

  export default defineComponent({
    components: {
      Streak,
      AppAvatar
    },
    props: {
      user: {
        type: Object as () => User,
        required: true
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
