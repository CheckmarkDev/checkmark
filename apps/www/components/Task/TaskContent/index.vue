<template>
  <div class="mt-1 dark:text-white">
    <component
      v-for="(block, k) in blocks"
      :key="k"
      :is="block.type === 'text'
        ? 'span'
        : block.type === 'mention'
          ? 'Mention' : 'Hashtag'"
      :project="block.project"
      :mention="block.mention"
      class="whitespace-pre"
    >
      <template
        v-if="block.type === 'text'"
      >
        <span
          v-html="block.content"
        />
      </template>
    </component>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { Task } from '~/types/task'
  import Hashtag from './Hashtag/index.vue'
  import Mention from './Mention/index.vue'

  export default defineComponent({
    components: {
      Hashtag,
      Mention
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    computed: {
      blocks () {
        const { projects, mentions, content } = this.task
        const parts: Array<{
          type: string
          content: string
          project?: any,
          mention?: any
        }> = []


        /**
         * If there are no projects or mentions associated to this task
         * consider that there is no hashtag or mention to be computed.
         * Return just plain text.
         */
        if ((projects && projects.length === 0) && (mentions && mentions.length === 0)) {
          parts.push({
            type: 'text',
            content
          })

          return parts
        }

        const tagRegx = /([#|@]([\w|\-]*))/gm
        const tags = [...content.matchAll(tagRegx)]

        /**
         * No hashtag or at found, return plain text.
         */
        if (tags.length === 0) {
          parts.push({
            type: 'text',
            content
          })

          return parts
        }

        let index = 0
        tags.forEach(tag => {
          parts.push({
            type: 'text',
            content: content.slice(index, tag.index).replace(tagRegx, '')
          })

          const isMention = tag[0].startsWith('@')
          if (isMention) {
            const mention = mentions && mentions
              .find(mention => mention.username === tag[0].replace('@', ''))

            if (mention) {
              parts.push({
                type: 'mention',
                content: content.slice(tag.index, tag.index + tag[0].length),
                mention
              })
            }
          } else {
            const project = projects && projects
              .find(project => project.slug === tag[0].replace('#', ''))

            if (project) {
              parts.push({
                type: 'hashtag',
                content: content.slice(tag.index, tag.index + tag[0].length),
                project
              })
            }
          }

          index = tag.index + tag[0].length
        })

        parts.push({
          type: 'text',
          content: content.slice(index)
        })

        return parts
      }
    }
  })
</script>
