<template>
  <div>
    <div class="over-tabs" v-if="!readOnly && !readCostOnly">
      <el-row type="flex">
        <!-- <el-button class="material-btn" @click="onBOMImport">BOM导入</el-button> -->
        <el-button class="material-btn" @click="appendMateriel">添加物料</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="采购明细">
        <el-table ref="resultTable" :data="formData.workOrders" stripe :height="autoHeight">
          <el-table-column label="物料名称" prop="name" fixed="left"></el-table-column>
          <el-table-column label="物料类别" prop="materialsType">
            <template slot-scope="scope">
              <span>{{getEnum('MaterialsType', scope.row.materialsType)}}</span>
            </template>
          </el-table-column>
          <el-table-column label="物料编号" prop="code"></el-table-column>
          <el-table-column label="物料单位" prop="unit"></el-table-column>
          <el-table-column label="成分" prop="composition"></el-table-column>
          <el-table-column label="用途" prop="purpose"></el-table-column>
          <el-table-column label="供应商" v-if="!readOnly" prop="cooperatorName"></el-table-column>
          <el-table-column label="幅宽/型号" prop="modelName"></el-table-column>
          <el-table-column label="克重/规格" prop="specName"></el-table-column>
          <el-table-column label="物料颜色" prop="colorName"></el-table-column>
          <!-- 表单显示内容 -->
          <el-table-column label="单位用量" prop="unitQuantity" v-if="!readOnly"></el-table-column>
          <el-table-column label="预计损耗" prop="estimatedLoss" v-if="!readOnly">
            <template slot-scope="scope">
              <span>{{(scope.row.estimatedLoss * 100).toFixed(2)}}%</span>
            </template>
          </el-table-column>
          <el-table-column label="预计用量" prop="estimatedUsage" v-if="!readOnly"></el-table-column>
          <el-table-column label="订单数" prop="orderCount" v-if="!readOnly"></el-table-column>
          <el-table-column label="空差" prop="emptySent" v-if="!readOnly">
            <template slot-scope="scope">
              <span>{{(scope.row.emptySent * 100).toFixed(2)}}%</span>
            </template>
          </el-table-column>
          <el-table-column label="需求数量" prop="requiredAmount" min-width="100px" v-if="!readOnly">
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
          <el-table-column label="物料单价" prop="price" v-if="!readOnly"></el-table-column>
          <el-table-column label="实际金额" prop="totalPrice" v-if="!readOnly"></el-table-column>
          <!-- 详情显示内容 -->
          <el-table-column label="预计用量/订单数/需求数量" min-width="170px" v-if="readOnly">
            <template slot-scope="scope">
              <el-popover ref="popover" placement="top-start" trigger="hover" 
                          :content="scope.row.unitQuantity + '+ ( ' + scope.row.unitQuantity + ' × ' + (scope.row.estimatedLoss * 100) + '% )'">
                <span slot="reference" style="color: #409EFF">{{scope.row.estimatedUsage}}</span>
              </el-popover>
              <span> / {{scope.row.orderCount}} / </span>
              <el-popover ref="popover" placement="top-start" trigger="hover" 
                          :content="'( ' + scope.row.estimatedUsage + ' × ' + scope.row.orderCount + ' ) / ' + (scope.row.emptySent * 100) + '% '">
                <span slot="reference" style="color: #409EFF">{{scope.row.requiredAmount}}</span>
              </el-popover>
            </template>
          </el-table-column>
          <el-table-column label="物料单价/总金额" min-width="110px" v-if="readOnly">
            <template slot-scope="scope">
              <span>{{scope.row.price}} / </span>
              <el-popover ref="popover" placement="top-start" trigger="hover" 
                          :content="scope.row.requiredAmount + ' × ' + scope.row.price">
                <span slot="reference" style="color: #409EFF">{{scope.row.totalPrice}}</span>
              </el-popover>
            </template>
          </el-table-column>
          <el-table-column label="到料时间" prop="estimatedRecTime" min-width="100px" v-if="readOnly">
            <template slot-scope="scope">
              <span>{{scope.row.estimatedRecTime | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="下单数/单价/总价" min-width="120px" v-if="readOnly">
            <template slot-scope="scope">
              <span v-if="scope.row.actuallyOrderQuantity && scope.row.actuallyPrice && scope.row.actuallyTotalPrice">
                {{scope.row.actuallyOrderQuantity}} / {{scope.row.actuallyPrice}} / {{scope.row.actuallyTotalPrice}}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="收料数/缺料数" min-width="110px" v-if="readOnly">
            <template slot-scope="scope">
              <span v-if="scope.row.receiveQuantity != null  && scope.row.remainQuantity != null">
                {{scope.row.receiveQuantity}} / {{scope.row.remainQuantity}}
              </span>
            </template>
          </el-table-column>
          <el-table-column label="完成时间" min-width="90px" v-if="readOnly">
            <template slot-scope="scope">
              <span>{{scope.row.completeTime | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="状态" fixed="right" v-if="readOnly">
            <template slot-scope="scope">
              <span>{{getEnum('PurchaseWorksheetState', scope.row.state)}}</span>
            </template>
          </el-table-column>
          <template v-if="!readCostOnly">
            <el-table-column label="操作" min-width="100px" v-if="!readOnly" fixed="right">
              <template slot-scope="scope">
                <el-button type="text" @click="onModify(scope.row, scope.$index)">修改</el-button>
                <el-button type="text" @click="onDelete(scope.row, scope.$index)">删除</el-button>
              </template>
            </el-table-column>
            <el-table-column label="操作" min-width="50px" v-else fixed="right">
              <template slot-scope="scope">
                <el-button type="text" @click="onDetail(scope.row, scope.$index)">详情</el-button>
              </template>
            </el-table-column>
          </template>
        </el-table>
      </el-tab-pane>
    </el-tabs>
    <el-dialog :visible.sync="appendVisible" width="80%" append-to-body :close-on-click-modal="false">
      <material-append-table v-if="appendVisible" :formData="formData" 
                            @onSelect="onSelect" :entries="entries"/>
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
    },
    readCostOnly: {
      type: Boolean,
      detault: false
    }
  },
  components: {
    MaterialAppendTable,
  },
  methods: {
    onDetail (row) {
      this.$router.push('/purchase/worksheet/' + row.id);
    },
    objectSpanMethod({ row, column, rowIndex, columnIndex }) {
      let index = this.formData.workOrders.findIndex(item => item.code === row.code);
      let length = this.formData.workOrders.filter(item => item.code === row.code).length;
      if (index === rowIndex && columnIndex < 4) {
        return {
          rowspan: length,
          colspan: 1
        }
      } else if (index !== rowIndex && columnIndex < 4) {
        return {
          rowspan: 0,
          colspan: 0
        }
      } else if (this.readOnly && index === rowIndex && columnIndex >= 13) {
        return {
          rowspan: length,
          colspan: 1
        }
      } else if (this.readOnly && index !== rowIndex && columnIndex >= 13) {
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
      this.isModify = false;
      this.appendVisible = true;
      this.resetItem();
    },
    onBOMImport () {

    },
    onSelect (entries) {
      this.appendVisible = false;
      if (this.isModify) {
        this.formData.workOrders = entries;
        this.isModify = false;
      } else {
        this.formData.workOrders = this.arrangeData(this.formData.workOrders.concat(entries));
      }

      this.resetItem();
    },
    resetItem () {
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
            orderCount: 1,
            auditColor: '',
            estimatedRecTime: '',
            cooperatorName: '',
            price: '',
            totalPrice: '',
            composition: '',
            purpose: '',
            quoteLossRate: '',
            quoteAmount: '',
            remarks: ''
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
      this.entries.workOrders = JSON.parse(JSON.stringify(this.formData.workOrders));
      this.entries.workOrders.forEach(item => {
        item.estimatedLoss = item.estimatedLoss * 100;
        item.emptySent = item.emptySent * 100;
      })
      this.appendVisible = true;
      this.isModify = true;
    },
    onDelete (row, index) {
      this.formData.workOrders.splice(index, 1);
    }
  },
  data () {
    return {
      appendVisible: false,
      bomVisible: false,
      isModify: false,
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
            orderCount: 1,
            auditColor: '',
            estimatedRecTime: '',
            cooperatorName: '',
            price: '',
            totalPrice: '',
            composition: '',
            purpose: '',
            quoteLossRate: '',
            quoteAmount: '',
            remarks: ''
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
    right: 50px;
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