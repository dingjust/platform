<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div class="contract_custom">
        <el-tabs tab-position="right" v-model="activeName">
          <el-tab-pane name="first">
            <span slot="label">
              <i class="el-icon-document"></i> 委托生产合同
            </span>
            <ContractDetails :propdata="tempdata1" />
          </el-tab-pane>
          <el-tab-pane name="second">
            <span slot="label">
              <i class="el-icon-document"></i> 生产订单合同
            </span>
            <ContractDetails :propdata="tempdata2" />
          </el-tab-pane>
          <el-tab-pane name="third">
            <span slot="label" style="text-align: left;">
              <i class="el-icon-document"></i> 框架主合同
            </span>
            <ContractDetails :propdata="tempdata3" />
          </el-tab-pane>
        </el-tabs>
      </div>
    </el-card>
  </div>
</template>

<script>
  import ContractDetails from "../manage/components/contractDetails.vue";
  export default {
    name: "ContractTemplate",
    data() {
      return {
        activeName: "",
        tempdata1: "",
        tempdata2: "",
        tempdata3: "",
        tagtodata: {
          first: "tempdata1",
          second: "tempdata2",
          third: "tempdata3"
        },
        tagtoname: {
          first: "委托生产合同",
          second: "生产订单合同",
          third: "框架主合同"
        }
      };
    },
    components: {
      ContractDetails
    },
    mounted() {
      this.activeName = "first";
    },
    watch: {
      activeName(newValue, oldValue) {
        this.$data[this.tagtodata[newValue]] = {
          contractName: this.tagtoname[newValue]
        };
      }
    },
    methods: {
      handleClick(tab, event) {
      }
    }
  };

</script>

<style lang="scss">
  .contract_custom .el-tabs__item {
    text-align: left;
  }

</style>
