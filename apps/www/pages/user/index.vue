<template>
  <main>
    <div class="user-hero">
      <div class="container mx-auto">
        <div class="flex items-center justify-between py-8 w-full">
          <div
            v-if="user"
            class="w-full md:w-1/2 flex items-center"
          >
            <UserAvatar
              :user="user"
              :width="80"
              :height="80"
              class="user-hero__avatar mr-8 flex-shrink-0"
            />
            <div class="truncate">
              <h1
                class="text-3xl text-white leading-tight mb-0 truncate"
                v-text="`${user.first_name} ${user.last_name}`"
              />
              <h2
                class="text-xl text-gray-300"
                v-text="`@${user.username}`"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="user-container">
      <div class="container mx-auto flex items-start">
        <SideNavigation />
        <section class="bg-white w-full md:w-9/12 h-56 rounded-lg p-6">
         <nuxt />
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'
  import { TaskGroup } from '~/types/taskGroup'
  import { User } from '~/types/user'
  import SideNavigation from '@/components/Home/SideNavigation/index.vue'
  import UserAvatar from '@/components/UserAvatar/index.vue'

  export default defineComponent({
    components: {
      SideNavigation,
      UserAvatar
    },
    data () {
      return {
        user: null
      } as {
        user: User | null
      }
    },
    head () {
      const user = this.user as any
      const fullName = `${user.first_name} ${user.last_name}`.trim()
      const description = this.$trans('user.paragraphs.description', {
        user: fullName || user.username
      })

      return {
        title: fullName || user.username,
        meta: [
          { hid: 'description', name: 'description', content: description },
          { hid: 'og:description', property: 'og:description', content: description },
          { hid: 'og:title', property: 'og:title', content: fullName || user.username },
          {
            hid: 'og:image:width', name: 'og:image:width', content: '1200'
          },
          {
            hid: 'og:image:height', name: 'og:image:height', content: '628'
          },
          {
            hid: 'og:image:type', name: 'og:image:type', content: 'image/png'
          }
        ]
      }
    },
    async asyncData ({ $axios, route }) {
      const { username } = route.params
      const [user] = await Promise.all([
        $axios.$get(`/users/${username}`)
      ])

      return {
        user
      }
    }
  })
</script>

<style scoped>
  .user-hero {
    height: 320px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);

    @screen md {
      height: 400px;
    }
  }

  .user-container {
    margin-top: -180px;
  }
</style>
