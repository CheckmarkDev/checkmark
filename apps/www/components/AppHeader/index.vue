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
            <!-- <li>
              <a
                href="#"
                @click.prevent="signOut"
              >
                {{ $trans('global.buttons.sign-out') }}
              </a>
            </li> -->
          </template>
        </ul>
      </nav>
    </div>
  </header>
</template>

<script lang="ts">
  import { defineComponent, useRouter } from '@nuxtjs/composition-api'
  import Cookie from 'js-cookie'

  import useAccessor from '@/composables/useAccessor'
  import UserMenu from '@/components/AppHeader/UserMenu/index.vue'

  export default defineComponent({
    components: {
      UserMenu
    },
    setup () {
      const router = useRouter()
      const accessor = useAccessor()

      function signOut () {
        Cookie.remove('token')
        Cookie.remove('user')

        accessor.setAuthToken(null)
        accessor.setAuthUser(null)

        router.push({
          name: 'Home'
        }).catch(() => {})
      }

      return {
        signOut
      }
    }
  })
</script>

