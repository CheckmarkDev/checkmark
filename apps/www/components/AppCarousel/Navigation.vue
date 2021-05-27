<template>
  <div class="absolute top-0 right-0 w-full">
    <div class="VueCarousel-navigation container mx-auto relative">
      <div class="absolute right-0 -mt-12">
        <button
          type="button"
          aria-label="Previous page"
          :class="{
            'bg-opacity-40 cursor-not-allowed': !canAdvanceBackward,
            'bg-opacity-75 hover:bg-opacity-100': canAdvanceBackward
          }"
          :tabindex="canAdvanceBackward ? 0 : -1"
          class="rounded-full bg-white p-2 mr-4 focus:outline-none"
          v-on:click.prevent="triggerPageAdvance('backward')"
        >
          <ChevronLeftIcon
            class="text-blue-600"
          />
        </button>

        <button
          type="button"
          aria-label="Next page"
          :class="{
            'bg-opacity-40 cursor-not-allowed': !canAdvanceForward,
            'bg-opacity-75 hover:bg-opacity-100': canAdvanceForward
          }"
          :tabindex="canAdvanceForward ? 0 : -1"
          class="rounded-full bg-white p-2 mr-4 focus:outline-none"
          v-on:click.prevent="triggerPageAdvance('forward')"
        >
          <ChevronRightIcon
            class="text-blue-600"
          />
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ChevronLeftIcon, ChevronRightIcon } from 'vue-feather-icons'

export default {
  name: "navigation",
  components: {
    ChevronLeftIcon,
    ChevronRightIcon
  },
  inject: ["carousel"],
  props: {
    /**
     * Amount of padding to apply around the label in pixels
     */
    clickTargetSize: {
      type: Number,
      default: 8
    },
    /**
     * Text content of the navigation next button
     */
    nextLabel: {
      type: String,
      default: "&#9654"
    },
    /**
     * Text content of the navigation prev button
     */
    prevLabel: {
      type: String,
      default: "&#9664"
    }
  },
  computed: {
    /**
     * @return {Boolean} Can the slider move forward?
     */
    canAdvanceForward() {
      return this.carousel.canAdvanceForward || false;
    },
    /**
     * @return {Boolean} Can the slider move backward?
     */
    canAdvanceBackward() {
      return this.carousel.canAdvanceBackward || false;
    }
  },
  methods: {
    /**
     * Trigger page change on +/- 1 depending on the direction
     * @param {"backward"} [direction]
     * @return {void}
     */
    triggerPageAdvance(direction) {
      /**
       * @event paginationclick
       * @type {string}
       */
      this.$emit("navigationclick", direction);
    }
  }
};
</script>
