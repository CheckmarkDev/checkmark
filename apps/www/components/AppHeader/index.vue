<template>
  <header class="w-full h-16 flex bg-white">
    <div class="flex items-center container mx-auto">
      <nav>
        <ul>
          <li>
            <nuxt-link
              :to="{
                path: '/'
              }"
            >
              <img
                src="@/assets/img/logo.svg"
                alt="Checkmark logo"
                width="200"
              >
            </nuxt-link>
          </li>
        </ul>
      </nav>

      <nav class="flex flex-1 font-medium text-base text-blue-700">
        <ul class="flex items-center ml-auto">
          <template
            v-if="!$accessor.isAuthenticated"
          >
            <li class="mr-6">
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
  import { defineComponent } from '@nuxtjs/composition-api'

  import UserMenu from '@/components/AppHeader/UserMenu/index.vue'

  export default defineComponent({
    components: {
      UserMenu
    }
  })
</script>

