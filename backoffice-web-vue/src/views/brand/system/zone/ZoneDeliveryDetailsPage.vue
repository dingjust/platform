<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
         <el-button type="primary" size="mini" @click="onUpdateInfo">编辑</el-button>
        </span>
      </div>
      <zone-delivery-base-form :slot-data="slotData"
                               :read-only="true"
                               :is-newly-created="isNewlyCreated">
      </zone-delivery-base-form>
    </el-card>
    <el-dialog title="更新运费模板" width="90%"
               :visible.sync="formDialogVisible" :close-on-click-modal="false" :modal="false">
      <zone-delivery-base-form ref="ZoneDeliveryBaseForm"
                               :slot-data="slotData"
                               :read-only="false"
                               :is-newly-created="false">
      </zone-delivery-base-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitBaseForm(slotData)">确 定</el-button>
        <el-button @click="formDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose()">关闭</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ZoneDeliveryBaseForm from './ZoneDeliveryBaseForm';

  export default {
    name: 'ZoneDeliveryDetailsPage',
    components: {ZoneDeliveryBaseForm},
    props: ['slotData', 'isNewlyCreated', 'preview'],
    methods: {
      onClose() {
        this.fn.closeSlider();
      },
      onUpdateInfo() {
        this.formDialogVisible = true;
      },
      async onSubmitBaseForm() {
        this.formDialogVisible = false;
        const result = await this.$http.put('/djbrand/zoneDelivery', this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.fn.closeSlider(true);
      }
    },
    data() {
      return {
        formDialogVisible: false
      }
    }
  }
</script>
