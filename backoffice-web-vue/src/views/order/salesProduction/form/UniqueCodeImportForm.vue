<template>
  <div class="uniquecode-form-body">
    <el-row class="uniquecode-form-title-row">
      <div class="uniquecode-form-title">
        <h6 class="uniquecode-form-title_text">唯一码导入</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="center">
      <el-input v-model="uniqueCode" placeholder="输入唯一码">
        <el-button slot="append" @click="onSure">确定</el-button>
      </el-input>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "UniqueCodeImportForm",
    components: {},
    mixins: [],
    computed: {

    },
    methods: {
      async onSure() {
        const url = this.apis().importSalesOrderByUniqueCode(this.uniqueCode);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("导入成功");
        this.$emit('callback');
      }
    },
    data() {
      return {
        uniqueCode: "",
      };
    },
    created() {},
    mounted() {}
  };

</script>
<style>
  .uniquecode-form-body {
    width: 100%;
  }

  .uniquecode-form-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .uniquecode-form-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .uniquecode-form-title-row {
    margin-bottom: 20px;
  }

  .uniquecode-form-order {
    background-color: rgba(0, 0, 0, 0.02);
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
    margin-top: 20px;
  }

  .uniquecode-form-text {
    font-size: 12px;
    color: rgba(51, 48, 48, 0.65);
  }

  .uniquecode-form-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    margin-top: 20px;
  }

</style>
