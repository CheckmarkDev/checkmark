<template>
  <div class="mt-1">
    <component
      v-for="(block, k) in blocks"
      :key="k"
      :is="block.type === 'text' ? 'span' : 'Hashtag'"
      :project="block.project"
    >
      <template
        v-if="block.type === 'text'"
      >
        {{ block.content }}
      </template>
    </component>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { Task } from '~/types/task'
  import Hashtag from './Hashtag/index.vue'

  export default defineComponent({
    components: {
      Hashtag
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    computed: {
      blocks () {
        const { content } = this.task
        const parts: Array<{
          type: string
          content: string
          project?: any
        }> = []

        if (this.task.projects.length === 0) {
          parts.push({
            type: 'text',
            content
          })

          return parts
        }

        const hashtags = [...content.match(/(#\w+)/gm)]
        let index = 0
        if (hashtags.length === 0) {
          parts.push({
            type: 'text',
            content
          })

          return parts
        }

        hashtags.forEach(hashtag => {
          const project = this.task.projects.find(project => project.slug === hashtag[0].replace('#', ''))
          parts.push({
            type: 'text',
            content: content.slice(index, index + hashtag.index).replace(/(#\w+)/gm, '')
          })

          if (project) {
            parts.push({
              type: 'hashtag',
              content: content.slice(hashtag.index, hashtag.index + hashtag[0].length),
              project
            })
          } else {
            parts.push({
              type: 'text',
              content: content.slice(hashtag.index, hashtag.index + hashtag[0].length)
            })
          }

          index += hashtag.index + hashtag[0].length
        })

        parts.push({
          type: 'text',
          content: content.slice(index, -1)
        })

        return parts
      }
    }
  })
</script>
