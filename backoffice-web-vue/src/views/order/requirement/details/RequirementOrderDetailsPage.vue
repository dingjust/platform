<template>
  <div class="animated fadeIn">
    <requirement-order-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <requirement-order-operate-toolbar :read-only="slotData.editable" @onUpdate="onUpdate" @onReview="onReview"/>
    <div class="pt-2"></div>
    <requirement-order-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <requirement-order-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    
    <el-dialog title="审核" width="450px" :visible.sync="this.reviewVisible" :before-close="handleClose">
      <requirement-order-labels-form :slotData = "slotData" :read-only="false"></requirement-order-labels-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog title="修改" width="600px" :visible.sync="this.updateVisible" :before-close="handleClose">
      <requirement-order-update-form :slotData = "slotData"></requirement-order-update-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  import RequirementOrderFormToolbar from '../toolbar/RequirementOrderFormToolbar';
  import RequirementOrderOperateToolbar from '../toolbar/RequirementOrderOperateToolbar';
  import RequirementOrderForm from '../form/RequirementOrderForm';
  import RequirementOrderUpdateForm from '../form/RequirementOrderUpdateForm';
  import RequirementOrderLabelsForm from '../form/RequirementOrderLabelsForm';

  export default {
    name: 'RequirementOrderDetailsPage',
    props: ['slotData'],
    components: {
      RequirementOrderFormToolbar,
      RequirementOrderOperateToolbar,
      RequirementOrderForm,
      RequirementOrderUpdateForm,
      RequirementOrderLabelsForm
    },
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      handleClose(done) {
        this.reviewVisible = false;
        this.updateVisible = false;
      },
      async update() {
        console.log(this.slotData);
        const expectedDeliveryDate = this.slotData.details.expectedDeliveryDate;
        if (this.compareDate(new Date(), new Date(expectedDeliveryDate))) {
          this.$message.error('预计完成时间不能小于当前时间');
          return false;
        }
        let formData = this.slotData;

        const url = this.apis().updateRequirementOrder(formData.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('更新成功，订单编号： ' + result);
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
        this.updateVisible = false;
        this.reviewVisible = false;
      },
      onUpdate() {
        this.reviewVisible = false;
        this.updateVisible = true;
      },
      onReview() {
        this.reviewVisible = true;
        this.updateVisible = false;
      },
      onSubmit() {
        this.$refs['form'].validate((valid) => {
          if (valid) {

            this._onSubmit();
            return true;
          }

          return false;
        });
      },
      _getDate(timestamp) {
        const result = new Date(timestamp);
        return result.getFullYear() + '' + result.getMonth() + '' + result.getDate();
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;

        const url = this.apis().createRequirementOrder();
        const result = await this.$http.post(url, formData);
        console.log(result);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('发布需求成功，订单编号： ' + result);
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
      }
    },
    computed: {

      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        updateVisible:false,
        reviewVisible:false,
        item:{},

      }
    }
  }
</script>
