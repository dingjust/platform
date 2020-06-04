<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-list-title">
            <h6>创建采购订单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <purchase-task-detail-top :formData="formData" :readOnly="true"/>
      <el-divider></el-divider>
      <purchase-task-detail-table :formData="formData"/>
    </el-card>
  </div>
</template>

<script>
  import PurchaseTaskDetailTop from './PurchaseTaskDetailTop';
  import PurchaseTaskDetailTable from './PurchaseTaskDetailTable';
  export default {
    name: 'PurchaseTaskDetail',
    components: {PurchaseTaskDetailTable, PurchaseTaskDetailTop},
    data () {
      return {
        formData: {
          code: 'CG410029010-001',
          orderCode: 'CG410029010-0',
          skuID: 'CG410029010-1',
          status: '未审核',
          purchaseName: '采购名称',
          completedDateFrom: 1591076420000,
          completedDateTo: 1591076420000,
          creator: {
            name: '创建人'
          },
          approver: {
            name: '审批人'
          },
          purchaser: {
            name: '采购人'
          },
          taxIncluded: true,
          qualityLevel: '合格品',
          shippingAddress: {
            id: 8805989056535,
            creationtime: 1591076420000,
            modifiedtime: 1591076420000,
            fullname: 'yi',
            cellphone: '13118836156',
            region: {
              isocode: 'CN-44',
              isocodeShort: '44',
              countryIso: 'CN',
              name: '广东省',
              cities: null,
              index: null
            },
            city: {
              code: 'CN-44-5',
              name: '广州市',
              districts: null,
              index: null,
              region: null
            },
            cityDistrict: {
              code: 'CN-44-5-4',
              name: '天河区',
              index: null,
              city: null
            },
            line1: '云顶同城',
            details: '广东省广州市天河区云顶同城'
          },
          purchaseDetails: [{
            name: '纯棉磨毛斜布',
            code: 'CTO123456789',
            spec: '100×100cm',
            unit: '厘米',
            property: '面料',
            unitQuantity: 1000,
            color: '黑色',
            sampleColor: '金色',
            orderQuantity: 10000000,
            materialQuantity: 100000000,
            floatQuantity: 1000000,
            quantity: 1000000000,
            countQuantity: 100000000,
            taxPrice: 123222.011,
            totalPrice: 129301209312.22,
            expected: 122222222222
          }]
        }
      }
    }
  }
</script>

<style scoped>
  .sales-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  /deep/ .el-divider--horizontal {
    margin: 0px 0;
  }
</style>
