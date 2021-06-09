<!--
* @Description: 外接外发对账信息tab
* @Date 2021/06/09 16:36
* @Author L.G.Y
-->
<template>
  <div class="sales-reconciliation">
    <el-row type="flex" justify="start" class="reconcilication-order-title">
      <h6 style="margin: 0px">电子对账单</h6>
    </el-row>
    <template v-for="(sheet, index) in form.reconciliationSheetList">
      <el-row type="flex" :key="sheet.id" style="margin-top: 20px">
        <div>
          <div><h6>标题：{{sheet.title}}</h6></div>
          <div><h6>单号：{{sheet.code}}</h6></div>
          <div><h6>创建时间：{{sheet.creationtime | formatDate}}</h6></div>
        </div>
        <template v-for="item in sheet.docSignatures">
          <div class="reconciliation-item" :key="item.code" v-if="item.state !== 'CANCELED'">
            <el-button type="text" @click="showPDF(sheet, item)">
              <img style="width: 50px" src="static/img/word.png"/>
            </el-button>
          </div>
        </template>
      </el-row>
      <el-divider v-if="index > 0" :key="sheet.id"></el-divider>
    </template>
    <!-- 展示pdf组件 -->
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" append-to-body :close-on-click-modal="false">
      <doc-signatures v-if="pdfVisible" :fileUrl="fileUrl" :pdfItem="pdfItem" :order="order"/>
    </el-dialog>
  </div>
</template>

<script>
import DocSignatures from '@/views/order/delivery-recon/components/DocSignatures'

export default {
  name: 'SalesReconciliation',
  components: { DocSignatures },
  props: ['form'],
  methods: {
    async showPDF (sheet, item) {
      this.order = sheet;
      this.pdfItem = item;
      this.fileUrl = item.docPdf.url;
      this.pdfVisible = true;
    }
  },
  data () {
    return {
      pdfVisible: false,
      fileUrl: '',
      pdfItem: '',
      order: ''
    }
  }
}
</script>

<style scoped>
  .reconcilication-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .reconciliation-container {
    display: flex;
    flex-wrap: wrap;
  }

  .reconciliation-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    border-radius: 5px;
    margin-left: 5px;
  }

  .reconciliation-item:hover {
    background-color: #ffd60c;
  }
</style>