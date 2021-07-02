<template>
  <ValidationObserver
    ref="observer"
  >
    <form
      :disabled="$wait.is('creating link')"
      class="flex flex-col"
      @submit.prevent="submitted"
    >
      <label
        for="url"
        class="mb-2"
      >
        Partagez un lien avec la communauté
      </label>
      <ValidationProvider
        rules="required"
        class="flex flex-col md:flex-row md:items-center"
        tag="div"
      >
        <input
          v-model="formData.url"
          type="url"
          name="url"
          id="url"
          class="input mr-4 mb-4 md:mb-0"
          placeholder="URL"
        >

        <button
          :disabled="$wait.is('creating link')"
          type="submit"
          class="btn btn-primary"
        >
          Publier
        </button>
      </ValidationProvider>
    </form>
  </ValidationObserver>
</template>

<script lang="ts">
  import { useMutation } from '@vue/apollo-composable/dist'
  import { defineComponent, reactive } from '@vue/composition-api'
  import gql from 'graphql-tag'
  import allLinks from '~/apollo/queries/allLinks'

  import useWait from '~/composables/useWait'

  export default defineComponent({
    setup () {
      const wait = useWait()
      const formData = reactive({
        url: null
      })

      const { mutate: createLink } = useMutation(gql`
        mutation ($url: String!) {
          createLink(input: { url: $url }) {
            link {
              uuid
              title
              url
              createdAt
              user {
                uuid
                username
                firstName
                lastName
                avatarUrl
              }
            }
          }
        }
      `)

      async function submitted () {
        wait.start('creating link')
        createLink({
          url: formData.url
        }, {
          update: (cache, { data: { createLink: link } }) => {
            /**
             * Once we have the data, we want to update the list of links.
             * Fetch the allLinks query to append on top of the list the new link
             */
            const data = cache.readQuery({ query: allLinks })
            data.allLinks.unshift(link.link)
            cache.writeQuery({ query: allLinks, data })
          }
        })
          .finally(() => {
            wait.end('creating link')
          })
      }

      return {
        formData,
        submitted
      }
    }
  })
</script>
