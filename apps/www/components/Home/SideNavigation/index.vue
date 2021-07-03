<template>
  <div class="hidden md:flex md:flex-col w-3/12 mr-8">
    <nav class="bg-white dark:bg-gray-700 dark:text-white rounded-lg p-4 mb-4">
      <ul class="w-full">
        <li class="mb-1">
          <nuxt-link
            :to="{
              name: 'Home'
            }"
            :exact-active-class="'router-link-active bg-gray-200 dark:bg-gray-600'"
            class="hover:bg-gray-200 dark:hover:bg-gray-600 rounded p-2 w-full flex mb-1"
          >
            {{ $trans('global.titles.feed') }}
          </nuxt-link>
          <nuxt-link
            :to="{
              name: 'Links'
            }"
            :exact-active-class="'router-link-active bg-gray-200 dark:bg-gray-600'"
            class="hover:bg-gray-200 dark:hover:bg-gray-600 rounded p-2 w-full flex mb-1"
          >
            {{ $trans('links.titles.main') }}
          </nuxt-link>
          <nuxt-link
            :to="{
              name: 'Roadmap'
            }"
            :active-class="'router-link-active bg-gray-200 dark:bg-gray-600'"
            class="hover:bg-gray-200 dark:hover:bg-gray-600 rounded p-2 w-full flex"
          >
            {{ $trans('roadmap.titles.main') }}
          </nuxt-link>
        </li>
      </ul>
    </nav>

    <nav class="bg-white dark:bg-gray-700 dark:text-white rounded-lg p-4">
      <ul class="w-full">
        <li class="mb-1">
          <a href="https://discord.gg/VM3rH2X68P" target="_blank" rel="noopener" class="hover:bg-gray-200 dark:hover:bg-gray-600 rounded p-2 w-full flex">
            Discord
          </a>
        </li>
        <li class="mb-1">
          <a href="https://www.twitter.com/checkmarkdev" target="_blank" rel="noopener" class="hover:bg-gray-200 dark:hover:bg-gray-600 rounded p-2 w-full flex">
            Twitter
          </a>
        </li>
        <li class="mb-1">
          <a href="https://www.changelog.xyz/checkmark" target="_blank" rel="noopener" class="hover:bg-gray-200 dark:hover:bg-gray-600 rounded p-2 w-full flex">
            Changelog
          </a>
        </li>
      </ul>
    </nav>
  </div>
</template>
