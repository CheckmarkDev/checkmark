import { InMemoryCache } from 'apollo-cache-inmemory'
import cookieparser from 'cookieparser'
import jwt from 'jsonwebtoken'

export default function(ctx) {
  const { baseURL, browserBaseURL } = ctx.$config.axios

  const cache = new InMemoryCache({
    dataIdFromObject: object => object.uuid
  })

  return {
    cache,
    httpEndpoint: `${process.server ? baseURL : browserBaseURL}/graphql`,
    getAuth: () => {
      const { req, store } = ctx

      /**
       * Check if we already have a token in our local store
       */
      if (store.state.auth.token) {
        return `Bearer ${store.state.auth.token}`
      }

      if (!req) {
        return null
      }

      let token = null
      if (req.headers && req.headers.cookie) {
        const parsed = cookieparser.parse(req.headers.cookie)
        try {
          if (parsed.token) {
            token = parsed.token

            /**
             * Check if the token is expired
             */
            const decodedToken = jwt.decode(token)
            const expiresAt = (decodedToken.exp * 1000)
            if (expiresAt <= Date.now()) {
              return null
            }
          }
        } catch (err) {
          return null
        }
      }

      return token ? `Bearer ${token}` : null
    }
  }
}
