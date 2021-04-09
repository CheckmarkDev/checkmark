import { useContext } from '@nuxtjs/composition-api'
import Vue from 'vue'
import { VueWaitInstance } from 'vue-wait'

export default function useWait (): VueWaitInstance {
  const { app } = useContext()

  return app.wait
}
