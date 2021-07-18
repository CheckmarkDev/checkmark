<template>
  <div class="flex fixed top-0 left-0 w-full h-full bg-gray-800 bg-opacity-50 z-20">
    <div class="edit-dialog__content w-full bg-white dark:bg-gray-700 dark:text-white m-auto p-4 md:p-8">
      <div class="flex items-center justify-between mb-8">
        <h1 class="font-medium text-xl">
          {{ $trans('global.titles.edit_task') }}
        </h1>
        <button
          type="button"
          @click="$emit('close')"
        >
          <XIcon
            size="24"
          />
        </button>
      </div>
      <div>
        <apollo-mutation
          :mutation="updateTask"
          @done="done"
        >
          <template v-slot="{ mutate, loading }">
            <ValidationObserver
              ref="observer"
              slim
            >
              <form
                :disabled="loading"
                @submit.prevent="submitted(mutate)"
              >
                <ValidationProvider
                  rules="required"
                  :name="$trans('sign-in.labels.email')"
                  class="flex flex-col"
                >
                  <div class="flex flex-col">
                    <TaskStateSwitch
                      v-model="formData.state"
                      class="mb-4"
                    />
                    <div class="w-full">
                      <textarea
                        :disabled="loading"
                        id="task"
                        v-model="formData.content"
                        :placeholder="$trans('home.labels.done_placeholder')"
                        name=""
                        class="textarea w-full mb-2 p-2 rounded-bl rounded-br rounded-tr appearance-none leading-relaxed border border-gray-300 border-solid"
                      ></textarea>
                    </div>

                    <!-- Images -->
                    <h2
                      v-text="$trans('project.titles.images')"
                      class="text-lg mb-2"
                    />
                    <TaskImageEdition
                      :images.sync="editableImages"
                      class="mb-6"
                      @remove="remove"
                    />

                    <button
                      :disabled="loading"
                      class="btn btn-primary w-full md:w-auto"
                      type="submit"
                    >
                      {{ $trans('home.buttons.edit') }}
                    </button>
                  </div>
                </ValidationProvider>
              </form>
            </ValidationObserver>
          </template>
        </apollo-mutation>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, toRefs, reactive, ref } from '@nuxtjs/composition-api'
  import gql from 'graphql-tag'
  import { XIcon } from 'vue-feather-icons'
  import { Task } from '~/types/task'
  import UserCard from '@/components/UserCard/index.vue'
  import TaskStateSwitch from './TaskStateSwitch/index.vue'
  import TaskImageEdition from './TaskImageEdition/index.vue'

  // @ts-ignore
  import userFragment from '@/apollo/fragments/user.gql'
  // @ts-ignore
  import taskFragment from '@/apollo/fragments/task.gql'

  export default defineComponent({
    components: {
      XIcon,
      UserCard,
      TaskStateSwitch,
      TaskImageEdition
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props, { refs, emit }) {
      const updateTask = gql`
        mutation updateTask ($taskUuid: String!, $content: String, $state: String) {
          update_task (input: {taskUuid: $taskUuid, content: $content, state: $state }) {
            task {
              ...task
              task_group {
                uuid
              }
            }
          }
        }

        ${userFragment}
        ${taskFragment}
      `

      const { task } = toRefs(props)
      const formData = reactive({
        content: task.value.content,
        state: task.value.state
      })


      const editableImages = ref(Array.from(task.value.images))

      function remove (image) {
        const index = editableImages.value.findIndex(v => v === image)
        if (index !== -1) {
          editableImages.value.splice(index, 1)
        }
      }

      function done () {
        formData.content = ''
        emit('close')
      }

      function submitted (mutate: Function): void {
        // @ts-ignore
        refs.observer.validate()
          .then((valid: boolean) => {
            if (!valid) return
            const { content, state } = formData
            // const images = []

            // editableImages.value.forEach(image => {
            //   images.push(image.uuid || image.file)
            // })

            mutate({
              variables: {
                taskUuid: task.value.uuid,
                content,
                state
              }
            })

            // $axios.put(`/me/tasks/${task.uuid}`, data, {
            //   headers: {
            //     'Content-Type': 'multipart/form-data'
            //   }
            // })
            //   .then(() => {
            //     data.content = ''
            //     $toasted.success($trans('home.paragraphs.task_edited'))
            //     $mitt.emit('update-tasks')
            //     $emit('close')
            //   })
            //   .finally(() => {
            //     $wait.end('updating task')
            //   })
          })
      }

      return {
        formData,
        updateTask,
        editableImages,
        remove,
        submitted,
        done
      }
    }
  })
</script>

<style scoped>
  .edit-dialog__content {
    max-width: 480px;
  }
</style>
