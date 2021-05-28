<template>
  <div></div>
</template>

<script lang="ts">
  import { defineComponent } from '@vue/composition-api'
  import axios from 'axios'

  export default defineComponent({
    middleware: [
      async ({ route, redirect, $config }) => {
        const { name, query } = route
        if (name === 'EmailValidation') {
          const { token } = query
          if (!token) {
            return redirect('/auth/sign-in')
          }

          const baseURL = process.client
            ? $config.axios.browserBaseURL
            : $config.axios.baseURL

          return axios.post(`${baseURL}/auth/email_validation`, {}, {
            headers: {
              'Authorization': `Bearer ${token}`
            }
          })
            .then(() => {
              return redirect('/?success=email-validation')
            })
            .catch((err) => {
              return redirect('/?error=email-validation')
            })
        }
      }
    ]
  })
</script>
