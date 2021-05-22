<template>
  <main>
    <div class="project-hero">
      <div class="container mx-auto">
        <div class="flex items-center justify-between py-8 w-full">
          <div
            v-if="$accessor.project.getProject"
            class="w-full md:w-2/3 flex flex-col md:flex-row md:items-center"
          >
            <AppAvatar
              :src="$accessor.project.getProject.avatar_url"
              :width="96"
              :height="96"
              class="mr-8 flex-shrink-0 self-start md:self-center mb-2 md:mb-0"
            />
            <div>
              <h1
                class="text-3xl text-white leading-tight truncate mb-2"
                v-text="$accessor.project.getProject.name"
              />
              <p
                v-text="$accessor.project.getProject.description"
                class="text-gray-200"
              />
              <ul
                v-if="$accessor.project.getProject.url"
                class="mt-2"
              >
                <li>
                  <a
                    :href="$accessor.project.getProject.url"
                    v-text="$accessor.project.getProject.url"
                    rel="noopener nofollow"
                    target="_blank"
                    class="text-gray-200 hover:underline"
                  />
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="project-container">
      <div class="container mx-auto flex items-start">
        <ProjectSideNavigation />
        <section class="bg-white dark:bg-gray-700 dark:text-white w-full md:w-9/12 rounded-lg p-6">
          <nuxt />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import ProjectSideNavigation from '@/components/Project/ProjectSideNavigation/index.vue'
  import AppAvatar from '@/components/AppAvatar/index.vue'

  export default defineComponent({
    components: {
      ProjectSideNavigation,
      AppAvatar
    },
    middleware: [async ({ route, $accessor }) => {
      const { slug } = route.params
      await Promise.all([
        $accessor.project.retrieveProject(slug)
      ])
    }],
    head () {
      const project = this.$accessor.project.getProject

      return {
        title: project.name,
        meta: [
          { hid: 'description', name: 'description', content: project.description },
          { hid: 'og:description', property: 'og:description', content: project.description },
          { hid: 'og:title', property: 'og:title', content: project.name },
          {
            hid: 'og:image:width', name: 'og:image:width', content: '1200'
          },
          {
            hid: 'og:image:height', name: 'og:image:height', content: '628'
          },
          {
            hid: 'og:image:type', name: 'og:image:type', content: 'image/png'
          }
        ]
      }
    }
  })
</script>

<style scoped>
  .project-hero {
    min-height: 320px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
    padding-bottom: 180px;

    @screen md {
      min-height: 400px;
    }
  }
  .project-hero__avatar {
    width: 80px;
    height: 80px;
  }

  .project-container {
    margin-top: -180px;
  }
</style>

<style>
  .project-hero__avatar img{
    width: 80px;
    height: 80px;
  }
</style>
