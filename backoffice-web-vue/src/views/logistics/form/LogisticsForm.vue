<!--
* @Description: 添加物流单号表单
* @Date 2021/11/25 16:08
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>添加物流单号</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <button class="add-btn" @click="toScanning">+ 扫描快递单号</button>
      <div class="pt-4"></div>
      <el-table :data="tableData" :height="autoHeight">
        <el-table-column label="快递编号" prop="code" />
        <el-table-column label="换货编号" prop="relationCode">
          <template slot-scope="scope">
            <el-input v-model="tableData[scope.$index].relationCode"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="快递类型">
          <template slot-scope="scope">
            <el-select v-model="tableData[scope.$index].type">
              <el-option v-for="item in ExpressType" :key="item.code" :label="item.name" :value="item.code" />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="款号">
          <template slot-scope="scope">
            <el-input v-model="tableData[scope.$index].skuID"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="产品名称" >
          <template slot-scope="scope">
            <el-input v-model="tableData[scope.$index].productName"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="颜色" min-width="200px">
          <template slot-scope="scope">
            <el-select v-model="tableData[scope.$index].colors" multiple filterable allow-create default-first-option >
              <el-option v-for="item in colorOptions" :key="item" :label="item" :value="item" />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="尺码" min-width="200px">
          <template slot-scope="scope">
            <el-select v-model="tableData[scope.$index].sizes" multiple filterable allow-create default-first-option >
              <el-option v-for="item in sizeOptions" :key="item" :label="item" :value="item" />
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="质量问题" >
          <template slot-scope="scope">
            <el-select v-model="tableData[scope.$index].defected">
              <el-option label="有" :value="true"></el-option>
              <el-option label="无" :value="false"></el-option>
            </el-select>
          </template>
        </el-table-column>
        <el-table-column label="备注">
          <template slot-scope="scope">
            <el-input v-model="tableData[scope.$index].remarks"></el-input>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" @click="onDeleteTable(scope.$index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-3"></div>
      <el-row type="flex" justify="center" align="middle">
        <el-button type="primary" class="sumbit-btn" @click="onAdd">提交</el-button>
      </el-row>
    </el-card>
    <el-dialog title="添加快递单号" :visible.sync="visible" width="400px" append-to-body :close-on-click-modal="false" :close-on-press-escape="false" :show-close="false">
      <div v-if="visible">
        <el-input ref="input" v-model="expressCode" @blur="getFocus" @keyup.enter.native="onInput"></el-input>
        <el-table :data="expressCodeArr" :height="autoHeight">
          <el-table-column label="快递编号" prop="code" />
          <el-table-column label="操作" width="60px">
            <template slot-scope="scope">
              <el-button type="text" @click="onDelete(scope.$index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="pt-2"></div>
        <el-row type="flex" justify="end">
          <el-button type="default" @click="onCancel">取消</el-button>
          <el-button type="primary" @click="onSumbit">确定</el-button>
        </el-row>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'LogisticsForm',
  methods: {
    onDeleteTable (index) {
      this.tableData.splice(index, 1)
    },
    onDelete (index) {
      this.expressCodeArr.splice(index, 1)
    },
    toScanning () {
      this.visible = true
      setTimeout(() => {
        this.getFocus()
      }, 100);
    },
    getFocus () {
      this.$refs.input.focus()
    },
    onInput () {
      if (this.expressCode === '') {
        this.getFocus()
        return
      }

      if ((this.expressCodeArr.findIndex(val => val.code === this.expressCode) > -1) || (this.tableData.findIndex(val => val.code === this.expressCode) > -1)) {
        this.$message.error('已存在此快递单号')
        this.expressCode = ''
        return
      }

      this.expressCodeArr.push({
        code: this.expressCode,
        relationCode: '',
        type: 'RETURNED',
        skuID: '',
        productName: '',
        colors: [],
        sizes: [],
        defected: false,
        remarks: ''
      })
      this.expressCode = ''
    },
    onCancel () {
      this.expressCode = ''
      this.expressCodeArr = []
      this.visible = false
    },
    onSumbit () {
      this.tableData = this.tableData.concat(this.expressCodeArr)
      this.onCancel()
    },
    onAdd () {
      if (this.tableData.length <= 0) {
        this.$message.error('请先添加数据！')
        return
      }

      this.$confirm('是否提交表单数据?', '提示', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onAdd()
      });
    },
    async _onAdd () {
      const data = this.tableData

      const url = this.apis().createBatchLogistics()
      const result = await this.$http.post(url, data)

      if (result.every(item => item.code === 1)) {
        this.$message.success('操作成功')
        this.$router.push('/logistics/list')
      } else {
        this.$message.error('操作失败')
      }
    }
  },
  data () {
    return {
      expressCode: '',
      expressCodeArr: [],
      visible: false,
      tableData: [],
      ExpressType: [
        {
          code: 'RETURNED',
          name: '退货'
        },
        {
          code: 'EXCHANGED',
          name: '换货'
        }
      ],
      colorOptions: ['白色', '绿色', '紫色', '红色', '粉红', '金色'],
      sizeOptions: ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL', 'XXXXXL']
    }
  }
}
</script>

<style scoped>
.add-btn {
  height: 50px;
  border: 0.5px dashed rgba(0, 0, 0, 0.15);
  width: 100%;
  background: #FFFFFF;
  color: rgba(0, 0, 0, 0.65);
}

.add-btn:hover {
  background: rgba(247, 247, 247, 1);
}

.sumbit-btn {
  height: 40px;
  width: 120px; 
}
</style>