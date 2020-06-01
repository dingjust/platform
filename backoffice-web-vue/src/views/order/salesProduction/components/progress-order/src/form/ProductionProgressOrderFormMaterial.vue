<template>
  <div class="finance-form-body">
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="report-list-title">
          <h6>{{progress.progressPhase}}报工</h6>
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
            <h6 class="info-title_text">款号：{{belong.skuID}}</h6>
          </el-col>
          <el-col :span="8">
            <h6 class="info-title_text">合作商：{{cooperatorName}}</h6>
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
        <el-row>
          <table cellspacing="2" width="100%" class="order-table">
            <tr class="order-table-th_row">
              <template v-for="item in titleRow">
                <th :key="item">{{item}}</th>
              </template>
            </tr>
            <template v-for="item in progressOrder.materialPreparationEntries">
              <tr :key="item.id">
                <td :rowspan="item.colorEntries.length + 1">{{item.materialsName}}</td>
                <td :rowspan="item.colorEntries.length + 1">{{item.spec}}</td>
                <td :rowspan="item.colorEntries.length + 1">{{getEnum('MaterialsUnit', item.materialsUnit)}}
                </td>
                <td :rowspan="item.colorEntries.length + 1">{{getEnum('MaterialsType', item.materialsType)}}
                </td>
              </tr>
              <template v-for="(val, index) in item.colorEntries">
                <tr :key="val.id">
                  <td>{{val.materialsColor}}</td>
                  <!-- 实际需求数量 -->
                  <td v-if="readOnly" style="width:120px">
                    {{val.actualDemandQuantity}}
                  </td>
                  <td v-else style="width:120px">
                    <el-input class="order-table-input" type="number" @mousewheel.native.prevent
                      v-model="val.actualDemandQuantity" :min="1" :placeholder="'剩余'"></el-input>
                  </td>
                  <!-- 实际收货数量 -->
                  <td v-if="readOnly" style="width:120px">
                    {{val.actualReceivedQuantity}}
                  </td>
                  <td v-else style="width:120px">
                    <el-input class="order-table-input" type="number" @mousewheel.native.prevent
                      v-model="val.actualReceivedQuantity" :min="1" :placeholder="'剩余'">
                    </el-input>
                  </td>
                  <td v-if="index === 0 && readOnly" :rowspan="item.colorEntries.length + 1" style="width:120px">
                    <!-- 物料状态 -->
                    {{getEnum('MaterialsType', item.materialsType)}}
                  </td>
                  <td v-if="index === 0 && !readOnly" :rowspan="item.colorEntries.length + 1" style="width:120px">
                    <el-select v-model="item.status" class="w-100" value-key="code">
                      <el-option v-for="element in statuses" :key="element.code" :label="element.name"
                        :value="element.code">
                      </el-option>
                    </el-select>
                  </td>
                </tr>
              </template>
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
    name: 'ProductionProgressOrderFormMaterial',
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
        if (this.currentUser.companyCode == this.belong.partyACompany.uid) {
          return this.belong.partyBCompany.name;
        } else {
          return this.belong.partyACompany.name;
        }
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
    },
    data() {
      return {
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
        statuses: this.$store.state.EnumsModule.ProgressReportMaterialStatus,
        showTabelData: '',
        tableData: [],
        titleRow: ['物料名称', '物料规格', '物料单位', '物料属性', '物料颜色', '实际需求数量', '实际收货数量', '状态'],
      }
    },
    created() {
      if (!this.readOnly) {
        this.progressOrder.materialPreparationEntries = this.belong.materialsSpecEntries.map(entry => {
          var obj = {
            status: null,
            title: entry.title,
            position: entry.position,
            materialsId: entry.materialsId,
            materialsCode: entry.materialsCode,
            materialsName: entry.materialsName,
            unitQuantity: entry.unitQuantity,
            lossRate: entry.lossRate,
            materialsType: entry.materialsType,
            materialsUnit: entry.materialsUnit,
            spec: entry.spec.name
          };
          var colorEntries = entry.materialsColorEntries.map(element => {
            return {
              materialsColor: element.materialsColor.name,
              actualDemandQuantity: '',
              actualReceivedQuantity: '',
            };
          });
          obj['colorEntries'] = colorEntries;
          return obj;
        });
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

</style>
