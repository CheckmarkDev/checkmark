<template>
  <div>
    <h2
      v-text="project.title"
      class="font-medium text-2xl mb-4"
    />
    <nuxt-content
      :document="project"
    />
  </div>
</template>

<script lang="ts">
  import { defineComponent, readonly, useContext } from '@nuxtjs/composition-api'

  export default defineComponent({
    data () {
      return {
        project: {}
      }
    },
    async asyncData ({ $content, route }) {
      const projects = await $content('roadmap').where({ slug: route.params.slug }).fetch()

      return {
        project: projects[0]
      }
    },
    head () {
      const title = this.project.title
      const description = this.project.description

      return {
        title,
        meta: [
          { hid: 'description', name: 'description', content: description },
          { hid: 'og:description', property: 'og:description', content: description },
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>

<style>
  .nuxt-content p {
    @apply mb-4;
  }

  .nuxt-content ul {
    @apply list-disc ml-1 mb-4;
  }

  .nuxt-content li {
    @apply ml-4 mb-1;
  }

  .nuxt-content h3 {
    @apply font-medium text-xl mb-2;
  }

  .nuxt-content a {
    @apply text-blue-600 underline;
  }

  .nuxt-content img {
    @apply mb-8 bg-gray-300;
  }
</style>
