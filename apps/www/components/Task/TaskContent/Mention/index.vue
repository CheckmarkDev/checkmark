<template>
  <span>
    <nuxt-link
      ref="mention"
      :to="{
        name: 'User',
        params: {
          username: mention.username
        }
      }"
      v-text="`@${mention.username}`"
      class="inline text-blue-600 dark:text-white dark:bg-gray-600 p-1 font-medium whitespace-no-wrap"
      @mouseenter.native="togglePopup(true)"
      @mouseleave.native="togglePopup(false)"
    />

    <div
      v-show="isVisible"
      ref="tooltip"
      class="project-tooltip flex items-center bg-white rounded p-3 shadow-lg border border-gray-200 dark:bg-gray-600 dark:border-gray-600"
    >
      <AppAvatar
        :src="mention.avatar_url"
        :width="40"
        :height="40"
        class="mr-3"
      />
      <div class="flex flex-col">
        <div
          v-text="`${mention.first_name} ${mention.last_name}`"
          class="font-medium text-base text-gray-800 dark:text-white"
        />
        <div
          v-text="`@${mention.username}`"
          class="text-sm text-gray-700 dark:text-gray-300"
        />
      </div>
    </div>
  </span>
</template>

<script lang="ts">
  import { createPopper } from '@popperjs/core'
  import { defineComponent } from '@nuxtjs/composition-api'
  import AppAvatar from '@/components/AppAvatar/index.vue'
  import { User } from '~/types/user'

  export default defineComponent({
    components: {
      AppAvatar
    },
    props:  {
      mention: {
        type: Object as () => User,
        required: true
      }
    },
    data () {
      return {
        tooltipInstance: null,
        isVisible: false
      } as {
        tooltipInstance: any,
        isVisible: boolean
      }
    },
    mounted () {
      this.tooltipInstance = createPopper(this.$refs.mention.$el, this.$refs.tooltip, {
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
