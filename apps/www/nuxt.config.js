export default {
  // Global page headers (https://go.nuxtjs.dev/config-head)
  head: {
    titleTemplate: '%s - Checkmark',
    title: 'Get things done',
    htmlAttrs: {
      lang: 'en',
      dir: 'ltr'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: 'Share your progress with developers around the world and get things done.' },
      { hid: 'og:description', name: 'og:description', content: 'Share your progress with developers around the world and get things done.' },
      { hid: 'twitter:description', name: 'twitter:description', content: 'Share your progress with developers around the world and get things done.' },
      { hid: 'og:image', name: 'og:image', content: '' },
      { hid: 'og:image:width', name: 'og:image:width', content: '1200' },
      { hid: 'og:image:height', name: 'og:image:height', content: '628' },
      { hid: 'twitter:image', name: 'twitter:image', content: '' },
      { hid: 'twitter:card', name: 'twitter:card', content: 'summary_large_image' },
      { hid: 'google-site-verification', name: 'google-site-verification', content: 'KuZrNJ2U-XmZnD_4ajl8QQrCkS7Ufj3aqmYcHzJRh2w' },
      { hid: 'og:site_name', property: 'og:site_name', content: 'Checkmark' },
      { hid: 'og:type', property: 'og:type', content: 'website' },
      { hid: 'og:locale', property: 'og:locale', content: 'en_US' },
      { hid: 'robots', name: 'robots', content: 'index' }
    ],
  },

  // Global CSS (https://go.nuxtjs.dev/config-css)
  css: [
    '@/assets/css/main.css'
  ],

  // Plugins to run before rendering page (https://go.nuxtjs.dev/config-plugins)
  plugins: [
    '~/plugins/axios',
    '~/plugins/vee-validate',
    '~/plugins/vue-icu.js',
    '~/plugins/dayjs.js',
    {
      src: '~/plugins/vue-sticky.js', mode: 'client'
    },
    {
      src: '~/plugins/mitt.js',
    },
    {
      src: '~/plugins/vue-hotjar.js', mode: 'client'
    },
    {
      src: '~/plugins/vue-lazy.js', mode: 'client'
    },
    {
      src: '~/plugins/vue-toasted', mode: 'client'
    }
  ],


  // Auto import components (https://go.nuxtjs.dev/config-components)
  components: true,

  // Modules for dev and build (recommended) (https://go.nuxtjs.dev/config-modules)
  buildModules: [
    // https://go.nuxtjs.dev/tailwindcss
    '@nuxtjs/composition-api',
    '@nuxt/typescript-build',
    '@nuxtjs/tailwindcss',
    '@nuxtjs/router',
    'nuxt-typed-vuex'
  ],

  // Modules (https://go.nuxtjs.dev/config-modules)
  modules: [
    // https://go.nuxtjs.dev/axios
    '@williamdasilva/gtag-module',
    // 'nuxt-stripe-module',
    'nuxt-socialsplash-module',
    '@nuxtjs/sentry',
    '@nuxtjs/axios',
    '@nuxtjs/pwa',
    '@nuxtjs/robots',
    '@nuxtjs/sitemap',
    ['vue-wait/nuxt', { useVuex: true }]
  ],

  // // Axios module configuration (https://go.nuxtjs.dev/config-axios)
  // stripe: {
  //   publishableKey: process.env.STRIPE_PUBLISHABLE_KEY
  // },

  axios: {
    baseURL: 'http://back:3333/api',
    browserBaseURL: 'http://localhost:3333/api'
  },

  publicRuntimeConfig: {
    hotjarId: process.env.VUE_APP_HOTJAR_ID,
    axios: {
      browserBaseURL: process.env.API_BROWSER_BASE_URL
    },
    gtag: {
      id: process.env.GOOGLE_ANALYTICS_ID
    }
  },

  privateRuntimeConfig: {
    hotjarId: process.env.VUE_APP_HOTJAR_ID,
    axios: {
      baseURL: process.env.API_BASE_URL
    },
    gtag: {
      id: process.env.GOOGLE_ANALYTICS_ID
    }
  },

  // Build Configuration (https://go.nuxtjs.dev/config-build)
  build: {
    transpile: [
      'vee-validate/dist/rules'
    ],

    extend (config, { isDev, isClient }) {
      config.module.rules.push({
        test: /\.ya?ml$/,
        loader: 'js-yaml-loader'
      })
    }
  }
}
