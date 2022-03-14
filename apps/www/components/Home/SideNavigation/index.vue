<template>
  <aside class="hidden md:flex md:flex-col w-3/12 mr-8">
    <nav class="bg-white dark:bg-gray-700 dark:text-white rounded-lg p-6">
      <h3 class="font-semibold text-xl mb-4 border-0 border-b border-solid border-b-gray-300 pb-1">
        {{ $trans('global.titles.about_us') }}
      </h3>
      <ul class="w-full">
        <li
          v-for="(link, k) in links"
          :key="k"
          class="mb-1"
        >
          <a :href="link.url" target="_blank" rel="noopener" class="flex py-1">
            {{ link.name }}
          </a>
        </li>
      </ul>
    </nav>
  </aside>
</template>

<script lang="ts">
  import { defineComponent } from '@vue/composition-api'

  export default defineComponent({
    setup() {
      const links = [
        {
          name: 'Twitter',
          url: 'https://www.twitter.com/checkmarkdev'
        },
        {
          name: 'Discord',
          url: 'https://discord.gg/VM3rH2X68P'
        },
        {
          name: 'Changelog',
          url: 'https://www.changelog.xyz/checkmark'
        }
      ]

      return {
        links
      }
    },
  })
</script>

