<template>
  <main>
    <div class="settings-hero">
      <div class="container mx-auto">
        <div class="flex items-center justify-between py-8">
          <h1
            class="text-3xl text-white leading-tight mb-4"
            v-text="$trans('settings.titles.main')"
          />
        </div>
      </div>
    </div>
    <div class="settings-container">
      <div class="container mx-auto flex flex-col md:flex-row items-start">
        <nav class="bg-white flex rounded-lg w-full md:w-3/12 mr-8 p-4 mb-4 md:mb-0">
          <ul class="w-full flex md:flex-col">
            <li
              v-for="(link, k) in links"
              :key="k"
              class="mr-2 md:mr-0 md:mb-2"
            >
              <nuxt-link
                :to="link.to"
                :active-class="'router-link-active bg-gray-200'"
                class="hover:bg-gray-200 rounded p-2 w-full flex"
                v-text="link.name"
              />
            </li>
          </ul>
        </nav>
        <section class="bg-white w-full md:w-9/12 h-56 rounded-lg p-6">
          <nuxt />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent, readonly } from '@nuxtjs/composition-api'
  import useICU from '~/composables/useICU'

  export default defineComponent({
    middleware: ['authenticated'],
    setup () {
      const trans = useICU()

      const links = readonly([
        {
          to: {
            name: 'SettingsProfile',
          },
          name: trans('settings.titles.profile')
        },
        {
          to: {
            name: 'SettingsAccount',
          },
          name: trans('settings.titles.account')
        },
        {
          to: {
            name: 'SettingsNotifications',
          },
          name: trans('settings.titles.notifications')
        }
      ])

      return {
        links
      }
    }
  })
</script>

<style scoped>
  .settings-hero {
    height: 300px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
  }

  .settings-container {
    margin-top: -180px;
  }
</style>
