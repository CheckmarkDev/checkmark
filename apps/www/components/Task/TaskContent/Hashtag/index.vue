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
      class="inline text-blue-600 font-medium whitespace-no-wrap"
      @mouseenter.native="togglePopup(true)"
      @mouseleave.native="togglePopup(false)"
    />

    <div
      v-show="isVisible"
      ref="tooltip"
      class="project-tooltip flex items-center bg-white rounded p-3 shadow-lg border border-gray-200"
    >
      <div class="w-10 h-10 rounded-full bg-gray-300 mr-3"></div>
      <div class="flex flex-col">
        <div
          v-text="project.name"
          class="font-medium text-base text-gray-800"
        />
        <div
          v-text="project.url"
          class="text-sm text-gray-700"
        />
      </div>
    </div>
  </span>
</template>

<script lang="ts">
  import { createPopper } from '@popperjs/core'
  import { defineComponent } from '@nuxtjs/composition-api'
  import { Project } from '~/types/project'

  export default defineComponent({
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
