<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="production-order-list-title">
            <h6>生产任务明细</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>任务单号:&#12288;{{code}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>订单状态:&#12288;{{slotData.status}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row class="production-order-basic-row">
        <production-order-top-info :slotData="slotData"/>
        <production-progress-order-info :slotData="slotData"/>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import ProductionOrderTopInfo from '../info/ProductionOrderTopInfo';
  import ProductionProgressOrderInfo from '../info/ProductionProgressOrderInfo';
  export default {
    name: 'ProductionOrderDetail',
    components: {ProductionProgressOrderInfo, ProductionOrderTopInfo},
    props: ['code'],
    data () {
      return {
        slotData: {
          name: '全棉磨毛斜布',
          code: 'CO00000001',
          category: 'polo衫',
          date: '2019-2-19',
          price: 120000000.00,
          machiningType: 'LABOR_AND_MATERIAL',
          quantity: 100000,
          orderForm: '订单来源',
          status: 'IN_PRODUCTION',
          relationOrder: 'CO00000001',
          address: '广东省广州市海珠区云顶同创汇二期707',
          expectedDeliveryDate: 1584586200000,
          progresses: [{
            completeAmount: 0,
            creationtime: 1583315344000,
            delayedDays: 0,
            estimatedDate: 1585238400000,
            finishDate: 1584586200000,
            id: 8800385692987,
            medias: [],
            modifiedtime: 1584586200000,
            phase: '备料',
            productionProgressOrders: [],
            quantity: 0,
            sequence: 0
          }, {
            completeAmount: 0,
            creationtime: 1583315344000,
            delayedDays: 54,
            estimatedDate: 1585238400000,
            id: 8800385725755,
            medias: [],
            modifiedtime: 1584586192000,
            phase: '裁剪',
            productionProgressOrders: [],
            quantity: 0,
            sequence: 1
          }, {
            completeAmount: 0,
            creationtime: 1583315344000,
            delayedDays: 0,
            estimatedDate: 1585238400000,
            id: 8800385758523,
            medias: [],
            modifiedtime: 1584586192000,
            phase: '车缝',
            productionProgressOrders: [],
            quantity: 0,
            sequence: 2
          }, {
            completeAmount: 0,
            creationtime: 1583315344000,
            delayedDays: 0,
            estimatedDate: 1585238400000,
            id: 8800385791291,
            medias: [],
            modifiedtime: 1584586192000,
            phase: '后整',
            productionProgressOrders: [],
            quantity: 0,
            sequence: 3
          }, {
            completeAmount: 0,
            creationtime: 1583315344000,
            delayedDays: 0,
            estimatedDate: 1585238400000,
            id: 8800385824059,
            medias: [],
            modifiedtime: 1584586192000,
            phase: '验货',
            productionProgressOrders: [],
            quantity: 0,
            sequence: 4
          }],
          partner: {
            brand: {
              contactsPerson: '联系人',
              contactsPhone: '13786594271'
            },
            factory: {
              contactsPerson: '联系人',
              contactsPhone: '13786594271'
            },
            productionCharge: '负责人',
            approvedBy: '审批人'
          },
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
        }
      }
    }
  }
</script>

<style scoped>
  .production-order-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .production-order-basic-row {
    padding-left: 10px;
  }
</style>
