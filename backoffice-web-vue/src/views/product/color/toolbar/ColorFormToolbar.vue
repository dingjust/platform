<template>
  <div class="animated fadeIn">
    <el-button-group v-if="!readOnly">
      <el-button size="mini" type="primary" @click="onSubmit()">提交</el-button>
      <el-button size="mini" @click="onCancel">取消</el-button>
    </el-button-group>
    <!--<el-button-group v-if="readOnly">
      <el-button size="mini" type="primary">提交</el-button>
    </el-button-group>-->
  </div>
</template>

<script>
  export default {
    name: 'ColorFormToolbar',
    props: ['readOnly'],
    mixins: [],
    components: {},
    computed: {},
    methods: {
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
