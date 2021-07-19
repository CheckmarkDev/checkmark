<template>
  <div class="task flex flex-col">
    <div class="flex items-start">
      <TaskCheck
        :state="task.state"
        :source="task.source"
        class="bg-white dark:bg-gray-600 rounded-full mr-4 mt-1"
      />
      <div
        class="flex flex-col flex-1"
      >
        <TaskContent
          :task="task"
        />
        <MarkAsButton
          v-if="$accessor.getAuthUser && task.user.uuid === $accessor.getAuthUser.uuid && task.state !== 'done'"
          :task="task"
          class="my-4 mr-auto"
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
          class="mr-2 text-sm text-gray-600 dark:text-gray-400 truncate flex-shrink hover:underline"
          v-text="date"
        />
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
    </div>

    <TaskImages
      v-if="task.images.length"
      :task="task"
      class="my-4"
    />

    <!-- Dialogs -->
    <LikesDialog
      v-if="dialogs.likes.visible"
      :task="dialogs.likes.task"
      @close="() => dialogs.likes.visible = false"
    />
    <EditDialog
      v-if="dialogs.edit.visible"
      :task="dialogs.edit.task"
      @close="() => dialogs.edit.visible = false"
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
  import EditDialog from '@/components/Task/EditDialog/index.vue'
  import TaskActions from './TaskActions/index.vue'
  import TaskContent from './TaskContent/index.vue'
  import TaskImages from './TaskImages/index.vue'

  import { Task } from '@/types/task'

  export default defineComponent({
    name: 'Task',
    components: {
      TaskCheck,
      LikeButton,
      CommentButton,
      LikesDialog,
      TaskActions,
      EditDialog,
      MarkAsButton,
      TaskContent,
      TaskImages
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
          },
          edit: {
            visible: false,
            task: null
          }
        }
      }
    },
    mounted () {
      this.$mitt.on(`like dialog for ${this.task.uuid}`, this.showLikeDialog)
      this.$mitt.on(`edit dialog for ${this.task.uuid}`, this.showEditDialog)
    },
    beforeDestroy () {
      this.$mitt.off(`like dialog for ${this.task.uuid}`, this.showLikeDialog)
      this.$mitt.off(`edit dialog for ${this.task.uuid}`, this.showEditDialog)
    },
    methods: {
      showLikeDialog (e: any) {
        this.dialogs.likes = {
          visible: true,
          task: e
        }
      },
      showEditDialog (e: any) {
        this.dialogs.edit = {
          visible: true,
          task: e
        }
      }
    }
  })
</script>
