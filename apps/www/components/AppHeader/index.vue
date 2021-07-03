<template>
  <header class="app-header w-full h-16 flex bg-white dark:bg-gray-800">
    <div class="flex items-center container mx-auto">
      <SideMenu />

      <nav class="font-medium text-base">
        <ul class="flex items-center">
          <li class="mr-6">
            <nuxt-link
              :to="{
                path: '/'
              }"
            >
              <picture
                class="app-header__logo--light dark:hidden"
              >
                <source
                  srcset="@/assets/img/logo.svg"
                  media="(min-width: 770px)"
                >

                <img
                  src="@/assets/img/icon.svg"
                  alt="Checkmark logo"
                  class="app-header__logo"
                  height="30"
                >
              </picture>
              <picture
                class="app-header__logo--dark hidden dark:block"
              >
                <source
                  srcset="@/assets/img/logo-white.svg"
                  media="(min-width: 770px)"
                >

                <img
                  src="@/assets/img/icon-white.svg"
                  alt="Checkmark logo"
                  class="app-header__logo"
                  height="30"
                >
              </picture>
            </nuxt-link>
          </li>

          <li class="hidden md:block mr-4">
            <nuxt-link
              :to="{
                name: 'Home'
              }"
              class="dark:text-white"
            >
              {{ $trans('global.titles.feed') }}
            </nuxt-link>
          </li>

          <li class="hidden md:block mr-4">
            <nuxt-link
              :to="{
                name: 'Links'
              }"
              class="dark:text-white"
            >
              {{ $trans('links.titles.main') }}
            </nuxt-link>
          </li>

          <li class="hidden md:block">
            <nuxt-link
              :to="{
                name: 'Roadmap'
              }"
              class="dark:text-white"
            >
              {{ $trans('roadmap.titles.main') }}
            </nuxt-link>
          </li>
        </ul>
      </nav>

      <nav class="flex flex-1 font-medium text-base text-blue-700">
        <ul class="flex items-center ml-auto">
          <template
            v-if="!$accessor.isAuthenticated"
          >
            <li class="mr-6 hidden md:block">
              <nuxt-link
                :to="{
                  name: 'SignIn'
                }"
                class="dark:text-white"
              >
                {{ $trans('global.buttons.sign-in') }}
              </nuxt-link>
            </li>
            <li>
              <nuxt-link
                :to="{
                  name: 'SignUp'
                }"
                class="dark:text-white"
              >
                {{ $trans('global.buttons.sign-up') }}
              </nuxt-link>
            </li>
          </template>
          <template
            v-else
          >
            <UserMenu />
          </template>
        </ul>
      </nav>
    </div>
  </header>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import UserMenu from '@/components/AppHeader/UserMenu/index.vue'
  import SideMenu from '@/components/AppHeader/SideMenu/index.vue'

  export default defineComponent({
    components: {
      UserMenu,
      SideMenu
    }
  })
</script>

<style scoped>
  .app-header__logo {
    max-width: initial;
    width: auto;
    height: 35px;
  }
</style>
