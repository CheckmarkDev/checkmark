<template>
  <div class="flex flex-col border border-solid border-gray-300 rounded-lg p-4">
    <div class="flex">
      <!-- <div class="w-16">
        <div>
          check
        </div>
      </div> -->
      <div class="flex flex-col flex-1">
        <div>
          <div class="font-medium text-lg">
            {{ task.user.first_name }} {{ task.user.last_name }}
          </div>
        </div>
        <div>
          @{{ task.user.username }}
        </div>
      </div>
      <div>
        il y a 30 minutes
      </div>
    </div>
    <div>
      <div>
        <p>
          {{ task.content }}
        </p>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    props: {
      task: {
        type: Object,
        required: true
      }
    }
  })
</script>
