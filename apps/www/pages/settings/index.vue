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
      <div class="container mx-auto flex items-start">
        <nav class="bg-white hidden md:flex rounded-lg w-3/12 mr-8 p-4">
          <ul class="w-full">
            <li>
              <nuxt-link
                :to="{
                  name: 'SettingsNotifications'
                }"
                class="hover:bg-gray-200 rounded p-2 w-full flex"
              >
                {{ $trans('settings.titles.notifications') }}
              </nuxt-link>
            </li>
          </ul>
        </nav>
        <section class="bg-white w-full h-56 rounded-lg p-6">
          <nuxt />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    middleware: ['authenticated'],
    head () {
      const title = this.$trans('settings.titles.notifications')

      return {
        title,
        meta: [
          { hid: 'og:title', property: 'og:title', content: title }
        ]
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
