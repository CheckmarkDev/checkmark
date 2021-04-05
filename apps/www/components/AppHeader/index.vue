<template>
  <header class="w-full h-16 flex">
    <nav class="w-full bg-white my-auto container mx-auto">
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
  </header>
</template>
