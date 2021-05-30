<template>
  <div>
    <h2
      v-text="$trans('project.titles.webhooks')"
      class="text-2xl dark:text-white font-medium mb-6"
    />

    <div class="text-gray-700 mb-4">
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

    <div>
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
          class="flex justify-between border border-gray-300 p-3 rounded mb-4"
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
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { defineComponent, onMounted, Ref, ref, useRoute } from '@nuxtjs/composition-api'

  import ImageRules from '@/components/ImageRules/index.vue'
  import AppSecretKey from '@/components/AppSecretKey/index.vue'
  import useAccessor from '~/composables/useAccessor'
  import useWait from '~/composables/useWait'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'
  import useFileChange from '~/composables/useFileChange'
  import { Project } from '~/types/project'
  import useAxios from '~/composables/useAxios'
  import { Webhook } from '~/types/webhook'
  import { PaginateResponse } from '~/types/pagination'

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

      const { name, slug, description, url, avatar_url } = accessor.project.getProject as Project

      const webhooks: Ref<Array<Webhook>> = ref([])

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
        // @ts-ignore
        refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return

            // const { name, slug, description, url } = formData.value

            // updateProject({
            //   name,
            //   slug,
            //   description,
            //   url,
            //   avatar: files.value[0]
            // }, 'updating project informations')
          })
      }

      return {
        submitted,
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
