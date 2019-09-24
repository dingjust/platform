<template>
    <div class="cooperator-info-order-body">
          <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
            <el-col :span="3">方案名称</el-col>
            <el-col :span="21">{{itemData.name}}</el-col>
          </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="3">创建日期</el-col>
              <el-col :span="21">{{itemData.creationtime | formatDateWithSecond}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="3">备注</el-col>
              <el-col :span="21">{{itemData.remarks}}</el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="3">类型</el-col>
              <el-col :span="21">
                <span v-if="itemData.isHaveDeposit">
                  定金+
                </span>
                <span v-else>
                  无定金+
                </span>
                {{getEnum('PayPlanType',itemData.payPlanType)}}
              </el-col>
            </el-row>
            <el-row type="flex" justify="space-between" class="cooperator-info-order-row">
              <el-col :span="3">账务详情</el-col>
              <el-col :span="21">
                <el-row type="flex" v-for="item of itemData.payPlanItems" style="margin-bottom: 20px">
                  <el-col :span="6">
                      <span style="color: #C0C0C0">
                        {{getEnum('PayMoneyType',item.moneyType)}}
                      </span>
                  </el-col>
                  <el-col :span="18">
                      {{getEnum('TriggerEvent',item.triggerEvent)}}后{{item.triggerDays}}天
                    {{getEnum('TriggerType',item.triggerType)}}支付总额的{{item.payPercent * 100}}%作为定金
                  </el-col>
                </el-row>
              </el-col>
            </el-row>
    </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanInfoPage',
    props: ['itemData'],
    components: {},
    computed: {
      ...mapGetters({
      })
    },
    methods: {
      ...mapActions({
      }),
    },
    data() {
      return {
      };
    },
    created() {

    }
  };
</script>

<style scoped>
  .cooperator-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .cooperator-info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }

  .cooperator-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .cooperator-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .cooperator-info-title-row {
    margin-bottom: 20px;
  }

  .cooperator-info-order-row {
    margin-bottom: 20px;
  }

  .cooperator-info-order-body {
    width: 100%;
    /*padding: 10px 60px;*/
    line-height: normal;
  }



  label {
    margin-bottom: 0px !important;
  }

  .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .cooperator-form-item small.el-form-item {
    margin-bottom: 0px !important;
  }

  .cooperator-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .cooperator-info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 30px;
  }

  .el-divider--vertical{
    height: 13em;
  }
</style>
