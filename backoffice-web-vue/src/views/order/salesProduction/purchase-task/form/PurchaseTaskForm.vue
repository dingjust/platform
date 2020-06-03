<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-list-title">
            <h6>创建采购订单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :model="formData">
        <purchase-task-form-top :formData="formData"/>
        <el-divider></el-divider>
        <purchase-task-form-table :formData="formData" @appendMaterial="appendMaterial"/>
      </el-form>
      <el-button class="material-btn" @click="onSumbit">保存</el-button>
    </el-card>
    <el-dialog :visible.sync="materialVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false"
               :append-to-body="true">
      <material-dialog @confirmMaterial="confirmMaterial" v-if="materialVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters
  } = createNamespacedHelpers(
    'PurchaseTaskModule'
  );

  import PurchaseTaskFormTop from './PurchaseTaskFormTop';
  import PurchaseTaskFormTable from './PurchaseTaskFormTable';
  import MaterialDialog from '../../../../product/material/dialog/MaterialDialog';
  export default {
    name: 'PurchaseTaskForm',
    components: {MaterialDialog, PurchaseTaskFormTable, PurchaseTaskFormTop},
    computed: {
      ...mapGetters({
        formData: 'formData'
      })
    },
    methods: {
      appendMaterial () {
        this.materialVisible = true;
      },
      confirmMaterial (data) {
        console.log(data);
        this.materialVisible = false;
      },
      onSumbit () {

      }
    },
    data () {
      return {
        materialVisible: false
      }
    },
    created () {

    }
  }
</script>

<style scoped>
  .sales-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  /deep/ .el-divider--horizontal {
     margin: 0px 0;
  }
</style>
