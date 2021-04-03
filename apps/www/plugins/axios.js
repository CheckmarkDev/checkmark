export default function ({ $axios, redirect, store }) {
  $axios.onRequest(config => {
    if (store.getters.isAuthenticated) {
      config.headers['Authorization'] = `Bearer ${store.state.auth.token}`
    }
  })
}
