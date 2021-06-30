import { provide, onGlobalSetup, defineNuxtPlugin } from "@nuxtjs/composition-api"
import { DefaultApolloClient } from "@vue/apollo-composable/dist"

export default defineNuxtPlugin(({ app }) => {
  onGlobalSetup(() => {
    provide(DefaultApolloClient, app.apolloProvider.defaultClient)
  })
})
