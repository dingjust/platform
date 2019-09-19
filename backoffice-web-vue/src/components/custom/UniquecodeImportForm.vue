<template>
  <div class="uniquecode-form-body">
    <el-row class="uniquecode-form-title-row">
      <div class="uniquecode-form-title">
        <h6 class="uniquecode-form-title_text">唯一码导入</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="center">
      <el-input v-model="uniqueCode" placeholder="输入唯一码">
        <el-button slot="append" @click="onSearch">检索</el-button>
      </el-input>
    </el-row>
    <div v-if="order!=''" class="uniquecode-form-order">
      <el-row type="flex" justify="space-between">
        <h6 class="uniquecode-form-text">订单编号:{{order.code}}</h6>
        <h6 class="uniquecode-form-text">创建时间:{{order.creationtime | formatDate}}</h6>
      </el-row>
      <el-row type="flex" justify="space-between">
        <el-col :span="10">
          <img width="60px" height="60px"
            :src="order.product.thumbnail!=null&&order.product.thumbnail.length!=0?order.product.thumbnail.url:'static/img/nopicture.png'">
          </img>
        </el-col>
        <el-col :span="14">
          <h6 class="uniquecode-form-text">产品名:{{order.product.name}}</h6>
          <h6 class="uniquecode-form-text">货号:{{order.product.skuID}}</h6>
          <h6 class="uniquecode-form-text">{{name}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center">
        <el-button class="uniquecode-form-btn" @click="onImport">导入唯一码</el-button>
      </el-row>
    </div>
  </div>
</template>

<script>
  export default {
    name: "UniquecodeImportForm",
    components: {},
    mixins: [],
    computed: {
      name: function () {
        if (this.order.belongTo != null) {
          return this.order.belongTo.name;
        } else {
          return this.order.purchaser.name;
        }
      }
    },
    methods: {
      async onSearch() {
        const url = this.apis().getDetailsForUniqueCode(this.uniqueCode);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.order = result;
      },
      async onImport() {
        const url = this.apis().linkUniqueCode(this.uniqueCode);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("导入成功");
        this.$router.push("order/purchase");
      }
    },
    data() {
      return {
        uniqueCode: "",
        order: ""
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
