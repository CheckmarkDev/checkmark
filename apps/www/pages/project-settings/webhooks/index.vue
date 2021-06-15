<template>
  <div>
    <h2
      v-text="$trans('project.titles.webhooks')"
      class="text-2xl dark:text-white font-medium mb-6"
    />

    <div class="text-gray-700 dark:text-gray-300 mb-4">
      <h3
        class="font-medium text-base mb-3"
        v-text="$trans('project.titles.webhooks_how_it_works')"
      />

      <p
        class="mb-2"
        v-text="$trans('project.paragraphs.webhooks.purpose')"
      />
      <p
        class="mb-2"
        v-text="$trans('project.paragraphs.webhooks.request')"
      />
    </div>

    <div
      class="mb-6"
    >
      <h3
        class="font-medium text-base mb-3"
        v-text="$trans('project.titles.webhooks')"
      />

      <template
        v-if="webhooks.length"
      >
        <div
          v-for="webhook in webhooks"
          :key="webhook.uuid"
          class="flex flex-col md:flex-row justify-between border border-gray-300 p-3 rounded mb-4"
        >
          <div>
            <div>
              {{ $trans('project.labels.url') }}: {{ webhook.url }}
            </div>
            <div>
              {{ $trans('project.labels.created_at', {
                date: webhook.created_at
              }) }}
            </div>
            <div>
              {{ $trans('project.labels.webhook_secret') }}: <AppSecretKey :secret="webhook.secret" />
            </div>
          </div>
          <div>
            <button
              :disabled="$wait.is(`deleting ${webhook.uuid}`)"
              class="btn btn-danger"
              type="button"
              @click="remove(webhook.uuid)"
            >
              {{ $trans('global.buttons.delete') }}
            </button>
          </div>
        </div>
      </template>
      <template
        v-else
      >
        <p
          v-text="$trans('project.paragraphs.no_webhooks')"
        />
      </template>
    </div>

    <ValidationObserver
      ref="observer"
      class="md:w-2/3"
      tag="div"
    >
      <h3
        v-text="$trans('project.titles.new_webhook')"
        class="font-medium text-base mb-3"
      />

      <form
        :disabled="$wait.is('creating a webhook')"
        @submit.prevent="submitted"
      >
        <ValidationProvider
          ref="url-provider"
          rules="required"
          v-slot="{ invalid, errors }"
        >
          <label
            for="url"
            v-text="`${$trans('project.labels.url')} *`"
          />
          <input
            v-model="formData.url"
            :disabled="$wait.is('creating a webhook')"
            class="input"
            type="url"
            name="url"
            id="url"
            required
          >
          <span
            v-if="invalid"
            v-text="errors[0]"
            class="text-red-500 text-sm"
            role="alert"
          />
        </ValidationProvider>

        <button
          :disabled="$wait.is('creating a webhook')"
          class="btn btn-primary mt-6"
        >
          {{ $trans('global.buttons.save') }}
        </button>
      </form>
    </ValidationObserver>
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { defineComponent, onMounted, reactive, Ref, ref } from '@nuxtjs/composition-api'

  import ImageRules from '@/components/ImageRules/index.vue'
  import AppSecretKey from '@/components/AppSecretKey/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import useWait from '~/composables/useWait'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'
  import useValidationProvider from '~/composables/useValidationProvider'
  import { Project } from '~/types/project'
  import useAxios from '~/composables/useAxios'
  import { Webhook } from '~/types/webhook'
  import { PaginateResponse } from '~/types/pagination'
  import { ProviderInstance } from 'vee-validate/dist/types/types'

  export default defineComponent({
    components: {
      ImageRules,
      AppSecretKey
    },
    setup (props, { refs }) {
      const wait = useWait()
      const accessor = useAccessor()
      const trans = useICU()
      const toasted = useToasted()
      const axios = useAxios()

      const { slug } = accessor.project.getProject as Project

      const webhooks: Ref<Array<Webhook>> = ref([])
      const formData = reactive({
        url: null
      })

      function fetchWebhooks () {
        wait.start('fetching project webhooks')
        axios.$get(`/me/projects/${slug}/webhooks`)
          .then((res: PaginateResponse<Webhook>) => {
            webhooks.value = res.data.map(webhook => ({
              ...webhook,
              created_at: dayjs(webhook.created_at).format('LLL')
            }))
          })
          .finally(() => {
            wait.end('fetching project webhooks')
          })
      }

      onMounted(() => {
        fetchWebhooks()
      })

      function remove (uuid: string) {
        wait.start(`deleting ${uuid}`)
        axios.delete(`/me/projects/${slug}/webhooks/${uuid}`)
          .then(() => {
            fetchWebhooks()
          })
          .finally(() => {
            wait.end(`deleting ${uuid}`)
          })
      }

      function submitted () {
        const observer = refs.observer as ProviderInstance
        observer.validate()
          .then(valid => {
            if (!valid) return

            const { url } = formData

            wait.start('creating a webhook')
            axios.post(`/me/projects/${slug}/webhooks`, {
              url
            })
              .then(() => {
                formData.url = null
                observer.reset()

                fetchWebhooks()

                toasted.success(trans('project.paragraphs.webhook_created'))
              })
              .catch(err => {
                if (!err.response) return

                useValidationProvider(err, refs)
              })
              .finally(() => {
                wait.end('creating a webhook')
              })
          })
      }

      return {
        submitted,
        formData,
        remove,
        webhooks
      }
    },
    head () {
      const title = this.$trans('project.titles.webhooks')

      return {
        title,
        meta: [
          { hid: 'og:title', property: 'og:title', content: title }
        ]
      }
    }
  })
</script>
