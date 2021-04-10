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
            <li>
              <nuxt-link
                :to="{
                  name: 'SignIn'
                }"
              >
                {{ $trans('global.buttons.sign-in') }}
              </nuxt-link>
            </li>
          </template>
          <template
            v-else
          >
            <li>
              <a
                href="#"
                @click.prevent="signOut"
              >
                {{ $trans('global.buttons.sign-out') }}
              </a>
            </li>
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

  export default defineComponent({
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

