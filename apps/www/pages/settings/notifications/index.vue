<template>
  <div>
    <h2 class="text-2xl">
      {{ $trans('settings.titles.notifications') }}
    </h2>

    <ValidationObserver
      ref="observer"
      slim
    >
      <form
        :disabled="$wait.is('saving settings')"
        class="flex flex-col mt-4"
        @submit.prevent="submitted"
      >
        <div class="flex flex-col mb-4 md:mb-0">
          <div class="flex items-center mb-4">
            <input
              v-model="formData.like"
              class="mr-4"
              type="checkbox"
              name="like"
              id="like"
            >
            <label for="like">
              {{ $trans('settings.paragraphs.like') }}
            </label>
          </div>
          <div class="flex items-center mb-4">
            <input
              v-model="formData.comment"
              class="mr-4"
              type="checkbox"
              name="comment"
              id="comment"
            >
            <label for="comment">
              {{ $trans('settings.paragraphs.comment') }}
            </label>
          </div>
          <div class="flex items-center mb-4">
            <input
              v-model="formData.newsletter"
              class="mr-4"
              type="checkbox"
              name="newsletter"
              id="newsletter"
            >
            <label for="newsletter">
              {{ $trans('settings.paragraphs.newsletter') }}
            </label>
          </div>

          <button
            :disabled="$wait.is('saving settings')"
            type="submit"
            class="btn btn-primary mt-8 mr-auto"
          >
            {{ $trans('global.buttons.save') }}
          </button>
        </div>
      </form>
    </ValidationObserver>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  export default defineComponent({
    data () {
      return {
        formData: {
          like: false,
          comment: false,
          newsletter: false
        }
      }
    },
    async asyncData ({ $axios }) {
      const notifications = await $axios.$get('/me/email_notifications')

      return {
        formData: {
          like: notifications.like,
          comment: notifications.comment,
          newsletter: notifications.newsletter
        }
      }
    },
    methods: {
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { like, comment, newsletter } = this.formData

            this.$wait.start('saving settings')
            this.$axios.put('/me/email_notifications', {
              like,
              comment,
              newsletter
            })
              .then(() => {
                this.$toasted.success(this.$trans('settings.paragraphs.settings_saved'))
              })
              .finally(() => {
                this.$wait.end('saving settings')
              })
          })
      }
    }
  })
</script>
