<template>
  <div class="finance-form-body">
    <!--    <el-row class="info-title-row" type="flex" justify="space-between">-->
    <!--      <div class="info-title">-->
    <!--        <h6 class="info-title_text">{{getEnum('productionProgressPhaseTypes', progress.phase)}}报工</h6>-->
    <!--      </div>-->
    <!--    </el-row>-->
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="report-list-title">
          <h6>{{progress.progressPhase.name}}报工</h6>
        </div>
      </el-col>
    </el-row>
    <el-form ref="form" :model="progressOrder" :rules="rules" :disabled="readOnly">
      <div class="form-main">
        <el-row type="flex" align="middle" class="progress-update-form-row" justify="space-between">
          <el-col :span="6">
            <h6 class="progress-update-form-text1">工单号：{{progress.id}}</h6>
          </el-col>
          <el-col :span="4" :offset="1">
            <h6 class="info-title_text">款号：{{belong.product.skuID}}</h6>
          </el-col>
          <el-col :span="8">
            <h6 class="info-title_text">合作商：
              <span v-if="belong.cooperator">{{cooperatorName}}</span>
              <span v-else style="color: #C0C4CC">自有工厂</span>
            </h6>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="150" align="middle" class="progress-update-form-row">
          <el-col :span="12">
            <el-form-item prop="reportTime">
              <el-row type="flex" justify="space-between" align="middle" :gutter="10" v-if="!readOnly">
                <el-col :span="6">
                  <h6 class="progress-update-form-text1">上报时间：</h6>
                </el-col>
                <el-col :span="18">
                  <div style="width:100%;">
                    <el-date-picker style="width:100%;" class="progress-update-form-datepicker"
                      v-model="progressOrder.reportTime" type="date" placeholder="选择日期">
                    </el-date-picker>
                  </div>
                </el-col>
              </el-row>
              <el-row v-else>
                <h6 class="info-title_text" style="width:200px;">上报时间：{{progressOrder.reportTime | timestampToTime}}
                </h6>
              </el-row>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item>
              <el-row type="flex" align="middle" justify="space-between" :gutter="10" v-if="!readOnly">
                <el-col :span="6">
                  <h6 class="progress-update-form-text1">上报人员：</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="operator" :disabled="true">
                    <el-option label="采购部-刘少立" value="确认订单"></el-option>
                  </el-select>
                </el-col>
              </el-row>
              <el-row type="flex" align="middle" v-else>
                <h6 class="progress-update-form-text1">上报人员：{{progressOrder.operator.name}}</h6>
              </el-row>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" justify="space-between" align="middle">
          <table cellspacing="2" width="100%" class="order-table">
            <tr class="order-table-th_row">
              <template v-for="item in titleRow">
                <th :key="item">{{item}}</th>
              </template>
              <th v-if="!readOnly">操作</th>
            </tr>
            <tr v-if="progressOrder.preProductionSampleEntries.length <= 0">
              <td colspan="5" style="padding: 8px;color: #909399">暂无数据</td>
            </tr>
            <template v-for="(item, index) in progressOrder.preProductionSampleEntries">
              <tr :key="index">
                <td v-if="readOnly">{{item.colorText}}</td>
                <td v-else>
                  <el-form-item :prop="'preProductionSampleEntries.' + index + '.colorText'"
                    :rules="{required: true, message: '不能为空', trigger: 'change'}" class="form-item">
                    <el-select v-model="item.colorText">
                      <el-option v-for="val in colors" :key="val" :label="val" :value="val"
                        :disabled="isDisabledColor(val, item)">
                      </el-option>
                    </el-select>
                  </el-form-item>
                </td>
                <td v-if="readOnly">{{item.sizeText}}</td>
                <td v-else>
                  <el-form-item :prop="'preProductionSampleEntries.' + index + '.sizeText'"
                    :rules="{required: true, message: '不能为空', trigger: 'change'}" class="form-item">
                    <el-select v-model="item.sizeText">
                      <el-option v-for="val in sizes" :key="val.name" :label="val.name" :value="val.name"
                        :disabled="isDisabledSize(val.name, item)">
                      </el-option>
                    </el-select>
                  </el-form-item>
                </td>
                <td v-if="readOnly">{{item.status!=null?getEnum('ProgressReportSampleStatus', item.status):''}}</td>
                <td v-else>
                  <el-form-item :prop="'preProductionSampleEntries.' + index + '.status'"
                    :rules="{required: true, message: '不能为空', trigger: 'change'}" class="form-item">
                    <el-select v-model="item.status">
                      <el-option v-for="val in statuses" :key="val.name" :label="val.name" :value="val.code">
                      </el-option>
                    </el-select>
                  </el-form-item>
                </td>
                <td v-if="readOnly" width="500">{{item.approvalComments}}</td>
                <td v-else width="400">
                  <el-input class="order-table-input" v-model="item.approvalComments" />
                </td>
                <td v-if="!readOnly" width="100">
                  <el-button type="text" :disabled="index==0" @click="onDelete(index)">删除</el-button>
                </td>
              </tr>
            </template>
          </table>
        </el-row>
        <el-row type="flex" align="top" class="progress-update-form-row">
          <el-button @click="addRow" v-if="!readOnly">+ 添加</el-button>
        </el-row>
        <el-row type="flex" align="top" class="progress-update-form-row">
          <el-col :span="2">
            <h6 class="progress-update-form-text1">上传图片:</h6>
          </el-col>
          <el-col :span="22" :offset="1">
            <images-upload v-if="!readOnly" class="order-purchase-upload" :slot-data="progressOrder.medias" />
            <production-media-image-card-show v-if="readOnly" :medias="progressOrder.medias" />
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
      </div>
    </el-form>
    <el-row type="flex" justify="center" align="top" class="progress-update-form-row">
      <el-button size="mini" v-if="!readOnly" class="update-form-submit" @click="onSubmit">确定</el-button>
      <el-button size="mini" class="update-form-submit" @click="onClose">关闭</el-button>
    </el-row>
  </div>
