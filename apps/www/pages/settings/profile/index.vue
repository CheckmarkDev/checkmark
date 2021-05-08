<template>
  <div>
    <h2
      v-text="$trans('settings.titles.profile')"
      class="text-2xl font-medium text-gray-800 mb-8"
    />

    <!-- Profile picture -->
    <ValidationObserver
      ref="observer"
    >
      <form
        :disabled="$wait.is('updating profile picture')"
        class="flex flex-col md:flex-row"
        @submit.prevent="submitted"
      >
        <div class="mr-8 flex-shrink-0 mb-4 md:mb-0">
          <AppAvatar
            :src="previewUrl"
            width="150"
            height="150"
          />
        </div>
        <div>
          <h3
            v-text="$trans('settings.titles.profile_picture')"
            class="text-lg text-gray-700 font-medium mb-2"
          />
          <div class="mb-3 border border-solid border-gray-300 rounded p-2">
            <input
              type="file"
              name="image"
              id="image"
              accept="image/*"
              class="w-full"
              @change="fileChange"
            >
          </div>
          <h3
            v-text="$trans('settings.titles.profile_rules')"
            class="text-base text-gray-700 font-medium mb-2"
          />
          <p
            v-text="$trans('settings.paragraphs.profile_rules')"
            class="text-base text-gray-700 mb-1"
          />
          <ul class="text-base text-gray-700 list-disc pl-4 mb-8">
            <li
              v-text="$trans('settings.paragraphs.profile_rules.racism')"
            />
            <li
              v-text="$trans('settings.paragraphs.profile_rules.nsfw')"
            />
          </ul>

          <button
            :disabled="$wait.is('updating profile picture')"
            v-text="$trans('global.buttons.save')"
            type="submit"
            class="btn btn-primary"
          />
        </div>
      </form>
    </ValidationObserver>
  </div>
</template>

<script lang="ts">
  import { defineComponent } from '@nuxtjs/composition-api'

  import AppAvatar from '@/components/AppAvatar/index.vue'

  export default defineComponent({
    components: {
      AppAvatar
    },
    data () {
      return {
        previewUrl: null as string|null,
        formData: {
          image: null
        } as {
          image: Blob|null
        }
      }
    },
    mounted () {
      if (this.$accessor.getAuthUser) {
        this.previewUrl = this.$accessor.getAuthUser.avatar_url
      }
    },
    methods: {
      fileChange (file: Event) {
        console.log('file', file.target.files)
        var reader = new FileReader();
        reader.onload = e => {
          console.log('on load', e.target.result)
          this.previewUrl = e.target.result
        }

        reader.readAsDataURL(file.target.files[0]); // convert to base64 string
      },
      submitted () {
        // @ts-ignore
        this.$refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            const { image } = this.formData

            const formData = new FormData()
            formData.append('avatar', image)

            this.$wait.start('updating profile picture')
            this.$axios.put('/me/profile', formData, {
              headers: {
                'Content-Type': 'multipart/form-data'
              }
            })
              .then(() => {
                this.$toasted.success(this.$trans('settings.paragraphs.settings_saved'))
              })
              .finally(() => {
                this.$wait.end('updating profile picture')
              })
          })
      }
    }
  })
</script>
