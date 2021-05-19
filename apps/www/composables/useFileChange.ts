import { Ref, ref } from '@nuxtjs/composition-api'

export default function useFileChange (defaultPreview: string) {
  const targetInput: Ref<HTMLInputElement|null> = ref(null)
  const preview = ref(defaultPreview)
  const file: Ref<File|null> = ref(null)

  function fileChange (e: Event) {
    if (e) {
      targetInput.value = (e.target as HTMLInputElement)
      const files = targetInput.value.files
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

  function clear () {
    file.value = null
    if (targetInput.value) {
      targetInput.value.value = ''
    }
  }

  return {
    fileChange,
    clear,
    file,
    preview
  }
}
