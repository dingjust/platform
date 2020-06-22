<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>发货单详情</h6>
          </div>
        </el-col>
      </el-row>
      <el-form :inline="true" label-position="left" label-width="70px">
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="3">
            <!-- <img width="54px" height="54px"
              :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'"> -->
            <img width="100px" height="100px" :src="'static/img/nopicture.png'">
          </el-col>
          <el-col :span="21">
            <el-row type="flex" style="padding: 10px 0px">
              <el-col :span="8">
                <h6 class="basic-label">产品名称：红烧猪蹄</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">货号：梅菜扣肉</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6 class="basic-label">发货方：红烧猪蹄</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">收货方：梅菜扣肉</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">发货负责人：烧鸡翅</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="12">
                <h6 class="basic-label">收货地址：广州市海珠区云顶同创汇二期</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px" v-if="formData.online">
              <el-col :span="8">
                <h6 class="basic-label">发货方式：顺丰快递</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">发货单号：SF017532492929</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px" v-else>
              <el-col :span="8">
                <h6 class="basic-label">物流方式：货拉拉</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">送货人：麻花腾</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">联系方式：19829999999</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="24">
            <color-size-box-table :data="[]" :colorSizeEntries="[]" :readOnly="true"/>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="8">
            <h6 class="basic-label">收货单：KY1000000001</h6>
          </el-col>
          <el-col :span="8">
            <h6 class="basic-label">收货单：KY1000000001</h6>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import {ColorSizeBoxTable} from '@/components/'
  export default {
    name: 'ShippingOrdersDetail',
    props: ['id'],
    components: {
      ColorSizeBoxTable
    },
    computed: {
    },
    methods: {
      async getDetail () {
        // TODO 获取发货单详情
      },
      async getCarriers() {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.carriers = result;
      },
      isOnline (flag) {
        if (flag) {
          this.formData.carrier = '';
          this.formData.deliverCode = '';
        }
      }
    },
    data() {
      return {
        formData: {
          online: false,
          carrier: ''
        },
        taskData: '',
        carriers: ''
      }
    },
    created() {
      this.getDetail();
      this.getCarriers();
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .basic-label {
    font-size: 14px;
    color: #606266;
  }

  /deep/ .el-form-item {
    margin-bottom: 0px;
  }

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 125px;
    height: 32px;
  }
</style>
