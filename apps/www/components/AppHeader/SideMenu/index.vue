<template>
  <div
    v-click-outside="close"
    class="side-menu md:hidden"
  >
    <BurgerMenuButton
      :open="visible"
      class="mr-4"
      @click.native="visible = !visible"
    />

    <transition
      name="fade"
    >
      <nav
        v-if="visible"
        class="side-menu__burger-menu fixed left-0 bg-white z-30 p-6 overflow-y-auto"
      >
        <ul class="mb-4 border-b border-gray-300 pb-2">
          <li>
            <nuxt-link
              :to="{
                name: 'Home'
              }"
              class="flex py-2"
              @click.native="close"
            >
              Feed
            </nuxt-link>
          </li>
          <li>
            <nuxt-link
              :to="{
                name: 'Roadmap'
              }"
              class="flex py-2"
              @click.native="close"
            >
              Roadmap
            </nuxt-link>
          </li>
          <li class="mb-1">
            <a href="https://discord.gg/VM3rH2X68P" target="_blank" rel="noopener" class="flex py-2" @click="close">
              Discord
            </a>
          </li>
          <li class="mb-1">
            <a href="https://www.twitter.com/checkmarkdev" target="_blank" rel="noopener" class="flex py-2" @click="close">
              Twitter
            </a>
          </li>
          <li class="mb-1">
            <a href="https://www.changelog.xyz/checkmark" target="_blank" rel="noopener" class="flex py-2" @click="close">
              Changelog
            </a>
          </li>
        </ul>
        <ul>
          <template
            v-if="!$accessor.isAuthenticated"
          >
            <li>
              <nuxt-link
                :to="{
                  name: 'SignIn'
                }"
                class="flex py-2"
                @click.native="close"
              >
                {{ $trans('global.buttons.sign-in') }}
              </nuxt-link>
            </li>
            <li>
              <nuxt-link
                :to="{
                  name: 'SignUp'
                }"
                class="flex py-2"
                @click.native="close"
              >
                {{ $trans('global.buttons.sign-up') }}
              </nuxt-link>
            </li>
          </template>
          <template
            v-else
          >
            <li class="mb-4">
              <UserCard
                :user="$accessor.getAuthUser"
                class="hover:bg-gray-200 p-1 rounded"
              />
            </li>
            <li>
              <nuxt-link
                :to="{
                  name: 'User',
                  params: {
                    username: $accessor.getAuthUser.username
                  }
                }"
                class="flex py-2 hover:bg-gray-200"
                @click.native="close"
              >
                {{ $trans('global.buttons.profile') }}
              </nuxt-link>
            </li>
            <li>
              <nuxt-link
                :to="{
                  name: 'Settings'
                }"
                class="flex py-2 hover:bg-gray-200"
                @click.native="close"
              >
                {{ $trans('global.buttons.settings') }}
              </nuxt-link>
            </li>
            <li>
              <a
                class="flex py-2 hover:bg-gray-200"
                href="#"
                @click.prevent="signOut"
              >
                {{ $trans('global.buttons.sign-out') }}
              </a>
            </li>
          </template>
        </ul>
      </nav>
    </transition>
  </div>
</template>

<script lang="ts">
  import { defineComponent, ref, watch, useRouter } from '@nuxtjs/composition-api'
  import useAccessor from '@/composables/useAccessor'

  import BurgerMenuButton from '@/components/AppHeader/BurgerMenuButton/index.vue'
  import UserCard from '@/components/UserCard/index.vue'

  export default defineComponent({
    components: {
      BurgerMenuButton,
      UserCard
    },
    setup () {
      const visible = ref(false)
      const accessor = useAccessor()
      const router = useRouter()

      watch(visible, (value) => {
        if (value) {
          document.querySelector('body')?.classList.add('overflow-hidden')
        } else {
          document.querySelector('body')?.classList.remove('overflow-hidden')
        }
      })

      function close () {
        visible.value = false
      }

      function signOut () {
        accessor.signOut()

        router.push({
          name: 'Home'
        }).catch(() => {})

        close()
      }

      return {
        visible,
        close,
        signOut
      }
    }
  })
</script>

<style scoped>
  .side-menu__burger-menu {
    top: 4rem;
    width: 100%;
    width: calc(100vw - 4rem);
    height: 100%;
    height: calc(100vh - 4rem);
  }
</style>