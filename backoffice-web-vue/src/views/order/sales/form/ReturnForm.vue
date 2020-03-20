<template>
  <div>
    <el-row>
      <el-col :span="3">
        <div class="orders-list-title">
          <h6>申请退货</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-form ref="form" :model="form" label-width="80px" label-position="left">
      <div class="sales-deliver-form-content">
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="退货方式">
              <el-select v-model="form.type" placeholder="请选择" :disabled="form.isOffline" style="width:100%">
                <el-option :key="1" label="退货退款" value="1" />
                <el-option :key="2" label="仅退款" value="2" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <el-col :span="20">
            <el-form-item label="退货原因">
              <el-input v-model="form.reason" type="textarea" :rows="5"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <!-- <el-col :span="4">
            上传凭证：
          </el-col> -->
          <el-col :span="20">
            <el-form-item label="上传凭证">
              <images-upload class="product-images-form-upload" :slot-data="images" />
            </el-form-item>
          </el-col>
        </el-row>
      </div>
      <el-row type="flex" justify="center">
        <!-- <el-col :span="12"> -->
        <el-button class="sales-order-btn" @click="onSubmit">确定</el-button>
        <!-- </el-col> -->
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import ImagesUpload from '@/components/custom/ImagesUpload';

  export default {
    name: "ReturnForm",
    props: ["code"],
    components: {
      ImagesUpload
    },
    computed: {},
    methods: {
      onSubmit() {
        this.$emit('onSubmit');
      },
    },
    data() {
      return {
        carriers: [],
        images: [],
        form: {
          type: '',
          reason: ''
        }
      };
    },
    created() {},
    mounted() {}
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .sales-deliver-form-content {
    padding: 10px 20px 10px 20px;
  }

  .product-images-form-upload {
    margin-left: 50px;
  }

  .product-images-form-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .product-images-form-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

</style>