</template>

<script>
  import ImagesUpload from '@/components/custom/ImagesUpload';
  import ProductionMediaImageCardShow from '../ProductionMediaImageCardShow';

  export default {
    name: 'ProductionProgressOrderFormSample',
    props: {
      progressOrder: {
        type: Object
      },
      belong: {
        type: Object
      },
      progress: {
        type: Object
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    components: {
      ProductionMediaImageCardShow,
      ImagesUpload
    },
    mixins: [],
    computed: {
      cooperatorName: function () {
        if (this.belong.cooperator.partner) {
          return this.belong.cooperator.partner.name;
        } else {
          return this.belong.cooperator.name;
        }
      },
      sizes: function () {
        var sizes = [];
        this.belong.colorSizeEntries.forEach(element => {
          sizes.push(element.size);
        });
        const res = new Map();
        var result = sizes.filter((size) => !res.has(size.code) && res.set(size.code, 1));
        return result.sort((o1, o2) => o1.sequence - o2.sequence);
      },
      colors: function () {
        var colors = new Set([]);
        this.belong.colorSizeEntries.forEach(element => {
          colors.add(element.color.name);
        });
        return colors;
      },
    },
    methods: {
      onClose() {
        this.$emit('onClose')
      },
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
            if (this.progressOrder.id != null && this.progressOrder.id != '') {
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
        form.id = '';
        form.operator.id = this.$store.getters.currentUser.id;
        const result = await this.$http.put(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('修改成功');
        this.$emit('callback');
      },
      isDisabledColor(colorName, item) {
        if (item.sizeText == '') {
          return false;
        } else {
          let sizeRow = [];
          this.progressOrder.preProductionSampleEntries.forEach(val => {
            if (val.sizeText == item.sizeText) {
              sizeRow.push(val);
            }
          });
          return sizeRow.findIndex(val => val.colorText == colorName) > -1;
        }
      },
      isDisabledSize(sizeName, item) {
        if (item.colorText == '') {
          return false;
        } else {
          let colorRow = [];
          this.progressOrder.preProductionSampleEntries.forEach(val => {
            if (val.colorText == item.colorText) {
              colorRow.push(val);
            }
          });
          return colorRow.findIndex(val => val.sizeText == sizeName) > -1;
        }
      },
      addRow() {
        this.progressOrder.preProductionSampleEntries.push({
          colorText: '',
          sizeText: '',
          status: '',
          approvalComments: null
        });
      },
      onDelete(index) {
        this.progressOrder.preProductionSampleEntries.splice(index, 1);
      }
    },
    data() {
      return {
        titleRow: ['颜色', '尺码', '状态', '审批意见'],
        allOrdersShow: false,
        operator: this.$store.getters.currentUser.username,
        currentUser: this.$store.getters.currentUser,
        rules: {
          reportTime: [{
            type: 'date',
            required: true,
            message: '请选择日期',
            trigger: 'blur'
          }]
        },
        statuses: this.$store.state.EnumsModule.ProgressReportSampleStatus,
        showTabelData: ''
      }
    },
    created() {
      if (!this.readOnly) {
        this.addRow();
      }
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

  .report-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .form-item {
    padding-top: 15px;
  }

  /deep/.el-form-item--small .el-form-item__error {
    padding-top: 2px;
    padding-left: 20px;
  }

</style>
