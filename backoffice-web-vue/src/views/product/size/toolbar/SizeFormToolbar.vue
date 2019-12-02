<template>
  <div class="animated fadeIn">
<!--    <el-button-group v-if="!readOnly">-->
<!--      <el-button size="mini" type="primary" @click="onSubmit()">提交</el-button>-->
<!--      <el-button size="mini" @click="onCancel">取消</el-button>-->
<!--    </el-button-group>-->
    <!--<el-button-group v-if="readOnly">
      <el-button size="mini" type="primary">提交</el-button>
    </el-button-group>-->
    <el-row class="color-button" type="flex" justify="center" align="middle" :gutter="100">
      <el-col :span="6">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">
          提交
        </el-button>
      </el-col>
      <el-col :span="6">
        <el-button class="btn-block" size="mini" @click="onCancel">
          取消
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'SizeFormToolbar',
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
<style scoped>
  .color-button {
    margin-left: 20px;
    margin-top: 20px;
  }
</style>
