<template>
  <apollo-mutation
    :mutation="createComment"
    :variables="{
      taskUuid: task.uuid,
      content: formData.content
    }"
    :update="updateCache"
    @done="done"
  >
    <template v-slot="{ mutate, loading, error }">
      <ValidationObserver
        ref="observer"
      >
        <form
          :disabled="loading"
          class="flex flex-col md:flex-row items-start"
          @submit.prevent="mutate"
        >
          <UserAvatar
            :user="$accessor.getAuthUser"
            class="hidden md:flex mr-8"
          />
          <div class="flex flex-1 w-full mb-4 md:mb-0 md:mr-4">
            <ValidationProvider
              ref="content-provider"
              :name="$trans('global.labels.comment').toLowerCase()"
              rules="required|min:2|max:1000"
              v-slot="{ invalid, errors }"
              class="block w-full"
            >
              <label
                for="content"
                v-text="$trans('global.labels.comment')"
                class="hidden"
              />
              <textarea
                v-model="formData.content"
                name="content"
                class="flex-1 p-2 rounded-bl rounded-br rounded-tr appearance-none leading-relaxed border border-gray-300 border-solid dark:bg-gray-600 dark:border-gray-600 dark:text-white w-full"
                id="content"
                required
                maxlength="1000"
                minlength="2"
              ></textarea>
              <span
                v-if="invalid && errors[0]"
                v-text="errors[0]"
                role="alert"
                class="text-left text-sm text-red-500"
              />
              <span
                v-if="error"
                v-text="error"
                role="alert"
                class="text-left text-sm text-red-500"
              />
            </ValidationProvider>
          </div>
          <button
            :disabled="loading"
            :title="$trans('global.buttons.send')"
            type="submit"
            class="btn btn-primary w-full md:w-auto"
          >
            <div class="flex items-center">
              <img src="@/assets/img/icons/send.svg" alt="">
              <span
                v-text="$trans('global.buttons.send')"
                class="md:hidden ml-2"
              />
            </div>
          </button>
        </form>
      </ValidationObserver>
    </template>
  </apollo-mutation>
</template>

<script lang="ts">
  import { defineComponent, ref, toRefs } from '@nuxtjs/composition-api'
  import gql from 'graphql-tag'

  import useAxios from '~/composables/useAxios'
  import useICU from '~/composables/useICU'
  import useToasted from '~/composables/useToasted'
  import useWait from '~/composables/useWait'
  import useMitt from '~/composables/useMitt'
  import { Task } from '~/types/task'
  import allCommentsQuery from '@/apollo/queries/allComments.gql'

  export default defineComponent({
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props, { refs }) {
      const { task } = toRefs(props)
      const wait = useWait()
      const axios = useAxios()
      const toasted = useToasted()
      const trans = useICU()
      const mitt = useMitt()

      const formData = ref({
        content: null
      })

      const createComment = gql`
        mutation CreateComment ($taskUuid: String!, $content: String!) {
          create_comment (input: { taskUuid: $taskUuid, content: $content }) {
            comment {
              uuid
              content
              created_at
              user {
                uuid
                username
                first_name
                last_name
                streak
                avatar_url
              }
            }
          }
        }
      `

      /**
       * Once we have the data, we want to update the list of comments.
       * Fetch the all_comments query to append on top of the list the new comment
       */
      function updateCache (cache, { data: { create_comment: comment } }) {
        const data = cache.readQuery({
          query: allCommentsQuery,
          variables: {
            taskUuid: task.value.uuid
          }
        })
        data.all_comments.nodes.unshift(comment.comment)
        cache.writeQuery({ query: allCommentsQuery, data })
      }

      function done () {
        if (refs.observer) {
          // @ts-ignore
          refs.observer.reset()
        }

        formData.value.content = null
        toasted.success(trans('user.paragraphs.commented'))
      }

      return {
        createComment,
        updateCache,
        formData,
        done
      }
    },
  })
</script>
