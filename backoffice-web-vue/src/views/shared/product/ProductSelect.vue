<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="请输入商品货号/名称" v-model="keyword"></el-input>
      </el-form-item>
      <el-button-group>
        <el-button type="primary" icon="el-icon-search" @click="onSearch">查询商品</el-button>
      </el-button-group>
    </el-form>
    <el-dialog title="请选择商品"
               :visible.sync="dialogVisible"
               :modal="false"
               :show-close="false">
      <product-select-list :multiple-selection="false" @onSelected="onSelected"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="onCancel">取 消</el-button>
        <el-button type="primary" :disabled="confirmDisabled" @click="onConfirm">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import ProductSelectList from './ProductSelectList';

  export default {
    name: 'ProductSelect',
    components: {ProductSelectList},
    mixins: [],
    computed: {},
    methods: {
      onSearch() {
        this.dialogVisible = true;
      },
      onSelected(product) {
        this.selectedProduct = {};
        Object.assign(this.selectedProduct, product);
        this.confirmDisabled = false;
      },
      onConfirm() {
        this.$emit('onSelected', this.selectedProduct);

        this.dialogVisible = false;
      },
      onCancel() {
        this.selectedProduct = null;
        this.dialogVisible = false;
      }
    },
    data() {
      return {
        keyword: '',
        selectedProduct: null,
        confirmDisabled: true,
        dialogVisible: false
      }
    },
    created() {
    }
  }
</script>
