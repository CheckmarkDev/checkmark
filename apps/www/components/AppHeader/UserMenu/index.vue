<template>
  <div class="user-menu relative">
    <button
      type="button"
      class="user-menu__toggle-button flex items-center rounded hover:cursor-pointer hover:bg-gray-200 dark:hover:bg-gray-600 focus:outline-none text-left"
      @click="isOpen = true"
    >
      <UserCard
        :user="$accessor.getAuthUser"
        class="p-1 rounded dark:text-white"
      />
      <div class="flex m-auto w-8 h-8 items-center justify-center">
        <svg
          :class="{
            'rotate-180': isOpen
          }"
          class="transform"
          width="12"
          height="6"
          viewBox="0 0 12 6"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path d="M6 6L0.803847 -2.51245e-08L11.1962 8.834e-07L6 6Z" fill="#717F98"/>
        </svg>
      </div>
    </button>

    <transition
      name="fade"
    >
      <nav
        v-if="isOpen"
        class="user-menu__dropdown absolute right-0 bg-white dark:bg-gray-700 rounded p-2 shadow z-10"
        v-click-outside="() => isOpen = false"
      >
        <ul>
          <li>
            <nuxt-link
              :to="{
                name: 'User',
                params: {
                  username: $accessor.getAuthUser && $accessor.getAuthUser.username
                }
              }"
              class="flex py-2 px-4 dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600 rounded mb-2"
              @click.native="() => isOpen = false"
            >
              {{ $trans('global.buttons.profile') }}
            </nuxt-link>
          </li>
          <li>
            <nuxt-link
              :to="{
                name: 'Settings'
              }"
              class="flex py-2 px-4 dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600 rounded mb-2"
              @click.native="() => isOpen = false"
            >
              {{ $trans('global.buttons.settings') }}
            </nuxt-link>
          </li>
          <li>
            <button
              type="button"
              class="flex py-2 px-4 dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600 rounded mb-2 font-medium w-full"
              @click="toggleDarkMode"
            >
              <div class="flex items-center">
                <div
                  :class="{
                    'user-menu__dropdown__switch--active': $colorMode.preference === 'dark'
                  }"
                  class="user-menu__dropdown__switch bg-gray-300 dark:bg-gray-800 w-8 h-6 rounded-full mr-2"
                >
                </div>
                <div
                  v-text="$trans('global.buttons.dark_mode')"
                />
              </div>
            </button>
          </li>
          <li class="border-t border-gray-300 dark:border-gray-600 mt-2 pt-2">
            <a
              class="flex py-2 px-4 dark:text-white hover:bg-gray-200 dark:hover:bg-gray-600 rounded"
              href="#"
              @click.prevent="signOut"
            >
              {{ $trans('global.buttons.sign-out') }}
            </a>
          </li>
        </ul>
      </nav>
    </transition>
  </div>
</template>

<script lang="ts">
  import { defineComponent, ref, useContext, useRouter } from '@nuxtjs/composition-api'

  import useAccessor from '@/composables/useAccessor'

  import UserCard from '@/components/UserCard/index.vue'

  export default defineComponent({
    components: {
      UserCard
    },
    setup () {
      const router = useRouter()
      const accessor = useAccessor()
      const { $colorMode } = useContext()

      const isOpen = ref(false)

      function signOut () {
        accessor.signOut()

        router.push({
          name: 'Home'
        }).catch(() => {})

        isOpen.value = false
      }

      function toggleDarkMode () {
        $colorMode.preference = $colorMode.preference === 'light' ? 'dark' : 'light'
      }

      return {
        isOpen,
        signOut,
        toggleDarkMode
      }
    }
  })
</script>

<style>
  @media only screen and (max-width: 1024px) {
    .user-menu .user-card__name {
      display: none;
    }
  }
</style>

<style scoped>
  .user-menu .user-card {
    max-width: 250px;
  }

  .user-menu__toggle-button svg {
    transition: transform 200ms;
  }

  .user-menu__dropdown {
    top: 64px;
    width: 250px;
  }

  .user-menu__dropdown__switch {
    @apply relative;
  }

  .user-menu__dropdown__switch::after {
    @apply absolute top-0 bottom-0 m-auto bg-gray-400 rounded-full;

    content: '';
    width: 14px;
    height: 14px;
    left: 4px;
  }

  .user-menu__dropdown__switch--active::after {
    @apply bg-blue-500;

    right: 4px;
    left: auto;
  }
</style>
