<template>
  <div class="product-carousel-style">
    <el-row>
      <el-form ref="form" :inline="true" :rules="rules" :model="formData">
        <promote-product-toolbar :formData="formData"/>
      </el-form>
    </el-row>
    <el-row type="flex" justify="center">
      <el-button @click="onConfirm" style="background-color: #FFD60C" size="medium">保存并提交</el-button>
    </el-row>
  </div>
</template>

<script>
    import PromoteProductToolbar from '../toolbar/PromoteProductToolbar';
    export default {
      name: 'PromoteProductToday',
      components: {PromoteProductToolbar},
      props: ['formData'],
      methods: {
        onConfirm () {
          this.$refs['form'].validate(valid => {
            if (valid) {
              this._onConfirm();
            } else {
              this.$message.error('请完善表单信息');
              return false;
            }
          });
        },
        _onConfirm () {
          const id = this.formData.id ? this.formData.id : null;
          const submitData = {
            id: id,
            title: this.formData.title,
            subTitle: this.formData.subTitle,
            picture: this.formData.picture,
            type: this.seeProductPlateType
          };
          this.$emit('onConfirmToday', submitData);
        },
        validateField (name) {
          this.$refs.form.validateField(name);
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
          seeProductPlateType: 'TODAY_NEW',
          count: 0
        }
      },
      created () {
        this.$emit('returnCount');
      },
      watch: {
        'formData.picture': function (n, o) {
          this.validateField('picture');
        },
        formData: {
          handler (val) {
            if (val) {
              this.$emit('operationCount');
            }
          },
          deep: true
        }
      }
    }
</script>

<style scoped>
  .product-carousel-style {
    padding: 15px;
  }
</style>
