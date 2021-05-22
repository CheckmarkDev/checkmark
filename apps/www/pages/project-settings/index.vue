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
      <div class="container mx-auto flex flex-col md:flex-row items-start">
        <ProjectSideNavigation
          class="flex-1"
        />
        <div
          class="flex flex-col w-full md:w-9/12"
        >
          <ProjectSettingsSideNavigation />
          <section class="bg-white dark:bg-gray-700 dark:text-white rounded-lg p-6">
            <nuxt />
          </section>
        </div>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import ProjectSideNavigation from '@/components/Project/ProjectSideNavigation/index.vue'
  import ProjectSettingsSideNavigation from '@/components/Project/ProjectSettingsSideNavigation/index.vue'
  import AppAvatar from '@/components/AppAvatar/index.vue'

  export default defineComponent({
    middleware: ['authenticated', async ({ route, $accessor }) => {
      const { slug } = route.params
      await Promise.all([
        $accessor.project.retrieveProject(slug)
      ])
    }],
    components: {
      ProjectSideNavigation,
      ProjectSettingsSideNavigation,
      AppAvatar
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
