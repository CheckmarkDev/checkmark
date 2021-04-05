<template>
  <div class="flex flex-col border border-solid border-gray-300 rounded-lg p-4">
    <div class="flex mb-2">
      <!-- <div class="w-16">
        <div>
          check
        </div>
      </div> -->
      <div class="flex flex-col flex-1 leading-tight">
        <nuxt-link
          :to="{
            name: 'User',
            params: {
              username: task.user.username
            }
          }"
        >
          <div class="font-medium text-lg">
            {{ task.user.first_name }} {{ task.user.last_name }}
          </div>
        </nuxt-link>
        <nuxt-link
          :to="{
            name: 'User',
            params: {
              username: task.user.username
            }
          }"
          class="text-base text-gray-600"
        >
          @{{ task.user.username }}
        </nuxt-link>
      </div>
      <div class="text-sm text-gray-600">
        {{ date }}
      </div>
    </div>
    <div>
      <div class="text-base text-gray-800">
        <p>
          {{ task.content }}
        </p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

  export default defineComponent({
    props: {
      task: {
        type: Object,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)

      const date = computed(() => {
        return dayjs(task.value.created_at).format('lll')
      })

      return {
        date
      }
    }
  })
</script>
