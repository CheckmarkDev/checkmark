import { InMemoryCache, defaultDataIdFromObject } from 'apollo-cache-inmemory'

export default function({ $config }) {
  const URL = $config.axios.baseURL || $config.axios.browserBaseURL

  return {
    httpEndpoint: `${URL}/graphql`,
    cache: new InMemoryCache({
      dataIdFromObject(responseObject) {
        const handledObjects = ['User', 'Task', 'TaskGroup', 'Project']
        if (handledObjects.includes(responseObject.__typename) && responseObject.uuid) {
          return `${responseObject.__typename}:${responseObject.uuid}`
        }

        return defaultDataIdFromObject(responseObject)
      }
    })
  }
}
