<template>
  <div class="task flex items-start">
    <TaskCheck
      :state="task.state"
      class="bg-white rounded-full mr-4 mt-1"
    />
    <div
      class="flex flex-col flex-1"
    >
      <p>
        {{ task.content }}
      </p>
      <MarkAsButton
        v-if="$accessor.getAuthUser && task.user.uuid === $accessor.getAuthUser.uuid && task.state !== 'done'"
        :task="task"
        class="my-4"
      />
    </div>
    <div class="hidden md:flex items-center mt-1">
      <nuxt-link
        :to="{
          name: 'Task',
          params: {
            username: task.user.username,
            task: task.uuid
          }
        }"
        class="mr-2 text-sm text-gray-600 truncate flex-shrink hover:underline"
      >
        {{ date }}
      </nuxt-link>
      <CommentButton
        :task="task"
        class="mr-4"
      />
      <LikeButton
        :task="task"
        class="mr-4"
      />
      <TaskActions
        v-if="$accessor.getAuthUser && task.user.uuid === $accessor.getAuthUser.uuid"
        :task="task"
      />
    </div>

    <!-- Dialogs -->
    <LikesDialog
      v-if="dialogs.likes.visible"
      :task="dialogs.likes.task"
      @close="() => dialogs.likes.visible = false"
    />
  </div>
</template>

<script lang="ts">
  import dayjs from 'dayjs'
  import { computed, defineComponent, toRefs } from '@nuxtjs/composition-api'

  import TaskCheck from '@/components/TaskCheck/index.vue'
  import MarkAsButton from './MarkAsButton/index.vue'
  import LikeButton from './LikeButton/index.vue'
  import CommentButton from './CommentButton/index.vue'
  import LikesDialog from '@/components/Task/LikesDialog/index.vue'
  import TaskActions from './TaskActions/index.vue'

  import { Task } from '@/types/task'

  export default defineComponent({
    name: 'Task',
    components: {
      TaskCheck,
      LikeButton,
      CommentButton,
      LikesDialog,
      TaskActions,
      MarkAsButton
    },
    props: {
      task: {
        type: Object as () => Task,
        required: true
      }
    },
    setup (props) {
      const { task } = toRefs(props)

      const date = computed(() => {
        return dayjs(task.value.created_at).format('LT')
      })

      return {
        date
      }
    },
    data () {
      return {
        dialogs: {
          likes: {
            visible: false,
            task: null
          }
        }
      }
    },
    mounted () {
      this.$mitt.on(`like dialog for ${this.task.uuid}`, this.showLikeDialog)
    },
    beforeDestroy () {
      this.$mitt.off(`like dialog for ${this.task.uuid}`, this.showLikeDialog)
    },
    methods: {
      showLikeDialog (e: any) {
        this.dialogs.likes = {
          visible: true,
          task: e
        }
      }
    }
  })
</script>
