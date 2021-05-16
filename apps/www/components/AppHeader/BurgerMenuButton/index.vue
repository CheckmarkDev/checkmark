<template>
  <button
    class="burger-menu-button flex border-none appearance-none cursor-pointer text-gray-900 dark:text-white p-2"
    type="button"
  >
    <div
      id="icon"
      :class="{ open }"
    >
      <span />
      <span />
      <span />
    </div>
  </button>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    name: 'BurgerMenuButton',
    props: {
      open: {
        type: Boolean,
        default: false
      }
    }
  })
</script>

<style lang="css" scoped>
  .burger-menu-button {
    background: transparent;
    transition: background-color 200ms, color 200ms;
  }

  #icon {
    width: 30px;
    height: 24px;
    position: relative;
    transform: rotate(0deg) scale(0.7);
    transition: 0.5s ease-in-out;
    cursor: pointer;
    margin: auto;
  }

  #icon span {
    @apply bg-gray-900 dark:bg-white;

    display: block;
    position: absolute;
    height: 2px;
    width: 100%;
    border-radius: 2;
    opacity: 1;
    left: 0;
    transform: rotate(0deg);
    transition: 0.25s ease-in-out;
  }

  #icon span:nth-child(1) {
    top: 0;
    transform-origin: left center;
  }

  #icon span:nth-child(2) {
    top: 12px;
    transform-origin: left center;
  }

  #icon span:nth-child(3) {
    top: 24px;
    transform-origin: left center;
  }

  #icon.open span:nth-child(1) {
    transform: rotate(45deg);
    top: 0;
    left: 4px;
  }

  #icon.open span:nth-child(2) {
    width: 0%;
    opacity: 0;
  }

  #icon.open span:nth-child(3) {
    transform: rotate(-45deg);
    top: 21px;
    left: 4px;
  }
</style>
