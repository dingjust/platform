<template>
  <div class="animated fadeIn">
    <el-button-group v-if="readOnly">
      <el-button size="mini" type="primary" @click="onSubmit()">提交</el-button>
      <el-button size="mini" @click="onCancel">取消</el-button>
    </el-button-group>
    <el-button v-if="isTenant()&&!readOnly" size="mini" type="primary" @click="onUpdate()">修改</el-button>
  </div>
</template>

<script>
  export default {
    name: 'OperationCourseFormToolbar',
    props: ['readOnly'],
    mixins: [],
    components: {},
    computed: {},
    methods: {
      onUpdate() {
        this.$emit('onUpdate');
      },
      onSubmit() {
        this.$emit('onSubmit');
      },
      onCancel() {
        this.$emit('onCancel');
      }
    },
    data() {
      return {}
    }
  }
</script>
