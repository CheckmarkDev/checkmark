<template>
  <div class="flex flex-col border border-solid border-gray-300 rounded-lg p-4">
    <div class="flex mb-2">
      <div class="w-16">
        <div class="w-12 h-12 rounded-full bg-gray-300 relative">
          <task-check
            :state="task.state"
            class="absolute bottom-0 right-0 bg-white rounded-full"
          />
        </div>
      </div>
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
      <nuxt-link
        :to="{
          name: 'Task',
          params: {
            username: task.user.username,
            task: task.uuid
          }
        }"
        class="text-sm text-gray-600 truncate flex-shrink hover:underline"
      >
        {{ date }}
      </nuxt-link>
    </div>
    <div>
      <div class="task__content text-base text-gray-800">
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

  import TaskCheck from '@/components/TaskCheck/index.vue'

  export default defineComponent({
    components: {
      TaskCheck
    },
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

<style scoped>
  .task__content {
    padding-left: 64px;
  }
</style>
