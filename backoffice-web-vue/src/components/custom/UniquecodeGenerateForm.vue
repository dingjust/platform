<template>
  <div class="uniquecode-form-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">唯一码生成</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="center">
      <h6>{{slotData.uniqueCode}}</h6>
    </el-row>
    <el-row type="flex" justify="center">
      <el-button class="purchase-order-btn" @click="onGenerate">生成唯一码</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'UniquecodeGenerateForm',
    props: ['slotData'],

    components: {

    },
    mixins: [],
    computed: {

    },
    methods: {
      async onGenerate() {
        const url = this.apis().generateUniqueCode(this.slotData.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('生成唯一码成功');
        this.$set(this.slotData, 'uniqueCode', result);
      },
    },
    data() {
      return {}
    },
    created() {

    },
    mounted() {}

  }

</script>
<style>
  .uniquecode-form-body {
    width: 100%;
  }

</style>
