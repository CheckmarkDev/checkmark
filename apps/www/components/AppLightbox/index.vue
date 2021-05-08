<template>
  <div class="app-lightbox">
    <slot name="preview" :show="show">
      <a
        v-if="thumbnail"
        :href="images[0]"
        target="_blank"
        class="lightbox__thumbnail block"
        @click.prevent="show"
      >
        <img
          :src="thumbnail"
          :alt="alternateText"
          class="rounded border border-gray-300 border-solid"
        >
      </a>
    </slot>

    <div
      v-if="visible"
      class="lightbox p-8"
      @click="hide"
    >
      <button
        type="button"
        class="absolute right-0 top-0 p-3 rounded-full flex justify-center items-center text-white hover:bg-white hover:bg-opacity-25 mt-2 mr-2"
        @click="hide"
      >
        <XIcon
          size="32"
        />
      </button>

      <div class="lightbox__element mx-auto" @click.stop="">
        <div class="lightbox__element__navigation">
          <button
            type="button"
            class="absolute left-0 w-16 h-16 top-0 bottom-0 m-auto rounded-full flex justify-center items-center text-white hover:bg-white hover:bg-opacity-25 ml-8"
            @click.stop.prevent="previous"
            :class="{ 'hidden': !hasPrevious }"
          >
            <ChevronLeftIcon
              size="32"
            />
          </button>
          <button
            type="button"
            class="absolute right-0 top-0 bottom-0 m-auto w-16 h-16 rounded-full flex justify-center items-center text-white hover:bg-white hover:bg-opacity-25 mr-8"
            @click.stop.prevent="next"
            :class="{ 'hidden': !hasNext }"
          >
            <ChevronRightIcon
              size="32"
            />
          </button>
        </div>

        <div class="lightbox__image flex justify-center items-center" @click.stop="">
          <div
            name="content"
            v-if="displayImage"
          >
            <img
              :src="images[index]"
              class="rounded"
            >
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { defineComponent } from '@nuxtjs/composition-api'
  import Vue from 'vue'
  import { XIcon, ChevronLeftIcon, ChevronRightIcon } from 'vue-feather-icons'

  export default defineComponent({
    components: {
      XIcon,
      ChevronLeftIcon,
      ChevronRightIcon
    },
    props: {
      thumbnail: {
        type: String,
        default: null,
      },
      images: {
        type: Array,
      },
      openAtIndex: {
        type: Number,
        default: 0,
      },
      alternateText: {
        type: String,
        default: '',
      },
      value: {
        type: Boolean,
        default: false,
      },
    },
    data() {
      return {
        visible: this.value,
        index: this.openAtIndex,
        displayImage: true,
      }
    },
    computed: {
      hasNext() {
        return (this.index + 1 < this.images.length)
      },
      hasPrevious() {
        return (this.index - 1 >= 0)
      },
    },
    watch: {
      value(newValue) {
        this.visible = newValue
      },
      visible(newVisibility) {
        this.$emit('input', newVisibility)
      },
    },
    methods: {
      show() {
        this.visible = true
        this.index = this.openAtIndex
      },
      hide() {
        this.visible = false
        this.index = this.openAtIndex
      },
      previous() {
        if (this.hasPrevious) {
          this.index -= 1
          this.tick()
        }
      },
      next() {
        if (this.hasNext) {
          this.index += 1
          this.tick()
        }
      },
      tick() {
        if (!this.$slots.loader) {
          return
        }
        this.displayImage = false
        Vue.nextTick(() => {
          this.displayImage = true
        })
      },
      eventListener(e) {
        if (this.visible) {
          switch (e.key) {
            case 'ArrowRight':
              return this.next()
            case 'ArrowLeft':
              return this.previous()
            case 'ArrowDown':
            case 'ArrowUp':
            case ' ':
              return e.preventDefault()
            case 'Escape':
              return this.hide()
          }
        }
      },
    },
    mounted() {
      window.addEventListener('keydown', this.eventListener)
    },
    destroyed() {
      window.removeEventListener('keydown', this.eventListener)
    },
  })
</script>

<style>
  .lightbox {
    position: fixed;
    top: 0;
    left: 0;
    background: rgba(0, 0, 0, .8);
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1;
  }
  .lightbox__thumbnail {
    width: 100%;
    height: 100%;
    transition: transform 200ms;
  }
  .lightbox__thumbnail img {
    width: 100%;
  }
  .lightbox__thumbnail:hover {
    transform: scale(1.02);
  }
  .lightbox__element {
    display: flex;
    height: fit-content;
  }
  .lightbox__image {
    flex: 1;
  }
  .lightbox__image img {
    max-width: 100%;
    max-height: 90vh;
  }

  @media screen and (max-width: 500px) {
    .lightbox__element {
      position: relative;
    }
  }

  @media only screen and (max-width: 720px) {
    .lightbox__element__navigation {
      @apply absolute left-0 w-full;

      bottom: -2.5rem;
    }
  }
</style>
