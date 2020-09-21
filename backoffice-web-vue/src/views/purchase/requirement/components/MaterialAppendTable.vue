<template>
  <div class="material-append-table">
    <el-row type="flex">
      <el-col :span="12">
        <el-row type="flex" justify="end">
          <h6>添加物料</h6>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex" justify="end">
          <el-button type="text" @click="onImport">批量导入</el-button>
        </el-row>
      </el-col>
    </el-row>
    <el-form ref="form" :model="form" :hide-required-asterisk="true">
      <el-table ref="resultTable" stripe :data="form.entries" :height="autoHeight">
        <el-table-column min-width="100px">
          <template slot="header">
            <span>物料名称<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.name'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.name" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column prop="type" min-width="100px">
          <template slot="header">
            <span>物料类别<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.type'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-select v-model="scope.row.type" style="width: 90px">
                <template v-for="item in materialsType">
                  <el-option :label="item.name" :value="item.code" :key="item.code"></el-option>
                </template>
              </el-select>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料编号" prop="code" min-width="100px">
          <template slot="header">
            <span>物料编号<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.code'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.code" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="幅宽/型号" prop="mode" min-width="100px">
          <template slot="header">
            <span>幅宽/型号<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.mode'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.mode" style="width: 90px"></el-input>
            </el-form-item>
          </template></el-table-column>
        <el-table-column label="克重/规格" prop="spec" min-width="100px">
          <template slot-scope="scope">
            <el-form-item>
              <el-input v-model="scope.row.spec" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料单位" prop="unit" min-width="100px">
          <template slot="header">
            <span>物料单位<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.unit'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.unit" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料颜色" prop="color" min-width="100px">
          <template slot="header">
            <span>物料颜色<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.color'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.color" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="单件用量" prop="unitQuantity" min-width="100px">
          <template slot="header">
            <span>单件用量<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.unitQuantity'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.unitQuantity" style="width: 90px" 
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="预计损耗" prop="expectLoss" min-width="100px">
          <template slot="header">
            <span>预计损耗<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.expectLoss'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.expectLoss" style="width: 90px"
                        v-number-input.float="{ min: 0, max: 100, decimal: 2 }">
                <span slot="suffix">%</span>
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="预计用量" prop="expectQuantity" min-width="100px">
          <template slot="header">
            <span>预计用量<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item>
              <span>{{getExpectQuantity(scope.$index)}}</span>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="订单数" prop="orderQuantity" min-width="100px">
          <template slot="header">
            <span>订单数<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.orderQuantity'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.orderQuantity" style="width: 90px"
                        v-number-input.float="{ min: 0, decimal: 0 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="空差" prop="spaceDiff" min-width="100px">
          <template slot-scope="scope">
            <el-form-item>
              <el-input v-model="scope.row.spaceDiff" style="width: 90px" placeholder="100"
                        v-number-input.float="{ min: 0, max: 100, decimal: 2 }">
                <span slot="suffix">%</span>
              </el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="需求数量" prop="needQuantity" min-width="100px">
          <template slot="header">
            <span>需求数量<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item>
              <span>{{getNeedQuantity(scope.$index)}}</span>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="供应商" prop="operator" min-width="100px">
          <template slot-scope="scope">
            <el-form-item>
              <el-input v-model="scope.row.operator" style="width: 90px"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="物料价格" prop="price" min-width="100px">
          <template slot="header">
            <span>物料价格<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.price'" :rules="[{required: true, message: '必填', tigger: 'blur'}]">
              <el-input v-model="scope.row.price" style="width: 90px"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="总金额" prop="totalPrice" min-width="100px">
          <template slot-scope="scope">
            <el-form-item>
              <el-input v-model="scope.row.totalPrice" style="width: 90px"
                        v-number-input.float="{ min: 0, decimal: 2 }"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="到料时间" prop="time" min-width="150px">
          <template slot="header">
            <span>到料时间<span style="color: #F56C6C"> *</span></span>
          </template>
          <template slot-scope="scope">
            <el-form-item :prop="'entries.' + scope.$index + '.time'" :rules="[{required: true, type: 'number',message: '必填', tigger: 'blur'}]">
              <el-date-picker
                v-model="scope.row.time"
                type="date"
                value-format="timestamp"
                style="width: 130px"
                placeholder="选择日期">
              </el-date-picker>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="是否批色" prop="batchColor" min-width="110px">
          <template slot-scope="scope">
            <el-form-item>
              <el-select v-model="scope.row.batchColor" style="width:90px" placeholder="否">
                <el-option label="是" :value="true"></el-option>
                <el-option label="否" :value="false"></el-option>
              </el-select>
            </el-form-item>
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
  </div>  
</template>

