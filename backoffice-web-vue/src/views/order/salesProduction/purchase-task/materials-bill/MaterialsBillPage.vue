<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-list-title">
            <h6>物料单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :model="formData">
        <materials-bill-top :formData="formData"/>
        <el-divider/>
        <materials-bill-middle :formData="formData" @selectSupplier="selectSupplier" @onSumbit="onSumbit"/>
        <materials-bill-table :formData="formData"/>
      </el-form>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
        <el-button size="mini" class="material-btn">确认提交</el-button>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <suppliers-select v-if="suppliersSelectVisible" @onSelect="onSuppliersSelect" />
    </el-dialog>
  </div>
</template>

<script>
  import MaterialsBillTop from './MaterialsBillTop';
  import MaterialsBillMiddle from './MaterialsBillMiddle';
  import MaterialsBillTable from './MaterialsBillTable';
  import SuppliersSelect from '../../../../contract/manage/components/SupplierSelect';
  export default {
    name: 'MaterialsBillPage',
    components: {SuppliersSelect, MaterialsBillTable, MaterialsBillMiddle, MaterialsBillTop},
    props: [],
    computed: {},
    methods: {
      selectSupplier () {
        this.suppliersSelectVisible = true;
      },
      onSuppliersSelect (data) {
        console.log(data);
        this.suppliersSelectVisible = false;
      },
      onSumbit () {

      }
    },
    data () {
      return {
        suppliersSelectVisible: false,
        formData: {
          orderCode: 'CO100000001',
          skuID: '9527',
          purchaseOrderCode: 'PO010101001',
          completionTime: 1591076420000,
          materialsCode: '93629174652',
          materialsName: '全棉磨毛斜布',
          spec: {
            name: '40×40cm'
          },
          materialsUnit: 'INDIVIDUAL',
          materialsType: 'PLUS_MATERIAL',
          taxIncluded: true,
          unitQuantity: 120,
          lossRate: 120,
          realityQuantity: 10000,
          materialsForm: '',
          cooperator: {
            partner: {
              uid: 'PP00000001',
              name: '时尚衣品'
            }
          },
          payPlan: {
            payPlanType: 'PHASEONE',
            isHaveDeposit: false,
            payPlanItems: []
          },
          materialsQuanlity: '合格品',
          reportList: [],
          materialsOrder: []
        }
      }
    },
    created () {
    },
    mounted () {
    }
  }
</script>

<style scoped>
  .sales-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100px;
  }
</style>
