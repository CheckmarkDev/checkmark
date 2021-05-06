import Vue from 'vue'
import VueToasted from 'vue-toasted'

export default (ctx, inject) => {
  Vue.use(VueToasted, {
    position: 'bottom-right',
    duration: 5000
  })

  inject('toasted', Vue.prototype.$toasted)
}
