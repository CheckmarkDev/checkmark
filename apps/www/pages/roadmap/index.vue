<template>
  <div>
    <div class="home-hero">
      <div class="container mx-auto">
        <div class="flex flex-col md:flex-row md:items-center justify-between py-8">
          <div class="md:w-1/2">
            <h1
              class="text-4xl font-medium text-white leading-tight mb-4"
              v-text="$trans('roadmap.titles.main')"
            />
            <h2
              class="text-2xl text-gray-300"
              v-text="$trans('roadmap.paragraphs.main')"
            />
          </div>
        </div>
      </div>
      <div class="relative roadmap__timeline">
        <div class="container mx-auto pb-8">
          <div class="flex flex-col md:flex-row items-start">
            <RoadmapItem
              v-for="(item, k) in projects"
              :key="k"
              :slug="item.slug"
              :icon="item.icon"
              :title="item.title"
              :description="item.description"
              :state="item.state"
              class="md:w-1/4 z-10"
            />
          </div>
        </div>
      </div>
    </div>
    <div class="home-container">
      <div class="container mx-auto flex items-start">
        <SideNavigation />
        <section class="bg-white rounded-lg w-full md:w-9/12 p-6 pb-32">
          <nuxt />
        </section>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, readonly, useContext } from '@nuxtjs/composition-api'

  import RoadmapItem from '@/components/Roadmap/RoadmapItem/index.vue'
  import SideNavigation from '@/components/Home/SideNavigation/index.vue'

  export default defineComponent({
    components: {
      RoadmapItem,
      SideNavigation
    },
    data () {
      return {
        projects: [] as Array<any>
      }
    },
    async asyncData ({ $content }) {
      const projects = await $content('roadmap').sortBy('createdAt', 'asc').fetch()

      return {
        projects
      }
    },
    head () {
      const title = this.$trans('roadmap.titles.main')
      const description = this.$trans('roadmap.paragraphs.description')

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

<style scoped>
  .roadmap__timeline::before {
    @screen md {
      @apply absolute w-full h-2 bg-blue-600 z-0;

      content: '';
      top: 55px;
    }
  }

  .home-hero {
    min-height: 320px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
    padding-bottom: 100px;

    @screen md {
      min-height: 400px;
      padding-bottom: 180px;
    }
  }

  .home-container {
    margin-top: -100px;

    @screen md {
      margin-top: -180px;
    }
  }

  .roadmap-item:not(:last-child) {
    @screen md {
      @apply mr-4;
    }
  }
</style>
