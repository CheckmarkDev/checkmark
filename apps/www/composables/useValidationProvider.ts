import { Ref } from '@vue/composition-api'
import { ProviderInstance } from 'vee-validate/dist/types/types'

export default function useValidationProvider (err: any, refs: any) {
  const { errors } = err.response.data
  if (errors) {
    Object.keys(errors).forEach(key => {
      const provider = refs[`${key}-provider`] as ProviderInstance
      if (provider) {
        provider.setErrors(errors[key])
      }
    })
  }
}