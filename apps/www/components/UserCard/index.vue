<template>
  <div class="flex items-center mb-2">
    <div class="w-16">
      <UserAvatar
        :user="user"
      />
    </div>
    <div class="flex flex-col flex-1 leading-tight">
      <nuxt-link
        :to="{
          name: 'User',
          params: {
            username: user.username
          }
        }"
        class="mr-4"
      >
        <div class="font-medium text-lg">
          {{ user.first_name }} {{ user.last_name }}
        </div>
      </nuxt-link>
      <nuxt-link
        :to="{
          name: 'User',
          params: {
            username: user.username
          }
        }"
        class="text-base text-gray-600"
      >
        @{{ user.username }}
      </nuxt-link>
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

