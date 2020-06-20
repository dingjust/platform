<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>创建发货单</h6>
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
                <h6 class="baisc-lable">产品名称：红烧猪蹄</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">发货方：梅菜扣肉</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">收货方：烧鸡翅</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6 class="baisc-lable">货号：红烧猪蹄</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">发货负责人：梅菜扣肉</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">联系方式：烧鸡翅</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <h6 class="baisc-lable">收货地址</h6>
            </el-row>
            <el-row type="flex" align="middle">
              <el-col :span="8">
                <el-form-item label="发货方式">
                  <el-select v-model="formData.carrier" :disabled="formData.online" :placeholder="''">
                    <template v-for="item in carriers">
                      <el-option :label="item.name" :value="item.code" :key="item.code"></el-option>
                    </template>
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="发货单号">
                  <el-input v-model="formData.deliverCode" style="width: 194px" :disabled="formData.online"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-checkbox v-model="formData.online" @change="isOnline"></el-checkbox>
                <span class="basci-label">线下物流<span style="color: #F56C6C">(勾选后无需填写发货方式和单号)</span></span>
              </el-col>
            </el-row>
            <el-row type="flex" align="middle" v-if="formData.online">
              <el-col :span="8">
                <el-form-item label="物流方式">
                  <el-input style="width: 194px"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="送货人">
                  <el-input style="width: 194px"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="联系方式">
                  <el-input style="width: 194px"></el-input>
                </el-form-item>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="24">
            <color-size-box-table :data="[]" :colorSizeEntries="[]"/>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
          <el-button class="sumbit-btn" @click="onCreate">确认创建</el-button>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import {ColorSizeBoxTable} from '@/components/'
  export default {
    name: 'ShippingOrdersPage',
    components: {
      ColorSizeBoxTable
    },
    computed: {
    },
    methods: {
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
      },
      onCreate () {
        // TODO 创建发货单
        this.$router.go(-1);
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
      if (this.$route.params.taskData) {
        this.taskData = this.$route.params.taskData;
      }
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

  .baisc-lable {
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
