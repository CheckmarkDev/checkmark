import { useContext } from '@nuxtjs/composition-api'

export default function useToasted() {
  const { $toasted } = useContext()

  return $toasted
}
