<template>
  <div class="material-append-table">
    <el-row type="flex" align="middle" style="margin-top: 20px;">
      <el-col :offset="12" :span="12">
        <el-row type="flex" justify="space-between" align="middle">
          <h6 style="margin: 0px">添加物料</h6>
          <!-- <el-button style="padding: 0px" type="text" @click="importVisible=true">批量导入</el-button> -->
        </el-row>
      </el-col>
    </el-row>
    <el-form ref="form" :model="entries">
      <el-table ref="resultTable" stripe :data="entries.workOrders" :height="autoHeight">
        <el-table-column label="物料类别" prop="materialsType" min-width="100px">
          <template slot="header">
            <span>物料类别<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.materialsType'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-select v-model="scope.row.materialsType" style="width: 90px">
                <template v-for="item in materialsType">
                  <el-option :label="item.name" :value="item.code" :key="item.code"></el-option>
                </template>
              </el-select>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column min-width="150px" label="物料名称">
          <template slot="header">
            <span>物料名称<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.name'" :rules="[{required: true, message: '必填', tigger: 'change'}]">
                <el-autocomplete class="inline-input"
                  style="width: 140px"
                  v-model="scope.row.name"
                  :fetch-suggestions="((queryString,cb)=>{querySearch(queryString, cb, scope.row)})"
                  :popper-class="scope.row.materialsType === '' ? 'hide-popper' : ''"
                  placeholder="请输入内容">
              </el-autocomplete>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料编号" prop="code" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.code" class="table-input"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="成分" prop="composition" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.composition" class="table-input"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="用途" prop="purpose" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.purpose" class="table-input"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="幅宽/型号" prop="modelName" min-width="100px">
          <template slot-scope="scope">
              <el-input v-model="scope.row.modelName" class="table-input"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="克重/规格" prop="specName" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.specName" class="table-input"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="物料单位" prop="unit" min-width="100px">
          <template slot="header">
            <span>物料单位<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.unit'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-select v-model="scope.row.unit" style="width: 90px">
                <el-option v-for="unit in unitsOpt" :key="unit" :label="unit" :value="unit"></el-option>
              </el-select>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料颜色" prop="colorName" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.colorName" class="table-input"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="单件用量" prop="unitQuantity" min-width="100px">
          <template slot="header">
            <span>单件用量<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.unitQuantity'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-model="scope.row.unitQuantity" style="width: 90px" 
                        @change="inputChange(scope.row, 'unitQuantity')"
                        v-number-input.float="{ min: 0, decimal: 4 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="预计损耗" prop="estimatedLoss" min-width="100px">
          <template slot="header">
            <span>预计损耗<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.estimatedLoss'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-model="scope.row.estimatedLoss" style="width: 90px"
                        @change="inputChange(scope.row, 'estimatedLoss')"
                        v-number-input.float="{ min: 0, max: 100, decimal: 0 }">
                <span slot="suffix">%</span>
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="预计用量" prop="estimatedUsage" min-width="100px">
          <template slot-scope="scope">
            <h6 class="table-input table-text">{{getExpectQuantity(scope.row)}}</h6>
          </template>
        </el-table-column>
        <el-table-column label="订单数" prop="orderCount" min-width="100px">
          <template slot="header">
            <span>订单数<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.orderCount'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-if="singleton" v-model="scope.row.orderCount" style="width: 90px" :disabled="true"></el-input>
              <el-input v-else v-model="scope.row.orderCount" style="width: 90px"
                        @change="inputChange(scope.row, 'orderCount')"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="空差" prop="emptySent" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.emptySent" class="table-input" placeholder="100"
                      @change="inputChange(scope.row, 'emptySent')"
                      v-number-input.float="{ min: 0, max: 100, decimal: 0 }">
              <span slot="suffix" style="top: 4px">%</span>
            </el-input>
          </template>
        </el-table-column>
        <el-table-column label="需求数量" prop="requiredAmount" min-width="100px">
          <template slot-scope="scope">
            <h6 class="table-input table-text">{{getNeedQuantity(scope.row)}}</h6>
          </template>
        </el-table-column>
        <el-table-column label="供应商" prop="cooperatorName" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.cooperatorName" class="table-input"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="物料单价" prop="price" min-width="100px">
          <template slot="header">
            <span>物料单价<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'workOrders.' + scope.$index + '.price'" :rules="[{required: true, validator: validateValue, tigger: 'change'}]">
              <el-input v-model="scope.row.price" style="width: 90px"
                        @change="inputChange(scope.row, 'price')"
                        v-number-input.float="{ min: 0, decimal: 4 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="实际金额" prop="totalPrice" min-width="100px">
          <template slot-scope="scope">
            <h6 class="table-input table-text">{{getTotalPrice(scope.row)}}</h6>
          </template>
        </el-table-column>
        <el-table-column label="报价损耗" prop="quoteLossRate" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.quoteLossRate" class="table-input" placeholder="0"
                      v-number-input.float="{ min: 0, max: 100, decimal: 0 }">
              <span slot="suffix" style="top: 4px">%</span>
            </el-input>
          </template>
        </el-table-column>
        <el-table-column label="报价金额" prop="quoteAmount" min-width="100px">
          <template slot-scope="scope">
            <el-input v-model="scope.row.quoteAmount" class="table-input"
                      v-number-input.float="{ min: 0, decimal: 4 }"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="到料时间" prop="estimatedRecTime" min-width="150px">
          <template slot-scope="scope">
            <el-date-picker
              v-model="scope.row.estimatedRecTime"
              type="date"
              value-format="timestamp"
              class="table-input"
              style="width: 130px"
              placeholder="选择日期">
            </el-date-picker>
          </template>
        </el-table-column>
        <el-table-column label="备注" prop="remarks" min-width="150px">
          <template slot-scope="scope">
            <el-input class="table-input" v-model="scope.row.remarks"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="100px" fixed="right">
          <template slot-scope="scope">
            <el-form-item>
              <el-button type="text" @click="onAdd(scope.$index, scope.row)">
                <i class="el-icon-plus"></i>
              </el-button>
              <el-button type="text" @click="onCopy(scope.$index, scope.row)">
                <i class="el-icon-copy-document"></i>
              </el-button>
              <el-button type="text" @click="onDelete(scope.$index, scope.row)">
                <i class="el-icon-delete"></i>
              </el-button>
            </el-form-item>
          </template>
        </el-table-column>
      </el-table>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 30px">
      <el-button class="sumbit-btn" @click="onSumbit">确认</el-button>
    </el-row>
    <el-dialog :visible.sync="importVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <materials-import v-if="importVisible" @onImport="onImport" :singleton="singleton"/>
    </el-dialog>
  </div>  
