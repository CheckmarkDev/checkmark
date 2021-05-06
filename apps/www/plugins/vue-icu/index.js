import Vue from 'vue'
// import moment from 'moment'
import MessageFormat from 'messageformat'

/**
 * @typedef VueICUOptions
 * @type {Object}
 * @property {any} messages
 * @property {string} locale
 * @property {string} [fallbackLocale]
 * @property {boolean} [silentTranslationWarn]
 */

export default class VueICU {
  constructor (/** @type {VueICUOptions} */ options) {
    this._locale = options.locale || 'en'
    this._fallbackLocale = options.fallbackLocale || 'en'

    /** @type {any} */
    this._customFormatters = {}
    this._silentTranslationWarn = options.silentTranslationWarn || false
    this._messages = {
      ...(options.messages || {})
    }

    /**
     * Add custom formatters
     */
    /**
     * @function moment
     * @param {any} v
     * @param {string} locale
     * @param {string} format
     * @returns {string}
     */
    // this._customFormatters.moment = (v, locale, format) => {
    //   return moment(v).format(format)
    // }

    this._vm = new Vue({
      data: {
        locale: this._locale,
        messages: this._messages
      }
    })
  }

  // @ts-ignore
  get locale () {
    return this._vm.locale
  }

  // @ts-ignore
  set locale (newLocale) {
    this._vm.$set(this._vm, 'locale', newLocale)
  }

  destroyVM () {
    if (this._vm) this._vm.$destroy()
  }

  /**
   * @method getMessages
   * @param {string} locale
   * @returns {any}
   */
  getMessages (locale) {
    if (this._vm.messages[locale]) {
      return this._vm.messages[locale]
    } else {
      return {}
    }
  }

  /**
   * @method setLocaleMessage
   * @param {string} locale
   * @param {any} messages
   * @returns {void}
   */
  setLocaleMessage (locale, messages) {
    let msgs = []
    this._vm.$set(this._vm.messages, locale, messages)
    if (this._vm.messages[locale]) {
      msgs = messages
    }

    this._vm.$set(this._vm.messages, locale, msgs)
  }

  /**
   * @method getMessage
   * @param {string} path
   * @returns {any}
   */
  getMessage (path) {
    let locale = this.locale
    let dictionnaryPath = Object.keys(this.getMessages(locale)).find(key => key === path)
    if (!dictionnaryPath) {
      locale = this._fallbackLocale
      dictionnaryPath = Object.keys(this.getMessages(locale)).find(key => key === path)
      if (dictionnaryPath) {
        if (!this._silentTranslationWarn) console.warn(`Could not find the translation key for ${this.locale}, fallback to ${this._fallbackLocale}`)
      } else {
        if (!this._silentTranslationWarn) console.error(`Could not find the translation key ${path}`)
        return path
      }
    }

    return this.getMessages(locale)[dictionnaryPath]
  }

  /**
   * @method trans
   * @param {string} path
   * @param {object} variables
   * @returns {string}
   */
  trans (path, variables = {}) {
    /** @type {any} */
    const options = {
      returnType: 'string',
      customFormatters: this._customFormatters
    }
    const formatter = new MessageFormat(this.locale, options)

    const message = this.getMessage(path)

    /**
     * TODO: Technically it's not the correct locale here. It may be the fallback locale.
     */
    const fn = formatter.compile(message, this.locale)
    return fn(variables)
  }
}
