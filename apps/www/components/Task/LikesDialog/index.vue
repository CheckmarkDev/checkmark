<template>
  <div class="flex fixed top-0 left-0 w-full h-full bg-gray-800 bg-opacity-50 z-20">
    <div class="likes-dialog__content w-full bg-white m-auto p-4 md:p-8">
      <div class="flex items-center justify-between mb-8">
        <h1 class="font-medium text-xl">
          {{ $trans('global.titles.reactions') }}
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
        <template
          v-if="likes"
        >
          <template
            v-if="likes.data.length > 0"
          >
            <div
              v-for="like in likes.data"
              :key="like.uuid"
              class="mb-8"
            >
              <nuxt-link
                :to="{
                  name: 'User',
                  params: {
                    username: like.user.username
                  }
                }"
              >
                <UserCard
                  :user="like.user"
                />
              </nuxt-link>
            </div>
          </template>
          <template
            v-else
          >
            <p>
              {{ $trans('global.paragraphs.no_reactions') }}
            </p>
          </template>
        </template>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
  import { defineComponent, onMounted, ref, toRefs, Ref } from '@nuxtjs/composition-api'
  import { XIcon } from 'vue-feather-icons'
  import { PaginateResponse } from '~/types/pagination'
  import { Task } from '~/types/task'
  import { Like } from '~/types/like'
  import useAxios from '~/composables/useAxios'
  import UserCard from '@/components/UserCard/index.vue'

  export default defineComponent({
    components: {
      XIcon,
      UserCard
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)
      const axios = useAxios()

      const likes: Ref<PaginateResponse<Like>|null> = ref(null)

      onMounted(() => {
        axios.$get(`/tasks/${task.value.uuid}/likes`)
          .then((res) => {
            likes.value = res
          })
      })

      return {
        likes
      }
    }
  })
</script>

<style scoped>
  .likes-dialog__content {
    max-width: 480px;
  }
</style>
