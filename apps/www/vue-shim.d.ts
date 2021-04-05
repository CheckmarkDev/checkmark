declare module "*.vue" {
  import Vue from 'vue'

  export default Vue
}

declare module '@vue/runtime-core' {
  import { Emitter } from 'mitt'
  import { accessorType } from '@/store'

  interface ComponentCustomProperties {
    $mitt: Emitter
    $toasted: any
    $trans: any
    $accessor: typeof accessorType
  }
}

declare module 'v-click-outside'
declare module 'vue-feather-icons'
