<template>
  <div class="absolute flex flex-wrap justify-center mt-10 z-0">
    <div
      v-for="user in users"
      :key="user.user.uuid"
      class="w-1/3 mb-4"
    >
      <UserAvatar
        :user="user.user"
        :width="user.size"
        :height="user.size"
      />
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@vue/composition-api'

  import UserAvatar from '@/components/UserAvatar/index.vue'

  export default defineComponent({
    components: {
      UserAvatar
    },
    props: {
      users: {
        type: Array,
        required: true
      }
    }
  })
</script>

