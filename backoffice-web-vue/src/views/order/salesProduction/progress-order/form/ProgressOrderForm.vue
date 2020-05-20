<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="progress-list-title">
            <h6>创建进度工单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true">
        <progress-order-receiving-form :formData="formData"/>
        <progress-order-production-info-form :formData="formData" :isRead="false"/>
        <progress-order-node-form v-if="isBrand()" :formData="formData"/>
        <el-divider/>
        <progress-order-production-ask-form v-if="isFactory()" :formData="formData"/>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import ProgressPlanSelectDialog from '../../../../user/progress-plan/components/ProgressPlanSelectDialog';
  import ProgressSettingForm from '../../../../user/progress-plan/components/ProgressSettingForm';
  import ProgressOrderReceivingForm from './ProgressOrderReceivingForm';
  import ProgressOrderNodeForm from './ProgressOrderNodeForm';
  import ProgressOrderProductionInfoForm from './ProgressOrderProductionInfoForm';
  import ProgressOrderProductionAskForm from './ProgressOrderProductionAskForm';
  export default {
    name: 'ProgressOrderForm',
    components: {
      ProgressOrderProductionAskForm,
      ProgressOrderProductionInfoForm,
      ProgressOrderNodeForm,
      ProgressOrderReceivingForm,
      ProgressSettingForm,
      ProgressPlanSelectDialog},
    methods: {
    },
    data () {
      return {
        basicData: [],
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        progressPlanVisible: false,
        formData: {
          product: {
            name: '全棉磨毛斜布',
            colors: [
              {
                name: '蓝色',
                code: 'S01'
              },
              {
                name: '白色',
                code: 'S02'
              }
            ],
            sizes: [
              {
                name: 'S',
                code: 'C01'
              },
              {
                name: 'XS',
                code: 'C02'
              }
            ],
            colorSizes: [
              {
                colorName: '蓝色',
                code: 'S01',
                sizes: [
                  {
                    name: 'S',
                    code: 'C01',
                    quantity: 100
                  },
                  {
                    name: 'XS',
                    code: 'C02',
                    quantity: 100
                  }
                ]
              },
              {
                colorName: '白色',
                code: 'S02',
                sizes: [
                  {
                    name: 'S',
                    code: 'C01',
                    quantity: 200
                  },
                  {
                    name: 'XS',
                    code: 'C02',
                    quantity: 200
                  }
                ]
              }
            ]
          },
          productionProcessContent: '',
          expectedDeliveryDate: '',
          creationPerson: '',
          skuID: '',
          order: {
            name: ''
          },
          priority: '',
          operator: '',
          progressPlan: {
            productionProgresses: [
              {
                phase: '备料',
                estimatedDate: 1589957969,
                delayedDays: 3
              },
              {
                phase: '裁剪',
                estimatedDate: 1590000000,
                delayedDays: 18
              }
            ]
          }
        }
      }
    }
  }
</script>

<style scoped>
  .progress-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .progress-row {
    padding-left: 10px;
    margin-top: 20px;
  }
</style>
