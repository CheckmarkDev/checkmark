import { useContext } from '@nuxtjs/composition-api'

export default function useICU() {
  const { $trans } = useContext()

  return $trans
}
