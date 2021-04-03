import Vue from 'vue'
import mitt from 'mitt'

export default (ctx, inject) => {
  const emitter = mitt()
  Vue.prototype.$mitt = emitter

  inject('$mitt', emitter)
}