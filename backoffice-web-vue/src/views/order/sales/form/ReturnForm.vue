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
    <el-form ref="form" :model="form" label-width="80px" label-position="left" :rules="rules" hide-required-asterisk>
      <div class="sales-deliver-form-content">
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item prop="type">
              <template slot="label">
                <h6 class="titleTextClass">退货方式<span style="color: #F56C6C">*</span></h6>
              </template>
              <el-select v-model="form.type" placeholder="请选择" style="width:100%">
                <el-option
                  v-for="item in refundType"
                  :key="item.value"
                  :label="item.name"
                  :value="item.code">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <el-col :span="20">
            <el-form-item prop="reason">
              <template slot="label">
                <h6 class="titleTextClass">退货原因<span style="color: #F56C6C">*</span></h6>
              </template>
              <el-input v-model="form.reason" type="textarea" :rows="5"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <!-- <el-col :span="4">
            上传凭证：
          </el-col> -->
          <el-col :span="20">
            <el-form-item label="上传凭证" prop="images">
              <images-upload class="product-images-form-upload" :slot-data="form.images"/>
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
    name: 'ReturnForm',
    props: ['code'],
    components: {
      ImagesUpload
    },
    computed: {},
    methods: {
      onSubmit () {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      _onSubmit () {
        const formData = {
          code: this.code,
          refundType: this.form.type,
          applyReason: this.form.reason,
          applyImages: this.form.images
        }
        this.$emit('submitReturnForm', formData);
      }
    },
    data () {
      var checkType = (rule, value, callback) => {
        if (!value) {
          return callback(new Error('请选择退货方式'));
        } else {
          callback();
        }
      };
      return {
        carriers: [],
        form: {
          type: '',
          reason: '',
          images: []
        },
        refundType: [{
          code: 'ONLY_MONEY',
          name: '仅退钱'
        }
        // {
        //   code: 'MONEY_AND_PRODUCT',
        //   name: '退钱退货'
        // }
        ],
        rules: {
          type: [{ type: 'string', validator: checkType, trigger: 'change' }],
          reason: [{required: true, message: '请填写退款原因', trigger: 'change'}]
        }
      };
    },
    created () {},
    mounted () {}
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

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 65px;
    font-size: 14px;
    /*font-weight: bold;*/
  }

</style>
