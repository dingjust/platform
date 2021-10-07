<!--
* @Description: 扫码录入表单
* @Date 2021/09/24 13:42
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card class="scan-form">
      <el-row type="flex" align="center" style="margin-bottom: 10px">
        <h6 style="color: #F56C6C;margin:0px;width: 420px">* 请保证输入框获取焦点以及在英文输入法的情况下进行扫码录入，否则会出现扫码问题</h6>
        <el-input ref="input" size="mini" v-model="scanValue" @blur="getFocus" @keyup.enter.native="onInput"></el-input>
      </el-row>
      <el-row type="flex">
        <div class="scan-main">
          <div>
            <el-row type="flex" justify="space-between">
              <h6 style="margin: 0px">数据统计</h6>
              <el-row type="flex">
                <el-radio v-model="switchValue" label="ADD">添加</el-radio>
                <el-radio v-model="switchValue" label="DELETE">删除</el-radio>
              </el-row>
              <!-- <el-switch
                v-model="switchValue"
                active-color="#13ce66"
                inactive-color="#ff4949"
                active-value="ADD"
                inactive-value="DELETE"
                active-text="添加"
                inactive-text="删除">
              </el-switch> -->
            </el-row>
            <el-divider></el-divider>
            <el-row type="flex" style="flex-wrap: wrap">
              <div v-for="(index, value) in collatedData" :key="value" style="width: 50%">
                <h6 v-if="collatedData[value].value !== 0">
                  {{value}} : {{collatedData[value].value}}
                </h6>
              </div>
            </el-row>
          </div>
          <el-row type="flex" justify="center">
            <el-button type="primary" @click="visible = true">导入</el-button>
          </el-row>
        </div>
        <el-divider direction="vertical"></el-divider>
        <el-row style="width: 300px;">
          <h6>操作记录</h6>
          <el-table ref="resultTable" :data="scanData" :height="autoHeight">
            <el-table-column label="" prop="number" width="50px"/>
            <el-table-column label="编码" prop="value"/>
            <el-table-column label="类型" width="50px">
              <template slot-scope="scope">
                <h6 :style="'margin:0px;' + (scope.row.type === 'ADD' ? 'color: #13ce66' : 'color: #ff4949')">
                  {{scope.row.type === 'ADD' ? '添加' : '删除'}}
                </h6>
              </template>
            </el-table-column>
          </el-table>
        </el-row>
      </el-row>
    </el-card>
    <el-dialog title="录入数据" :visible.sync="visible" width="80%" :close-on-click-modal="false" :close-on-press-escape="false">
      <el-row class="scan-dialog" type="flex">
        <el-row style="min-width: 12em;">
          <div v-for="(index, value) in collatedData" :key="value" >
            <h6 v-if="collatedData[value].value !== 0" :class="collatedData[value].isSelect ? 'select-item' : ''">
              {{value}} : {{collatedData[value].value}}
            </h6>
          </div>
        </el-row>
        <el-divider direction="vertical"></el-divider>
        <el-row style="flex-grow: 1">
          <el-row type="flex">
            <el-input v-model="skuID" placeholder="请输入款号" style="margin-right: 10px" @keyup.enter.native="onSure"/>
            <el-button type="primary" @click="onSure">确定</el-button>
          </el-row>
          <el-divider></el-divider>
          <el-row type="flex" style="flex-wrap: wrap">
            <div class="table-item" v-for="(item, index) in submitData" :key="item.skuID">
              <table class="item-table" cellspacing="2">
                <tr v-for="val in item.variants" :key="val.skuID">
                  <td>{{val.skuID}}</td>
                  <td>{{val.quality}}</td>
                </tr>
                <tr>
                  <th>{{item.skuID}}(合计)</th>
                  <th>{{item.quality}}</th>
                </tr>
              </table>
              <el-row type="flex" justify="end" style="margin-bottom: 10px">
                <el-button type="danger" @click="onDelete(item, index)">删除</el-button>
              </el-row>
            </div>
          </el-row>
        </el-row>
      </el-row>
      <el-row type="flex" justify="center" align="center" style="margin-top: 20px">
        <el-button type="primary" @click="onConfirm">提交</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'ScanForm',
  methods: {
    onInput () {
      if (this.scanValue == '') {
        return
      }

      if (!this.collatedData[this.scanValue]) {
        this.$set(this.collatedData, this.scanValue, {
          value: 0,
          isSelect: false
        })
      }

      this.collatedData[this.scanValue].value += (this.switchValue === 'ADD' ? 1 : -1)

      this.scanData.unshift({
        number: this.scanData.length + 1,
        value: this.scanValue,
        type: this.switchValue
      })
      this.scanValue = ''

      this.getFocus()
    },
    getFocus () {
      if (this.visible) {
        return
      }
      this.$refs.input.focus()
    },
    onSure () {
      if (this.skuID.length <= 0) {
        this.$message.error('请输入款号')
        return
      }

      let index = this.submitData.findIndex(item => item.skuID === this.skuID)
      if (index === -1) {
        this.submitData.push({
          skuID: this.skuID,
          quality: 0,
          variants: []
        })
        index = this.submitData.length - 1
      }

      const length = this.skuID.length

      for (const key in this.collatedData) {
        if (Object.hasOwnProperty.call(this.collatedData, key)) {
          const element = this.collatedData[key];

          if (!element.isSelect && key.substring(0, length) === this.skuID) {
            var i = this.submitData[index].variants.findIndex(val => val.skuID === key)
            if (i > -1) {
              this.submitData[index].variants[i].quality += element.value 
            } else {
              this.submitData[index].variants.push({
                skuID: key,
                quality: element.value
              })
            }
            this.submitData[index].quality += element.value

            element.isSelect = true;
          } 
        }
      }
    },
    onConfirm () {
      this.$confirm('是否执行提交操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onConfirm()
      });
    },
    async _onConfirm () {
      const formData = this.submitData.filter(item => item.variants.length > 0)

      const url = this.apis().createInventory()
      const result = await this.$http.put(url, formData)

      const res = result.filter(val => val.code === 0);

      if (res.length <= 0) {
        this.$message.success('操作成功！')
        this.visible = false
        this.$router.go(-1)
      } else if (res.length > 0) {
        let str = ''
        res.forEach(val => {
          str += val.data + '：' + val.msg + '\r\n'
        })
        this.$message.error(str)
      } else {
        this.$message.error('操作失败！')
      }
    },
    onDelete (item, index) {
      item.variants.forEach(val => {
        this.collatedData[val.skuID].isSelect = false
      })

      this.submitData.splice(index, 1)
    }
  },
  data () {
    return {
      submitData: [],
      switchValue: 'ADD',
      scanValue: '',
      scanData: [],
      collatedData: {},
      visible: false,
      skuID: ''
    }
  },
  watch: {
    visible: function (nval, oval) {
      if (!nval) {
        this.getFocus()
      }
    }
  },
  mounted () {
    this.getFocus()
  }
}
</script>

<style scoped>
  .scan-form {
    padding: 0 12px 12px 12px;
  }

  .el-divider--vertical {
    height: auto;
  }

  .el-divider--horizontal {
    margin: 12px 0;
  }

  .scan-main {
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .item-table {
    border-right: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
    margin: 0 12px 12px 0;
  }

  .item-table tr td,
  .item-table tr th {
    font-size: 10px;
    height: 4em;
    border-top: 1px solid #DCDFE6;
    border-left: 1px solid #DCDFE6;
    text-align: center;
    min-width: 10em;
  }

  .select-item {
    text-decoration-line: line-through;
    color: #999999;
  }

  .table-item {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }
</style>