import component from './component'
import mixin from './mixin'

export default (/** @type {import('vue').VueConstructor} */ Vue) => {
  Vue.component('Icu', component)
  Vue.mixin(mixin)
}
