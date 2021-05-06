<template>
  <header class="app-header w-full h-16 flex bg-white">
    <div class="flex items-center container mx-auto">
      <SideMenu />

      <nav>
        <ul>
          <li>
            <nuxt-link
              :to="{
                path: '/'
              }"
            >
              <picture>
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
              >
                {{ $trans('global.buttons.sign-in') }}
              </nuxt-link>
            </li>
            <li>
              <nuxt-link
                :to="{
                  name: 'SignUp'
                }"
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
  import { defineComponent, ref, watch } from '@nuxtjs/composition-api'

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