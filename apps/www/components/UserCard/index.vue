<template>
  <div class="user-card flex items-center">
    <div class="w-16 flex-shrink-0">
      <UserAvatar
        :user="user"
      />
    </div>
    <div class="user-card__name flex flex-col flex-1 leading-tight truncate">
      <div
        v-text="`${user.fullName}`"
        class="font-medium text-lg truncate mr-4"
      />
      <div
        v-text="`@${user.username}`"
        class="text-base text-gray-600 dark:text-gray-300 truncate"
      />
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import UserAvatar from '@/components/UserAvatar/index.vue'
  import { User } from '~/types/user'

  export default defineComponent({
    components: {
      UserAvatar
    },
    props: {
      user: {
        type: Object as () => User,
        required: true
      }
    }
  })
</script>

