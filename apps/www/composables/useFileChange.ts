import { Ref, ref } from '@nuxtjs/composition-api'

export default function useFileChange (defaultPreview: string) {
  const preview = ref(defaultPreview)
  const file: Ref<File|null> = ref(null)

  function fileChange (e: Event) {
    if (e) {
      const files = (e.target as HTMLInputElement).files
      if (files && files.length) {
        file.value = files[0]
        const reader = new FileReader()
        reader.onload = v => {
          if (v.target && v.target.result) {
            preview.value = v.target.result as string
          }
        }
        reader.readAsDataURL(files[0])
      }
    }
  }

  return {
    fileChange,
    file,
    preview
  }
}
