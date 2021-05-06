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
      <div class="lightbox__close" @click="hide">
        <slot name="icon-close">&times;</slot>
      </div>
      <div class="lightbox__element" @click.stop="">
        <div
          class="lightbox__arrow lightbox__arrow--left"
          @click.stop.prevent="previous"
          :class="{ 'lightbox__arrow--invisible': !hasPrevious }"
        >
          <slot name="icon-previous">
            <svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
              <path d="M15.41 16.09l-4.58-4.59 4.58-4.59L14 5.5l-6 6 6 6z"/>
              <path d="M0-.5h24v24H0z" fill="none"/>
            </svg>
          </slot>
        </div>
        <div class="lightbox__image flex justify-center items-center" @click.stop="">
          <slot name="content" :url="images[index]" v-if="displayImage">
            <img
              :src="images[index]"
              class="rounded"
            >
          </slot>
        </div>
        <div
          class="lightbox__arrow lightbox__arrow--right"
          @click.stop.prevent="next"
          :class="{ 'lightbox__arrow--invisible': !hasNext }"
        >
          <slot name="icon-next">
            <svg height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
              <path d="M8.59 16.34l4.58-4.59-4.58-4.59L10 5.75l6 6-6 6z"/>
              <path d="M0-.25h24v24H0z" fill="none"/>
            </svg>
          </slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import { defineComponent } from '@nuxtjs/composition-api'
  import Vue from 'vue'

  export default defineComponent({
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
    transform: scale(1.05);
  }
  .lightbox__close {
    position: fixed;
    right: 0;
    top: 0;
    padding: 1rem;
    font-size: 1.5rem;
    cursor: pointer;
    color: #fff;
    width: 4rem;
    height: 4rem;
  }
  .lightbox__arrow--invisible {
    visibility: hidden;
  }
  .lightbox__element {
    display: flex;
    width: 100%;
    height: fit-content;
  }
  .lightbox__arrow {
    padding: 0 2rem;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .lightbox__arrow svg {
    fill: #fff;
    pointer-events: none;
  }
  .lightbox__image {
    flex: 1;
  }
  .lightbox__image img {
    max-width: 100%;
    max-height: 90vh;
  }
  @media screen and (max-width: 720px) {
    .lightbox__arrow {
      padding: 0 1rem;
    }
  }
  @media screen and (max-width: 500px) {
    .lightbox__element {
      position: relative;
    }
    .lightbox__arrow {
      position: absolute;
      padding: 0 2rem;
      height: 100%;
    }
    .lightbox__arrow--right {
      right: 0;
      background: linear-gradient(to right, transparent, rgba(0, 0, 0, .3));
    }
    .lightbox__arrow--left {
      left: 0;
      background: linear-gradient(to left, transparent, rgba(0, 0, 0, .3));
    }
  }
</style>
