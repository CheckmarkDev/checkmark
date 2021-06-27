export default function(ctx) {
  const { baseURL, browserBaseURL } = ctx.$config.axios

  return {
    httpEndpoint: `${process.server ? baseURL : browserBaseURL}/graphql`
  }
}
