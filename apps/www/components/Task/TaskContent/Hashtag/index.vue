<template>
  <span>
    <nuxt-link
      ref="hashtag"
      :to="{
        name: 'Project',
        params: {
          slug: project.slug
        }
      }"
      v-text="`#${project.slug}`"
      class="inline text-blue-600 dark:text-white dark:bg-gray-600 bg-blue-400 bg-opacity-10 p-1 rounded font-medium whitespace-no-wrap"
      @mouseenter.native="togglePopup(true)"
      @mouseleave.native="togglePopup(false)"
    />

    <div
      v-show="isVisible"
      ref="tooltip"
      class="project-tooltip flex items-center bg-white dark:bg-gray-600 rounded p-3 shadow-lg border border-gray-200 dark:border-gray-600"
    >
      <AppAvatar
        :src="project.avatar_url"
        :width="40"
        :height="40"
        class="mr-3"
      />
      <div class="flex flex-col">
        <div
          v-text="project.name"
          class="font-medium text-base text-gray-800 dark:text-white"
        />
        <div
          v-if="project.url"
          v-text="project.url"
          class="text-sm text-gray-700 dark:text-gray-300"
        />
      </div>
    </div>
  </span>
</template>

<script lang="ts">
  import { createPopper } from '@popperjs/core'
  import { defineComponent } from '@nuxtjs/composition-api'
  import { Project } from '~/types/project'
  import AppAvatar from '@/components/AppAvatar/index.vue'

  export default defineComponent({
    components: {
      AppAvatar
    },
    props:  {
      project: {
        type: Object as () => Project,
        required: true
      }
    },
    data () {
      return {
        tooltipInstance: null,
        isVisible: false
      }
    },
    mounted () {
      this.tooltipInstance = createPopper(this.$refs.hashtag.$el, this.$refs.tooltip, {
        placement: 'top',
      })
    },
    methods: {
      togglePopup (v) {
        this.isVisible = v
        if (this.tooltipInstance) {
          this.tooltipInstance.update()
        }
      }
    }
  })
</script>
