import VueICU from './index'

export default {
  beforeCreate () {
    // @ts-ignore
    const options = this.$options
    options.icu = options.icu || (options.__icu ? {} : null)

    if (options.icu) {
      if (options.icu instanceof VueICU) {
        // @ts-ignore
        this._icu = options.icu
      }
    // @ts-ignore
    } else if (this.$root && this.$root.$icu && this.$root.$icu instanceof VueICU) {
      // root icu
      // @ts-ignore
      this._icu = this.$root.$icu
    } else if (options.parent && options.parent.$icu && options.parent.$icu instanceof VueICU) {
      // parent icu
      // @ts-ignore
      this._icu = options.parent.$icu
    }
  },
  beforeDestroy () {
    // @ts-ignore
    if (!this._icu) { return }

    const self = this
    // @ts-ignore
    this.$nextTick(() => {
      // @ts-ignore
      if (self._icu) {
        // @ts-ignore
        self._icu.destroyVM()
      }

      // @ts-ignore
      self._icu = null
    })
  }
}
