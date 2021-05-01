export default function({ $config }) {
  const URL = $config.axios.baseURL || $config.axios.browserBaseURL

  return {
    httpEndpoint: `${URL}/graphql`
  }
}
