<template>
  <nuxt-link
    :to="{
      name: 'RoadmapProject',
      params: {
        slug: slug
      }
    }"
    class="roadmap-item flex md:flex-col rounded-lg p-4"
  >
    <div class="flex items-center justify-center bg-white rounded-full w-12 h-12 md:w-20 md:h-20 relative mb-4 flex-shrink-0 mr-4 md:mr-0">
      <img
        :src="formattedIcon"
        alt=""
        width="60"
        height="60"
      >
      <TaskCheck
        :state="state"
        class="absolute bottom-0 right-0 bg-white rounded-full p-1"
      />
    </div>
    <div class="flex flex-col">
      <div
        v-text="title"
        class="font-medium text-lg mb-1"
      />
      <p
        v-text="description"
      />
    </div>
  </nuxt-link>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { TaskState } from '~/types/task'
  import TaskCheck from '@/components/TaskCheck/index.vue'

  export default defineComponent({
    components: {
      TaskCheck
    },
    props: {
      slug: {
        type: String,
        required: true
      },
      icon: {
        type: String,
        required: true
      },
      title: {
        type: String,
        required: true
      },
      description: {
        type: String,
        required: true
      },
      state: {
        type: String,
        required: true
      }
    },
    computed: {
      formattedIcon (): string {
        return require(`@/assets/img/icons/emojis/${this.icon}`)
      }
    }
  })
</script>

<style>
  .roadmap-item {
    transition: background 200ms;
  }

  .roadmap-item:not(.roadmap-item.router-link-active):hover {
    @apply bg-white bg-opacity-25;
  }

  .roadmap-item:not(.roadmap-item.router-link-active) {
    @apply text-white;
  }

  .roadmap-item.router-link-active {
    @apply bg-white text-gray-900;
  }
</style>
