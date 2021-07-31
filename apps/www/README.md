# www

This app is responsible of the website Checkmark.dev. It uses:

- NuxtJS along with Typescript
- TailwindCSS v2
- Vue Apollo

### Translations

At the time, the website is only available in french. Althrough, it's meant to be translatable in multiple languages. To be able to do so, we use a custom integration to handle translations with YML files and the ICU syntax.

The translations in the Vue side works like the vue-i18n with the `$trans` and the `icu` component.
