<template>
  <div class="product-carousel-style">
    <el-row>
      <el-form ref="form" :inline="true" :rules="rules" :model="formData">
        <promote-product-toolbar :formData="formData"/>
        <div class="pt-2"></div>
        <promote-product-list :formData="slotData" @onProuductSelect="onProuductSelect"/>
      </el-form>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button @click="onConfirm" style="background-color: #FFD60C" size="medium">保存并提交</el-button>
    </el-row>
  </div>
</template>

<script>
  import PromoteProductToolbar from '../toolbar/PromoteProductToolbar';
  import PromoteProductList from '../list/PromoteProductList';
  export default {
    name: 'PromoteProductLive',
    props: ['slotData', 'formData'],
    components: {PromoteProductList, PromoteProductToolbar},
    methods: {
      validateField (name) {
        this.$refs.form.validateField(name);
      },
      onProuductSelect () {
        this.$emit('onProuductSelect');
      },
      onConfirm () {
        this.$refs['form'].validate(valid => {
          if (valid) {
            const id = this.formData.id ? this.formData.id : null;
            const data = {
              id: id,
              title: this.formData.title,
              subTitle: this.formData.subTitle,
              picture: this.formData.picture,
              type: this.seeProductPlateType,
              sequenceProducts: []
            }
            this.$emit('onConfirm', data);
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      }
    },
    data () {
      var checkProfilePicture = (rule, value, callback) => {
        if (JSON.stringify(this.formData.picture) == '{}') {
          return callback(new Error('请上传产品图片'));
        } else {
          callback();
        }
      };
      return {
        rules: {
          title: [
            { required: true, message: '必填', trigger: 'blur' },
            { max: 10, message: '主标题最多可输入10个字符', trigger: 'blur' }
          ],
          subTitle: [
            { required: true, message: '必填', trigger: 'blur' },
            { max: 8, message: '副标题最多可输入8个字符', trigger: 'blur' }
          ],
          picture: [
            {validator: checkProfilePicture, required: true, type: 'object', trigger: 'change'}
          ]
        },
        seeProductPlateType: 'LIVE_BROADCAST_PROVIDE',
        count: 0
      }
    },
    watch: {
      'formData.picture': function (n, o) {
        this.validateField('picture');
      },
      // formData: {
      //   handler (val) {
      //     if (val) {
      //       this.count++
      //       console.log(this.count);
      //     }
      //   },
      //   deep: true
      // }
    }
  }
</script>

<style scoped>
  .product-carousel-style {
    padding: 15px;
  }

  .formLabel {
    font-size: 12px;display: inline-block;
  }
</style>
