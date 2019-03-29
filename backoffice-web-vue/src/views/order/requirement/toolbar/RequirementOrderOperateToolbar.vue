<template>
  <div class="animated fadeIn">
    <el-button-group>
      <el-button  v-if="isTenant()" size="mini" type="primary"  @click="onReview">审核</el-button>
      <el-button v-if="readOnly&&!isFactory()" size="mini" type="primary" @click="onUpdate()">修改</el-button>
    </el-button-group>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOperateFormToolbar',
    props: ['readOnly'],
    mixins: [],
    components: {},
    computed: {},
    methods: {
      onUpdate() {
        this.$emit('onUpdate');
      },
      onReview() {
        this.$emit('onReview');
      }
    },
    data() {
      return {}
    }
  }
</script>
