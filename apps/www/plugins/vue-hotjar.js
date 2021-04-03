import Vue from 'vue'
import VueHotjar from 'vue-hotjar'

export default ({ $config }) => {
  if (process.client) {
    Vue.use(VueHotjar, {
      id: `${$config.hotjarId}` || 'XXXXXXX'
    })
  }
}
