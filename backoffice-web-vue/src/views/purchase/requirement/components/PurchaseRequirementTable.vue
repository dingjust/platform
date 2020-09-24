<template>
  <div>
    <div class="over-tabs" v-if="!readOnly">
      <el-row type="flex">
        <el-button class="material-btn" @click="onBOMImport">BOM导入</el-button>
        <el-button class="material-btn" @click="appendMateriel">添加物料</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="采购明细">
        <el-table ref="resultTable" :data="formData.workOrders" stripe :height="autoHeight" :span-method="objectSpanMethod">
          <el-table-column label="物料名称" prop="name"></el-table-column>
          <el-table-column label="物料类别" prop="materialsType">
            <template slot-scope="scope">
              <span>{{getEnum('MaterialsType', scope.row.materialsType)}}</span>
            </template>
          </el-table-column>
          <el-table-column label="物料编号" prop="code"></el-table-column>
          <el-table-column label="物料单位" prop="unit"></el-table-column>
          <el-table-column label="供应商" prop="cooperatorName"></el-table-column>
          <el-table-column label="幅宽/型号" prop="modelName"></el-table-column>
          <el-table-column label="克重/规格" prop="specName"></el-table-column>
          <el-table-column label="物料颜色" prop="colorName"></el-table-column>
          <el-table-column label="单位用量" prop="unitQuantity"></el-table-column>
          <el-table-column label="预计损耗" prop="estimatedLoss">
            <template slot-scope="scope">
              <span>{{scope.row.estimatedLoss}}%</span>
            </template>
          </el-table-column>
          <el-table-column label="预计用量" prop="estimatedUsage"></el-table-column>
          <el-table-column label="订单数" prop="orderCount"></el-table-column>
          <el-table-column label="空差" prop="emptySent">
            <template slot-scope="scope">
              <span>{{scope.row.emptySent * 100}}%</span>
            </template>
          </el-table-column>
          <el-table-column label="需求数量" prop="requiredAmount" min-width="100px">
            <template slot="header">
              <span v-popover:popover>需求数量</span>
              <el-popover ref="popover" placement="top-start" width="270" trigger="hover"
                :content="title">
              </el-popover>
            </template>
            <template slot-scope="scope">
              <span v-popover:popover>{{scope.row.requiredAmount}}</span>
              <el-popover ref="popover" placement="top-start" width="270" trigger="hover"
                :content="title">
              </el-popover>
            </template>
          </el-table-column>
          <el-table-column label="物料单价" prop="price"></el-table-column>
          <el-table-column label="总金额" prop="totalPrice"></el-table-column>
          <el-table-column label="到料时间" prop="estimatedRecTime" min-width="100px">
            <template slot-scope="scope">
              <span>{{scope.row.estimatedRecTime | timestampToTime}}</span>
            </template>
          </el-table-column>
          <!-- <el-table-column label="是否批色" prop="auditColor">
            <template slot-scope="scope">
              <span>{{scope.row.auditColor ? '是' : '否'}}</span>
            </template>
          </el-table-column> -->
          <el-table-column label="操作" min-width="100px" v-if="!readOnly">
            <template slot-scope="scope">
              <el-button type="text" @click="onModify(scope.row, scope.$index)">修改</el-button>
              <el-button type="text" @click="onDelete(scope.row, scope.$index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
    <el-dialog :visible.sync="appendVisible" width="80%" append-to-body :close-on-click-modal="false">
      <material-append-table v-if="appendVisible" :formData="formData" @onSelect="onSelect" :entries="entries" />
    </el-dialog>
  </div>
</template>

<script>
import MaterialAppendTable from './MaterialAppendTable'

export default {
  name: 'PurchaseRequirementTable',
  props: {
    formData: {
      required: true
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  components: {
    MaterialAppendTable,
  },
  methods: {
    objectSpanMethod({ row, column, rowIndex, columnIndex }) {
      let index = this.formData.workOrders.findIndex(item => item.code === row.code);
      let length = this.formData.workOrders.filter(item => item.code === row.code).length;
      if (index === rowIndex && columnIndex < 5) {
        return {
          rowspan: length,
          colspan: 1
        }
      } else if (index !== rowIndex && columnIndex < 5) {
        return {
          rowspan: 0,
          colspan: 0
        }
      } else {
        return {
          rowspan: 1,
          colspan: 1
        }
      }
    },
    appendMateriel () {
      this.appendVisible = true;
    },
    onBOMImport () {

    },
    onSelect (entries) {
      this.appendVisible = false;
      this.formData.workOrders = this.arrangeData(this.formData.workOrders.concat(entries));
      this.entries = {
        workOrders: [
          {
            name: '',
            code: '',
            unit: '',
            materialsType: '',
            unitQuantity: '',
            specName: '',
            colorName: '',
            modelName: '',
            emptySent: '',
            requiredAmount: '',
            estimatedLoss: '',
            estimatedUsage: '',
            orderCount: '',
            auditColor: '',
            estimatedRecTime: '',
            cooperatorName: '',
            price: '',
            totalPrice: ''
          }
        ]
      }
    },
    arrangeData (materials) {
      let result = [];
      let stark = [];

      stark = stark.concat(materials);

      while (stark.length) {
        let temp = stark.shift();
        result.push(temp);
        result = result.concat(stark.filter(item => item.code === temp.code));
        stark = stark.filter(item => item.code !== temp.code);
      }
      return result;
    },
    onModify (row, index) {

    },
    onDelete (row, index) {
      this.formData.workOrders.splice(index, 1);
    }
  },
  data () {
    return {
      appendVisible: false,
      bomVisible: false,
      title: '需求数量 = 预计用量 * 订单数 / 空差',
      entries: {
        workOrders: [
          {
            name: '',
            code: '',
            unit: '',
            materialsType: '',
            unitQuantity: '',
            specName: '',
            colorName: '',
            modelName: '',
            emptySent: '',
            requiredAmount: '',
            estimatedLoss: '',
            estimatedUsage: '',
            orderCount: '',
            auditColor: '',
            estimatedRecTime: '',
            cooperatorName: '',
            price: '',
            totalPrice: ''
          }
        ]
      }
    }
  }  
}
</script>

<style scoped>
  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  /deep/ .el-dialog__header {
    padding: 0px;
  }
</style>