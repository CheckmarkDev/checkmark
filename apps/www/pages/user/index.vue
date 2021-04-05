<template>
  <main>
    <div class="home-hero">
      <div class="container mx-auto">
        <div class="flex items-center justify-between py-8">
          <div class="w-1/2">
            <h1
              class="text-3xl text-white leading-tight mb-4"
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
    <div class="home-container">
      <div class="container mx-auto flex items-start">
        <section class="bg-white w-full h-56 rounded-lg p-6">
        </section>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    data () {
      return {
        user: null
      }
    },
    async asyncData ({ $axios, route }) {
      const user = await $axios.$get(`/users/${route.params.username}`)

      return {
        user
      }
    }
  })
</script>

<style scoped>
  .home-hero {
    height: 400px;
    background: rgb(39,109,170);
    background: linear-gradient(69deg, rgba(39,109,170,1) 0%, rgba(41,169,229,1) 100%);
  }

  .home-container {
    margin-top: -180px;
  }
</style>
