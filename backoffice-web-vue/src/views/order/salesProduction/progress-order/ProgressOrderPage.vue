<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="progress-list-title">
            <!--外发订单列表-->
            <h6>订单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <progress-order-toolbar @onAdvancedSearch="onAdvancedSearch"/>
      <progress-order-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import ProgressOrderToolbar from './toolbar/ProgressOrderToolbar';
  import ProgressOrderList from './list/ProgressOrderList';
  export default {
    name: 'ProgressOrderPage',
    props: [],
    components: {ProgressOrderList, ProgressOrderToolbar},
    methods: {
      onAdvancedSearch () {}
    },
    data () {
      return {
        page: {
          number: 0,
          size: 10,
          totalPages: 1,
          totalElements: 100,
          content: [
            {
              code: 'CO0000000001',
              charge: '卫衣烬',
              priority: '普通',
              creationTime: 1589079526,
              product: {
                name: '全棉磨毛棉衣',
                skuID: '95523',
                quantity: '10000',
                deliveryDate: 1589079526,
                relationOrder: 'CO00000003'
              },
              progressPlan: {
                phase: 'STITCHING',
                phaseSqeuence: 2,
                progress: [{
                  code: 'MATERIAL_PREPARATION',
                  delatedDays: 2,
                  sequence: 0,
                  expectedTime: 1589165926,
                  compleTime: 1589252326
                }, {
                  code: 'CUTTING',
                  delatedDays: 3,
                  sequence: 1,
                  expectedTime: 1589165926
                },
                {
                  code: 'STITCHING',
                  sequence: 2,
                  expectedTime: 1589165926
                },
                {
                  code: 'AFTER_FINISHING',
                  sequence: 3,
                  expectedTime: 1589165926
                },
                {
                  code: 'INSPECTION',
                  sequence: 4,
                  expectedTime: 1589165926
                }]
              }
            },
            {
              code: 'CO0000000001',
              charge: '卫衣烬',
              priority: '普通',
              creationTime: 1589079526,
              product: {
                name: '全棉磨毛棉衣',
                skuID: '95523',
                quantity: '10000',
                deliveryDate: 1589079526,
                relationOrder: 'CO00000003'
              },
              progressPlan: {
                phase: 'AFTER_FINISHING',
                phaseSqeuence: 3,
                progress: [{
                  code: 'MATERIAL_PREPARATION',
                  delatedDays: 2,
                  sequence: 0,
                  expectedTime: 1589165926,
                  compleTime: 1589252326
                }, {
                  code: 'CUTTING',
                  delatedDays: 3,
                  sequence: 1,
                  expectedTime: 1589165926
                },
                {
                  code: 'STITCHING',
                  sequence: 2,
                  expectedTime: 1589165926
                },
                {
                  code: 'AFTER_FINISHING',
                  sequence: 3,
                  expectedTime: 1589165926
                },
                {
                  code: 'INSPECTION',
                  sequence: 4,
                  expectedTime: 1589165926
                }]
              }
            },
            {
              code: 'CO0000000001',
              charge: '卫衣烬',
              priority: '普通',
              creationTime: 1589079526,
              product: {
                name: '全棉磨毛棉衣',
                skuID: '95523',
                quantity: '10000',
                deliveryDate: 1589079526,
                relationOrder: 'CO00000003'
              },
              progressPlan: {
                phase: 'INSPECTION',
                phaseSqeuence: 4,
                progress: [{
                  code: 'MATERIAL_PREPARATION',
                  delatedDays: 2,
                  sequence: 0,
                  expectedTime: 1589165926,
                  compleTime: 1589252326
                }, {
                  code: 'CUTTING',
                  delatedDays: 3,
                  sequence: 1,
                  expectedTime: 1589165926
                },
                {
                  code: 'STITCHING',
                  sequence: 2,
                  expectedTime: 1589165926
                },
                {
                  code: 'AFTER_FINISHING',
                  sequence: 3,
                  expectedTime: 1589165926
                },
                {
                  code: 'INSPECTION',
                  sequence: 4,
                  expectedTime: 1589165926
                }]
              }
            }
          ]
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
</style>
