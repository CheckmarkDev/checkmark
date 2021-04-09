import { useContext } from '@nuxtjs/composition-api'
import { Emitter } from 'mitt'

export default function useAxios(): Emitter {
  const { app } = useContext()

  return app.$$mitt
}
