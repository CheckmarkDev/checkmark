import { useContext } from '@nuxtjs/composition-api'
import { NuxtAxiosInstance } from '@nuxtjs/axios'

export default function useAxios(): NuxtAxiosInstance {
  const { $axios } = useContext()

  return $axios
}
