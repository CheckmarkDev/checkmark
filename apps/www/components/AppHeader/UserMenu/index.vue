<template>
  <div class="user-menu relative">
    <button
      type="button"
      class="user-menu__toggle-button flex items-center rounded hover:cursor-pointer hover:bg-gray-200 focus:outline-none text-left"
      @click="isOpen = true"
    >
      <UserCard
        :user="$accessor.getAuthUser"
        class="hover:bg-gray-200 p-1 rounded"
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
          <path d="M6 6L0.803847 -2.51245e-08L11.1962 8.834e-07L6 6Z" fill="#4A5568"/>
        </svg>
      </div>
    </button>

    <transition
      name="fade"
    >
      <nav
        v-if="isOpen"
        class="user-menu__dropdown absolute right-0 bg-white rounded p-2 shadow"
        v-click-outside="() => isOpen = false"
      >
        <ul>
          <li>
            <nuxt-link
              :to="{
                name: 'User',
                params: {
                  username: $accessor.getAuthUser.username
                }
              }"
              class="flex py-2 px-4 hover:bg-gray-200"
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
              class="flex py-2 px-4 hover:bg-gray-200"
              @click.native="() => isOpen = false"
            >
              {{ $trans('global.buttons.settings') }}
            </nuxt-link>
          </li>
          <li>
            <a
              class="flex py-2 px-4 hover:bg-gray-200"
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
  import { defineComponent, ref, useRouter } from '@nuxtjs/composition-api'

  import useAccessor from '@/composables/useAccessor'

  import UserCard from '@/components/UserCard/index.vue'

  export default defineComponent({
    components: {
      UserCard
    },
    setup () {
      const router = useRouter()
      const accessor = useAccessor()

      const isOpen = ref(false)

      function signOut () {
        accessor.signOut()

        router.push({
          name: 'Home'
        }).catch(() => {})

        isOpen.value = false
      }

      return {
        isOpen,
        signOut
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
</style>