<script>
export default {
  name: 'MaterialAppendTable',
  props: ['formData'],
  methods: {
    getExpectQuantity (index) {
      let count = 0;
      if (!Number.isNaN(Number.parseFloat(this.form.entries[index].unitQuantity)) && !Number.isNaN(Number.parseFloat(this.form.entries[index].expectLoss))) {
        count = Number.parseFloat(this.form.entries[index].unitQuantity) * (1 + Number.parseFloat(this.form.entries[index].expectLoss) / 100);
      }
      this.form.entries[index].expectQuantity = count.toFixed(2);
      return count.toFixed(2);
    },
    getNeedQuantity (index) {
      let count = 0;
      const expectQuantity = this.getExpectQuantity(index);
      if (!Number.isNaN(Number.parseFloat(this.form.entries[index].orderQuantity))) {
        const orderQuantity = Number.parseFloat(this.form.entries[index].orderQuantity);
        let spaceDiff = 100;
        if (!Number.isNaN(Number.parseFloat(this.form.entries[index].spaceDiff))) {
          spaceDiff = Number.parseFloat(this.form.entries[index].spaceDiff);
        }
        count = expectQuantity * orderQuantity / (spaceDiff / 100);
      }
      this.form.entries[index].needQuantity = count.toFixed(2);
      return count.toFixed(2);
    },
    onAdd (index, row) {
      this.form.entries.splice(index + 1, 0 , {
          name: '',
          type: '',
          code: '',
          mode: '',
          spec: '',
          unit: '',
          color: '',
          unitQuantity: '',
          expectLoss: '',
          expectQuantity: '',
          orderQuantity: '',
          spaceDiff: '',
          needQuantity: '',
          operator: '',
          price: '',
          totalPrice: '',
          time: '',
          batchColor: ''
      })
    },
    onCopy (index, row) {
      this.form.entries.splice(index + 1, 0, Object.assign({}, row));
    },
    onDelete (index, row) {
      this.form.entries.splice(index, 1);
      if (this.form.entries.length <= 0 && index === 0) {
        this.onAdd(-1);
      }
    },
    onImport () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this._onImport();
        } else {
          this.$message.error('请完善表单信息');
        }
      })
    },
    _onImport () {
      const flag = this.checkRepeat(this.form.entries);

      if (flag) {
        this.$emit('onSelect', this.arrangeData(this.form.entries));
      }
    },
    arrangeData (entries) {
      let result = [];
      let stark = [];

      stark = stark.concat(entries);

      while (stark.length) {
        let temp = stark.shift();
        result.push(temp);
        result = result.concat(stark.filter(item => item.code === temp.code));
        stark = stark.filter(item => item.code !== temp.code);
      }
      result.forEach(item => {
        if (item.batchColor == '') {
          item.batchColor = false;
        }
        if (Number.isNaN(Number.parseFloat(item.spaceDiff))) {
          item.spaceDiff = 1;
        } else {
          item.spaceDiff = Number.parseFloat(item.spaceDiff) / 100;
        }
      })
      return result;
    },
    checkRepeat (entries) {
      let stark = [];

      stark = stark.concat(entries);

      let repeat;
      let formRepeat;
      while (stark.length) {
        let temp = stark.shift();
        repeat = stark.filter(item => item.code === temp.code);
        if (repeat.length > 0) {
          if (repeat.filter(val => val.name === temp.name && val.type === temp.type && val.unit === temp.unit && val.operator === temp.operator).length !== repeat.length) {
            this.$message.warning('添加表单中存在相同物料编号 ' + temp.code + '，但名字、类型、单位不一致的物料，请先进行处理');
            return false;
          }
        }
        formRepeat = this.formData.materialEntities.filter(item => item.code === temp.code);
        if (formRepeat.length > 0) {
          if (formRepeat.filter(val => val.name === temp.name && val.type === temp.type && val.unit === temp.unit && val.operator === temp.operator).length !== formRepeat.length) {
            this.$message.warning('采购明细中已存在相同物料编号 ' + temp.code + '，但名字、类型、单位不一致的物料，请先进行处理');
            return false;
          }
        }
      }
      return true;
    }
  },
  data () {
    return {
      materialsType: this.$store.state.EnumsModule.MaterialsType,
      form: {
        entries: [{
          name: '',
          type: '',
          code: '',
          mode: '',
          spec: '',
          unit: '',
          color: '',
          unitQuantity: '',
          expectLoss: '',
          expectQuantity: '',
          orderQuantity: '',
          spaceDiff: '',
          needQuantity: '',
          operator: '',
          price: '',
          totalPrice: '',
          time: '',
          batchColor: ''
        }]
      }
    }
  }  
}
</script>

<style scoped>
  /deep/ .el-input__suffix {
    display: flex;
    align-items: center;
  }

  /deep/ .el-table--small td, .el-table--small th {
    padding: 8px 0px 0px 0px;
  }

  button {
    outline:none;
  }
   
  /deep/ .el-table .warning-row {
    background: oldlace;
  }
</style>