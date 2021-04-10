import VueICU from './vue-icu/index.js'

const TRANSLATION_FILES = [
  'global',
  'home',
  'sign-in',
  'sign-up',
  'user'
]

const LOCALES = ['fr']

const messages = {}

TRANSLATION_FILES.forEach((file) => {
  LOCALES.forEach(locale => {
    const translations = require(`./../locales/${file}/${locale}.yml`)
    messages[locale] = {
      ...messages[locale],
      ...translations
    }
  })
})

export const icu = new VueICU({
  locale: 'fr',
  fallbackLocale: 'fr',
  messages
})

export default (ctx, inject) => {
  inject('trans', (path, args) => {
    return icu.trans(path, args)
  })
}
