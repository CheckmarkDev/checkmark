import { accessorType } from '@/store'
import { VueWaitInstance } from 'vue-wait'
import { Emitter } from 'mitt'

declare module 'vue/types/vue' {
  interface Vue {
    $accessor: typeof accessorType
    $mitt: Emitter
    $wait: VueWaitInstance
    $toasted: any
    $trans: any
  }
}

declare module '@nuxt/types' {
  interface NuxtAppOptions {
    $accessor: typeof accessorType
  }

  interface Context {
    $wait: VueWaitInstance
    $mitt: Emitter
    $toasted: any
    $trans: any
  }
}
