<!-- 
 * @description: 外发订单取消申请 
 * @fileName: OutboundCancelForm.vue 
 * @author: yj 
 * @date: 2020-08-20 10:51:59
 * @version: V1.0.0 
!-->
<template>
  <div class="form-body">
    <el-row type="flex" justify="center">
      <h6>选择要取消的订单</h6>
    </el-row>
    <el-table ref="multipleTable" :data="canbeCancelOrders" tooltip-effect="dark" style="width: 100%"
      @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55">
      </el-table-column>
      <el-table-column label="订单号" prop="code" />
      <el-table-column prop="product.name" label="产品" />
      <el-table-column prop="product.skuID" label="货号" />
      <el-table-column prop="quantity" label="数量" />
    </el-table>
    <div class="form-box">
      <el-form :model="form" label-position="top" ref="form">
        <el-form-item label="取消的原因" prop="reason" :rules="[{ required: true, message: '请输入取消原因', trigger: 'blur' },]">
          <el-input type="textarea" v-model="form.reason"></el-input>
        </el-form-item>
        <el-row type="flex" justify="center">
          <el-button @click="onSubmit" class="material-btn">提交</el-button>
        </el-row>
      </el-form>
    </div>
  </div>
</template>

<script>
  export default {
    name: "OutboundCancelForm",
    props: {
      order: {
        type: Object
      }
    },
    computed: {
      //可以取消的订单(待生产订单)
      canbeCancelOrders: function () {
        return this.order.taskOrderEntries.filter(entry => entry.state == 'TO_BE_PRODUCED');
      }
    },
    methods: {
      onSubmit() {
        if (this.form.multipleSelection.length < 1) {
          this.$message.error('请选择取消订单');
          return 0;
        } else {
          this.$refs['form'].validate((valid) => {
            if (valid) {
              this._onSubmit();
            }
          });
        }
      },
      async _onSubmit() {
        const url = this.apis().outboundOrderCancel(this.order.id);
        let submitForm = {
          'id': this.order.id,
          'reason': this.form.reason,
          'taskOrders': this.form.multipleSelection.map(order => order.id)
        };

        const result = await this.$http.post(url, submitForm);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("生成成功");
        this.$set(this.order, 'uniqueCode', result);
      },
      async onCreate() {
        const url = this.apis().generateUniqueCodeForSale(this.order.code);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("生成成功");
        this.$set(this.order, 'uniqueCode', result);
      },
      handleSelectionChange(val) {
        this.form.multipleSelection = val;
      }
    },
    data() {
      return {
        form: {
          multipleSelection: [],
          reason: ''
        }
      };
    },
    created() {},
  };

</script>
<style scoped>
  .form-box {
    padding: 20px 20px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 120px;
    height: 40px;
  }

</style>
