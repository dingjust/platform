<template>
  <div class="product-carousel-style">
    <el-row>
      <el-form ref="form" :inline="true" :rules="rules" :model="formData">
        <el-form-item prop="title">
          <template slot="label">
            <h6 class="formLabel">主标题:</h6>
          </template>
          <el-input style="width: 200px" placeholder="请输入主标题" v-model="formData.title"></el-input>
        </el-form-item>
        <div class="pt-2"></div>
        <promote-product-list :formData="slotData" @onProuductSelect="onProuductSelect"
                              @onListSearch="onListSearch" @onDelete="onDelete" @_moveNumber="_moveNumber"/>
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
    name: 'PromoteProductForYou',
    props: ['slotData', 'formData'],
    components: {PromoteProductList, PromoteProductToolbar},
    methods: {
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
              type: this.seeProductPlateType,
              sequenceProducts: []
            }
            this.$emit('onConfirm', data);
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      onListSearch (keyword) {
        this.$emit('onListSearch', keyword);
      },
      _moveNumber (index, modifyText, keyword) {
        this.$emit('_moveNumber', index, modifyText, keyword);
      },
      onDelete (row, keyword) {
        this.$emit('onDelete', row, keyword);
      }
    },
    data () {
      return {
        rules: {
          title: [
            { required: true, message: '必填', trigger: 'blur' },
            { max: 10, message: '主标题最多可输入10个字符', trigger: 'blur' }
          ]
        },
        count: 0,
        seeProductPlateType: 'RECOMMEND_FOR_YOU'
      }
    },
    created() {
      this.$emit('returnCount');
    },
    watch: {
      formData: {
        handler (val) {
          if (val) {
            this.$emit('operationCount');
          }
        },
        deep: true
      },
      slotData: {
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

  .formLabel {
    font-size: 12px;display: inline-block;
  }
</style>
