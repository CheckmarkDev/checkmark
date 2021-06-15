<template>
  <div
    class="inline-flex"
  >
    <span
      v-text="formattedSecret"
    />

    <button
      :title="$trans('project.labels.toggle_secret')"
      type="button"
      class="ml-2 focus:outline-none hover:bg-gray-200 p-1 text-gray-700 rounded dark:hover:bg-gray-800 dark:text-gray-300"
      @click="toggle"
    >
      <EyeOffIcon
        v-if="visible"
        size="20"
      />
      <EyeIcon
        v-else
        size="20"
      />
    </button>
  </div>
</template>

<script lang="ts">
  import { defineComponent, ref, toRefs, computed } from '@vue/composition-api'
  import { EyeIcon, EyeOffIcon } from 'vue-feather-icons'

  export default defineComponent({
    components: {
      EyeIcon,
      EyeOffIcon
    },
    props: {
      secret: {
        type: String,
        required: true
      }
    },
    setup (props) {
      const visible = ref(false)
      const { secret } = toRefs(props)

      const formattedSecret = computed(() => {
        if (visible.value) {
          return secret.value
        }

        return new Array(secret.value.length).fill('*').join('')
      })

      function toggle () {
        visible.value = !visible.value
      }

      return {
        visible,
        toggle,
        formattedSecret
      }
    }
  })
</script>
