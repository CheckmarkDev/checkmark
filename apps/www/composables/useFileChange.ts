import { Ref, ref } from '@nuxtjs/composition-api'

export default function useFileChange (defaultPreview?: string) {
  const targetInput: Ref<HTMLInputElement|null> = ref(null)
  const previews: Ref<Array<string>> = ref([])
  const files: Ref<Array<File>> = ref([])

  if (defaultPreview) {
    previews.value = [
      defaultPreview
    ]
  }

  function fileChange (e: Event) {
    if (e) {
      targetInput.value = (e.target as HTMLInputElement)
      const inputFiles = targetInput.value.files

      if (inputFiles && inputFiles.length) {
        previews.value = []

        files.value = Array.from(inputFiles)
        files.value.forEach(file => {
          const reader = new FileReader()
          reader.onload = v => {
            if (v.target && v.target.result) {
              previews.value.push(v.target.result as string)
            }
          }

          reader.readAsDataURL(file)
        })
      }
    }
  }

  function clear () {
    files.value = []
    if (targetInput.value) {
      targetInput.value.value = ''
    }
  }

  return {
    fileChange,
    clear,
    files,
    previews
  }
}
