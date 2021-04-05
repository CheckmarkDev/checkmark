import VueICU from './vue-icu/index.js'

export default (ctx, inject) => {
  const TRANSLATION_FILES = [
    'home',
    'sign-in'
  ]

  const messages = {}

  TRANSLATION_FILES.forEach((file) => {
    const translations = require(`./../locales/${file}/fr.yml`)
    messages.fr = {
      ...messages.fr,
      ...translations
    }
  })

  const icu = new VueICU({
    locale: 'fr',
    fallbackLocale: 'fr',
    messages
  })

  inject('trans', (path, args) => {
    return icu.trans(path, args)
  })
}
