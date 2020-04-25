<template>
  <div>
    <el-tabs value="first" type="card">
      <el-tab-pane label="成本预算单" name="first">
        <el-row>
          <el-col :span="6">
            <el-radio v-model="radio" :label="true">含税</el-radio>
            <el-radio v-model="radio" :label="false">不含税</el-radio>
          </el-col>
        </el-row>
        <div>
          <div class="d1">
            <el-divider></el-divider>
            <el-row type="flex" align="center">
              <el-col :span="1" class="form-column">
                <h6 class="accounting-form-title">面辅料</h6>
              </el-col>
              <el-col :span="23">
                <material-accounting-form :slotData="materialData" :taxIncluded="radio" />
              </el-col>
            </el-row>
            <el-divider></el-divider>
            <el-row type="flex" align="center">
              <el-col :span="1" class="form-column">
                <h6 class="accounting-form-title">特殊工艺</h6>
              </el-col>
              <el-col :span="23">
                <craft-accounting-form :slotData="craftData" :taxIncluded="radio" />
              </el-col>
            </el-row>
            <el-divider></el-divider>
            <el-row type="flex" align="center">
              <el-col :span="1" class="form-column">
                <h6 class="accounting-form-title">工费及其他</h6>
              </el-col>
              <el-col :span="23">
                <other-accounting-form :slotData="otherData" :taxIncluded="radio" />
              </el-col>
            </el-row>
            <div class="sheet-total">
              <el-row type="flex" align="center" justify="end">
                <div class="sheet-total-title">
                  <el-row type="flex" justify="center" align="center">
                    <h6>总计价格</h6>
                  </el-row>
                </div>
                <div style="width:160px;text-align:center">
                  <h6>￥5645646456</h6>
                </div>
              </el-row>
            </div>
            <div class="d2">
              <div class="divider" />
            </div>
          </div>
        </div>
        <el-row type="flex" align="center" style="margin-top:10px;">
          <el-col :span="1" class="form-column">
            <h6 class="accounting-form-title">备注</h6>
          </el-col>
          <el-col :span="23">
            <el-input v-model="remark" placeholder="输入备注" type="textarea" :rows="5"></el-input>
          </el-col>
        </el-row>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import MaterialAccountingForm from "./MaterialAccountingForm";
  import CraftAccountingForm from "./CraftAccountingForm";
  import OtherAccountingForm from "./OtherAccountingForm";

  export default {
    name: "SampleAccountingSheetForm",
    props: ["slotData", "readOnly", "isRead"],
    components: {
      MaterialAccountingForm,
      CraftAccountingForm,
      OtherAccountingForm
    },
    computed: {
      totalPrice: function () {
        let price1 = 0;
      }
    },

    methods: {},
    data() {
      return {
        radio: true,
        materialData: [],
        craftData: [],
        otherData: [],
        remark: ''
      };
    },
    created() {}
  };

</script>
<style scoped>
  .accounting-form-title {
    width: 20px;
    text-align: center;
    line-height: 20px;
  }

  .form-column {
    align-items: center;
    display: flex;
    display: -webkit-flex;
    justify-content: center;
  }

  .sheet-total-title {
    flex-grow: 1;
  }

  .sheet-total {
    padding-top: 8px;
    padding-bottom: 5px;
    margin-top: 24px;
    border-top: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
  }

  .d1 {
    z-index: 1;
    position: relative;
  }

  .d2 {
    z-index: 100;
  }

  .divider {
    position: absolute;
    border-left: 1px solid #DCDFE6;
    height: 100%;
    width: 1px;
    top: 0px;
    right: 160px;
    /* margin-right: 110px; */
  }

</style>