</template>

<script>
import MaterialsImport from './MaterialsImport'

export default {
  name: 'MaterialAppendTable',
  props: ['formData', 'entries', 'singleton'],
  components: {
    MaterialsImport
  },
  methods: {
    onImport (data) {
      this.entries.workOrders = data;
      this.importVisible = false;
    },
    inputChange (row, attribute) {
      const regexp = /^.*\.$/;
      if (regexp.test(row[attribute])) {
        row[attribute] = Number.parseInt(row[attribute]);
      }
    },
    getExpectQuantity (row) {
      let count = 0;
      let unitQuantity = Number.parseFloat(row.unitQuantity);
      let estimatedLoss = Number.parseFloat(row.estimatedLoss);
      if (!Number.isNaN(unitQuantity) && !Number.isNaN(estimatedLoss)) {
        count = unitQuantity * (1 + estimatedLoss / 100);
      }
      row.estimatedUsage = count.toFixed(4);
      return count.toFixed(4);
    },
    getNeedQuantity (row) {
      let count = 0;
      const estimatedUsage = this.getExpectQuantity(row);

      let orderCount = Number.isNaN(Number.parseFloat(row.orderCount)) ? 
                                    0 : Number.parseFloat(row.orderCount);
      let emptySent = Number.isNaN(Number.parseFloat(row.emptySent)) ? 
                                    100 : Number.parseFloat(row.emptySent);

      count = estimatedUsage * orderCount / (emptySent / 100);
      row.requiredAmount = count.toFixed(4);
      return count.toFixed(4);
    },
    getTotalPrice (row) {
      let count = 0;
      let price = Number.parseFloat(row.price);
      if (!Number.isNaN(price)) {
        const needQuantity = this.getNeedQuantity(row);
        count = price * needQuantity;
      }
      row.totalPrice = count.toFixed(4);
      return count.toFixed(4);
    },
    onAdd (index, row) {
      this.entries.workOrders.splice(index + 1, 0 , {
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
        totalPrice: ''
      })
    },
    onCopy (index, row) {
      const copyData = Object.assign({}, row);
      copyData.id = '';
      copyData.materialsId = '';
      copyData.specListId = '';
      this.entries.workOrders.splice(index + 1, 0, copyData);
    },
    onDelete (index, row) {
      this.entries.workOrders.splice(index, 1);
      if (this.entries.workOrders.length <= 0 && index === 0) {
        this.onAdd(-1);
      }
    },
    onSumbit () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this._onImport();
        } else {
          this.$message.error('请完善表单信息');
        }
      })
    },
    _onImport () {
      this.$emit('onSelect', this.arrangeData(this.entries.workOrders));
    },
    arrangeData (materials) {
      let result = [];

      result = result.concat(materials);

      result.forEach(item => {
        this.$set(item, 'estimatedLoss', (Number.parseFloat(item.estimatedLoss) / 100).toFixed(4));
        
        if (Number.isNaN(Number.parseFloat(item.emptySent))) {
          this.$set(item, 'emptySent', 1.00);
        } else {
          this.$set(item, 'emptySent', (Number.parseFloat(item.emptySent) / 100).toFixed(2));
        }
        
        if (Number.isNaN(Number.parseFloat(item.quoteLossRate))) {
          this.$set(item, 'quoteLossRate', 0.00);
        } else {
          this.$set(item, 'quoteLossRate', (Number.parseFloat(item.quoteLossRate) / 100).toFixed(2));
        }
      })
      return result;
    },
    validateValue (rule, value, callback) {
      if (value && value !== '') {
        callback();
      } else {
        callback(new Error('必填'));
      }
    },
    querySearch(queryString, cb, row) {
      if (row.materialsType !== '') {
        cb(this.specialProcess[row.materialsType]);
      } else {
        cb([]);
      }
    }
  },
  data () {
    return {
      materialsType: this.$store.state.EnumsModule.MaterialsType,
      importVisible: false,
      unitsOpt: ['米', '个', '粒', '包', '张', '千克'],
      specialProcess: {
        'PLUS_MATERIAL': [
          { value: '面布' },
          { value: '里布' },
          { value: '衬布' },
          { value: '棉' },
          { value: '羽绒' },
          { value: '别布' },
          { value: '配布' },
          { value: '针织' }
        ],
        'SUBSIDIARY_MATERIAL': [
          { value: '拉链' },
          { value: '线' },
          { value: '钮扣' },
          { value: '松紧带' },
          { value: '棉包' },
          { value: '牵条' },
          { value: '织带' },
          { value: '吊带' },
          { value: '硬衬' },
          { value: '暗扣' },
          { value: '裙钩' },
          { value: '旗袍钩' },
          { value: '特殊标' },
          { value: '成分标' },
          { value: '产地标' },
          { value: '尺寸标' },
          { value: '尺寸产地标' },
          { value: '尺寸成分产地标' },
          { value: '衬条' },
          { value: '棉条' },
          { value: '扣环' },
          { value: '双面衬' },
          { value: '肩扣带' },
          { value: '挂耳' },
          { value: '棉绳' },
          { value: '滚条' },
          { value: '鸡眼' },
          { value: '魔术贴' },
          { value: '珠子' },
          { value: '珠管' },
          { value: '纸朴' },
          { value: '布朴' },
          { value: '螺纹' },
          { value: '针织' },
          { value: '透明扣' },
          { value: '帽绳' },
          { value: '橡筋' },
          { value: '花边' },
          { value: '备用袋' },
          { value: '雪纺朴' },
          { value: '主唛' },
          { value: '洗水唛' },
          { value: '拷贝纸' },
          { value: '包装袋' },
          { value: '四合扣' },
          { value: '四合扣磨具' },
          { value: '版费' },
          { value: '猪鼻扣' }
        ],
        'PACKING': [
          { value: '衣架棉' },
          { value: '方块棉' },
          { value: '套环' },
          { value: '止点珠' },
          { value: '备扣袋' },
          { value: '贴纸' },
          { value: '色系标' },
          { value: '衣架贴标' },
          { value: '胶袋贴标' },
          { value: '胶袋' },
          { value: '橡筋' },
          { value: '主唛' },
          { value: '洗水唛' },
          { value: '拷贝纸' },
          { value: '包装袋' },
          { value: '四合扣' },
          { value: '版费' },
          { value: '猪鼻扣' }
        ]
      }
    }
  }
}
</script>

<style scoped>
  .material-append-table >>> .el-input__suffix {
    display: flex;
    align-items: center;
  }

  .material-append-table >>> .el-table--small td, .el-table--small th {
    padding: 8px 0px 0px 0px;
  }

  button {
    outline:none;
  }
   
  .material-append-table >>> .el-table .warning-row {
    background: oldlace;
  }

  .sumbit-btn {
    width: 100px;
    color: #606266;
    background-color: #ffd60c;
  }

  .table-input {
    margin-bottom: 18px;
  }

  .table-text {
    font-weight: unset;
    font-size: 12px;
  }
</style>
