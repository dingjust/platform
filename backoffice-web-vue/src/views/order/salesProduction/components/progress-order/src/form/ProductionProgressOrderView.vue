<template>
  <div class="finance-form-body">
<!--    <el-row class="info-title-row" type="flex" justify="space-between">-->
<!--      <div class="info-title">-->
<!--        <h6 class="info-title_text">{{getEnum('productionProgressPhaseTypes', progress.phase)}}</h6>-->
<!--      </div>-->
<!--    </el-row>-->
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="report-list-title">
          <h6>{{getEnum('productionProgressPhaseTypes', progress.phase)}}报工</h6>
        </div>
      </el-col>
    </el-row>
    <div class="form-main">
      <el-row type="flex" align="middle" class="progress-update-form-row" justify="space-between">
        <el-col :span="6">
          <h6 class="progress-update-form-text1">工单号：{{progress.id}}</h6>
        </el-col>
        <el-col :span="4" :offset="1">
          <h6 class="info-title_text">款号：{{purchaseOrder.product.skuID}}</h6>
        </el-col>
        <el-col :span="8">
          <h6 class="info-title_text">合作商：{{cooperatorName}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" :gutter="150" align="middle" class="progress-update-form-row">
        <el-col :span="12">
          <el-row type="flex" justify="space-between" align="middle" :gutter="10">
            <el-col :span="18">
              <h6 class="info-title_text" style="width:200px;">上报时间：{{progressOrder.reportTime | timestampToTime}}</h6>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex" align="middle" justify="space-between" :gutter="10">
            <el-col :span="18">
              <h6 class="progress-update-form-text1">上报人员：{{progressOrder.operator.name}}</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-between" align="middle" style="margin-bottom:20px;">
        <span>{{progressOrder.amount}}/{{purchaseOrder.totalQuantity}}</span>
      </el-row>
      <el-row type="flex">
        <table cellspacing="2" width="100%" :height="(colors.length+5)*30" class="order-table">
          <tr class="order-table-th_row">
            <td style="width:40px">颜色</td>
            <template v-for="item in sizes">
              <th :key="item.code">{{item.name}}</th>
            </template>
          </tr>
          <template v-for="(color,colorIndex) in colors">
            <tr :key="colorIndex">
              <td>{{color}}</td>
              <template v-for="(size,sizeIndex) in sizes">
                <td style="width:80px" :key="sizeIndex">
                  <span>{{getVariantNum(color,size.name)}}</span>
                </td>
              </template>
            </tr>
          </template>
        </table>
      </el-row>
      <el-row type="flex" align="top" class="progress-update-form-row">
        <el-col :span="2">
          <h6 class="progress-update-form-text1">上传图片：</h6>
        </el-col>
        <el-col :span="22" :offset="1">
          <production-media-image-card-show :medias="progressOrder.medias" />
        </el-col>
      </el-row>
      <el-row type="flex" align="top" class="progress-update-form-row">
        <el-col :span="2">
          <h6 class="progress-update-form-text1">备注：</h6>
        </el-col>
        <el-col :span="22" :offset="1">
          <el-input type="textarea" readonly :rows="3" placeholder="填写备注" v-model="progressOrder.remarks">
          </el-input>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import ProductionMediaImageCardShow from '../ProductionMediaImageCardShow';
  export default {
    name: 'ProductionProgressOrderView',
    props: ['progressOrder', 'purchaseOrder', 'progress'],
    components: {
      ProductionMediaImageCardShow
    },
    mixins: [],
    computed: {
      cooperatorName: function () {
        if (this.purchaseOrder.cooperator != null) {
          if (this.purchaseOrder.cooperator.type == 'ONLINE') {
            return this.purchaseOrder.cooperator.partner.name;
          } else {
            return this.purchaseOrder.cooperator.name;
          }
        } else {
          if (this.isBrand()) {
            if (this.purchaseOrder.belongTo != null) {
              return this.purchaseOrder.belongTo.name;
            } else {
              return this.purchaseOrder.companyOfSeller;
            }
          } else {
            if (this.purchaseOrder.purchaser != null) {
              return this.purchaseOrder.purchaser.name;
            } else {
              return this.purchaseOrder.companyOfSeller;
            }
          }
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
      }

    },
    methods: {
      getVariantNum (color, size) {
        var result = this.progressOrder.entries.filter(
          item => item.color == color && item.size == size
        );
        if (result.length != 0) {
          return result[0].quantity;
        } else {
          return '';
        }
      }
    },
    data () {
      return {

      }
    },
    created () {

    },
    mounted () {}

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
