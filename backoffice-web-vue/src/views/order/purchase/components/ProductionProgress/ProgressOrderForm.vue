<template>
  <div class="finance-form-body">
    <el-row class="info-title-row" type="flex" justify="space-between">
      <div class="info-title">
        <h6 class="info-title_text">{{getEnum('productionProgressPhaseTypes', progress.phase)}}</h6>
      </div>
    </el-row>
    <el-form ref="form" :model="progressOrder" :rules="rules">
      <div class="form-main">
        <el-row type="flex" align="middle" class="progress-update-form-row" justify="space-between">
          <el-col :span="6">
            <h6 class="progress-update-form-text1">工单号:{{progress.id}}</h6>
          </el-col>
          <el-col :span="4" :offset="1">
            <h6 class="info-title_text">款号:{{purchaseOrder.product.skuID}}</h6>
          </el-col>
          <el-col :span="8">
            <h6 class="info-title_text">合作商:{{cooperatorName}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="150" align="middle" class="progress-update-form-row">
          <el-col :span="12">
            <el-form-item prop="reportTime">
              <el-row type="flex" justify="space-between" align="middle" :gutter="10">
                <el-col :span="6">
                  <h6 class="progress-update-form-text1">上报时间:</h6>
                </el-col>
                <el-col :span="18">
                  <div style="width:100%;">
                    <el-date-picker style="width:100%;" class="progress-update-form-datepicker"
                      v-model="progressOrder.reportTime" type="date" placeholder="选择日期">
                    </el-date-picker>
                  </div>
                </el-col>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item>
            <el-row type="flex" align="middle" justify="space-between" :gutter="10">
              <el-col :span="6">
                <h6 class="progress-update-form-text1">上报人员:</h6>
              </el-col>
              <el-col :span="18">
                <el-select v-model="operator" :disabled="true">
                  <el-option label="采购部-刘少立" value="确认订单"></el-option>
                </el-select>
              </el-col>
            </el-row>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="space-between" align="middle" style="margin-bottom:20px;">
          <span>{{variantTotal}}/{{purchaseOrder.totalQuantity}}</span>
        </el-row>
        <el-row type="flex">
          <table cellspacing="2" width="100%" :height="(colors.length+5)*30" class="order-table">
            <tr class="order-table-th_row">
              <td style="width:40px">颜色</td>
              <template v-for="item in sizes">
                <th :key="item.code">{{item.name}}</th>
              </template>
            </tr>
            <template v-for="(sizeArray,colorIndex) in entries">
              <tr :key="colorIndex">
                <td>{{sizeArray[0].color}}</td>
                <template v-for="(item,sizeIndex) in sizeArray">
                  <td style="width:80px" :key="sizeIndex">
                    <el-input class="order-table-input" type="number" v-model="item.quantity"
                      :placeholder="countRemainNum(item.color,item.size)"></el-input>
                  </td>
                </template>
              </tr>
            </template>
          </table>
        </el-row>
        <el-row type="flex" align="top" class="progress-update-form-row">
          <el-col :span="2">
            <h6 class="progress-update-form-text1">上传图片:</h6>
          </el-col>
          <el-col :span="22" :offset="1">
            <images-upload class="order-purchase-upload" :slot-data="progressOrder.medias" />
          </el-col>
        </el-row>
        <el-row type="flex" align="top" class="progress-update-form-row">
          <el-col :span="2">
            <h6 class="progress-update-form-text1">备注:</h6>
          </el-col>
          <el-col :span="22" :offset="1">
            <el-input type="textarea" :rows="3" placeholder="填写备注" v-model="progressOrder.remarks">
            </el-input>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="top" class="progress-update-form-row">
          <el-button size="mini" class="update-form-submit" @click="onSubmit">确定</el-button>
        </el-row>
      </div>
    </el-form>
  </div>
</template>

<script>
  import ImagesUpload from '@/components/custom/ImagesUpload';
  import ProgressColorSizeTable from './ProgressColorSizeTable';

  export default {
    name: 'ProgressOrderForm',
    props: ['progressOrder', 'purchaseOrder', 'progress'],
    components: {
      ImagesUpload
    },
    mixins: [],
    computed: {
      cooperatorName: function () {
        if (this.purchaseOrder.cooperator.type == 'ONLINE') {
          return this.purchaseOrder.cooperator.partner.name;
        } else {
          return this.purchaseOrder.cooperator.name;
        }
      },
      sizes: function () {
        var sizes = [];
        this.purchaseOrder.entries.forEach(element => {
          sizes.push(element.product.size);
        });
        const res = new Map();
        var result = sizes.filter((size) => !res.has(size.code) && res.set(size.code, 1));
        return result.sort((o1, o2) => o1.sequence - o2.sequence);
      },
      colors: function () {
        var colors = new Set([]);
        this.purchaseOrder.entries.forEach(element => {
          colors.add(element.product.color.name);
        });
        return colors;
      },
      variantTotal: function () {
        var result = 0;
        this.entries.forEach(entry => {
          entry.forEach(item => {
            if (item.quantity != '') {
              let num = parseInt(item.quantity);
              if (num != null && num != '') {
                result = num + result;
              }
            }
          });
        });
        return result;
      }
    },
    methods: {
      getVariant(color, size, entries) {
        var result = entries.filter(
          item => item.color == color && item.size == size
        );
        if (result.length != 0) {
          return result[0];
        } else {
          return null;
        }
      },
      onSubmit() {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            if (this.progressOrder.id != null && this.progressOrder.id != "") {
              this._onUpdate();
            } else {
              this._onCreate();
            }
          }
        });
      },
      async _onCreate() {
        const url = this.apis().createProductionProgressOrder(this.progress.id);
        let form = Object.assign({}, this.progressOrder);
        let variantEntries = [];
        this.entries.forEach(sizeArray => {
          sizeArray.filter(item => item.quantity != '').forEach(item => {
            variantEntries.push(item);
          });
        });
        form.entries = variantEntries;
        form.operator.id = this.$store.getters.currentUser.id;
        const result = await this.$http.post(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('创建成功');
        this.$emit('callback');
      },
      async _onUpdate() {
        const url = this.apis().updateProductionProgressOrder(this.progress.id, this.progressOrder.id);
        let form = Object.assign({}, this.progressOrder);
        form.id = "";
        let variantEntries = [];
        this.entries.forEach(sizeArray => {
          sizeArray.filter(item => item.quantity != '').forEach(item => {
            variantEntries.push(item);
          });
        });
        form.entries = variantEntries;
        form.operator.id = this.$store.getters.currentUser.id;
        const result = await this.$http.put(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('修改成功');
        this.$emit('callback');
      },
      countRemainNum(color, size) {
        var need = this.purchaseOrder.entries.filter(
          item => item.product.color.name == color && item.product.size.name == size
        );
        if (need.length != 0) {        
          var sum = 0;
          var result = this.progress.productionProgressOrders.filter(order=>order.status=='PASS').forEach(order => {
            var result = order.entries.filter(entry => entry.color == color && entry
              .size == size);
            if (result.length != 0 && result[0].quantity != '') {
              sum += result[0].quantity;
            }
          });
          if(need[0].quantity<sum){
            return "";
          }
          return '剩余未报' + (need[0].quantity - sum);
        } else {
          return "";
        }
      }
    },
    data() {
      return {
        allOrdersShow: false,
        operator: this.$store.getters.currentUser.username,
        entries: [],
        form: {
          reportTime: '',

        },
        rules: {
          reportTime: [{
            type: 'date',
            required: true,
            message: '请选择日期',
            trigger: 'blur'
          }],
        }
      }
    },
    created() {
      //初始化表格
      this.entries = [];
      this.colors.forEach(color => {
        var sizeArray = [];
        this.sizes.forEach(size => {
          if (this.progressOrder.entries.length == 0) {
            sizeArray.push({
              size: size.name,
              color: color,
              quantity: ""
            });
          } else {
            let variant = this.getVariant(
              color,
              size.name,
              this.progressOrder.entries
            );
            if (variant != null) {
              sizeArray.push(variant);
            } else {
              sizeArray.push({
                size: size.name,
                color: color,
                quantity: ""
              });
            }
          }
        });
        this.entries.push(sizeArray);
      });
    },
    mounted() {}

  }

</script>
<style scoped>
  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
  }

  /* .order-table-th_row {
    height: 80px;
  } */

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }

  .order-table-btn_add {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
  }

  .progress-update-form-text1 {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
    font-size: 12px;
    padding-top: 5px;
  }

  .progress-update-form-datepicker {
    font-size: 12px;
  }

  .progress-update-form-row {
    margin-bottom: 10px;
  }

  .order-purchase-upload {}

  .order-purchase-upload>>>.el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload>>>.el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .update-form-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 50px;
  }

  .form-main {
    padding-left: 50px;
    padding-right: 50px;
  }

  .show-btn-row {
    margin-bottom: 20px;
  }

  .icon_arrow {
    font-family: "iconfont" !important;
    font-size: 12px;
    font-weight: 400;
    color: #66b1ff;
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

</style>
