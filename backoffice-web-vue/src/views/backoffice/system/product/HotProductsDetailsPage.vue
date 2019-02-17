<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
         <el-button type="primary" size="mini" @click="onUpdateInfo">编辑</el-button>
        </span>
      </div>
      <hot-products-base-form ref="baseForm"
                              :slot-data="slotData"
                              :read-only="true"
                              :is-newly-created="isNewlyCreated">
      </hot-products-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>图片</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateMedias">编辑</el-button>
        </span>
      </div>
      <div>
        <template>
          <img :src="slotData.media"/>
        </template>
      </div>
    </el-card>

    <el-dialog title="更新基本信息" width="90%"
               :visible.sync="formDialogVisible" :close-on-click-modal="false" :modal="false">
      <hot-products-base-form :slot-data="slotData"
                              :read-only="readOnly"
                              :is-newly-created="isNewlyCreated">
      </hot-products-base-form>
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

    <el-dialog title="更新图片" width="90%"
               :visible.sync="mediasFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <hot-products-media-form ref="mediaForm"
                               :slot-data="slotData"
                               :read-only="readOnly"
                               :is-newly-created="isNewlyCreated">
      </hot-products-media-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitMediaForm(slotData)">确 定</el-button>
        <el-button @click="mediasFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import HotProductsBaseForm from './HotProductsBaseForm';
  import HotProductsMediaForm from './HotProductsMediaForm';

  export default {
    name: 'HotProductsDetailsPage',
    components: {HotProductsBaseForm, HotProductsMediaForm},
    props: ['slotData', 'isNewlyCreated', 'preview', 'readOnly'],
    methods: {
      onClose() {
        this.fn.closeSlider();
      },
      onUpdateInfo() {
        this.formDialogVisible = true;
      },
      onUpdateMedias() {
        this.mediasFormDialogVisible = true;
      },
      async onSubmitBaseForm() {
        this.formDialogVisible = false;
        const baseForm = this.$refs['baseForm'];
        const result = await this.$http.put('/djbackoffice/system/hot-products', baseForm.getValue());
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.fn.closeSlider(true);
      },
      onSubmitMediaForm() {
        this.$refs['mediaForm'].onSubmit();
      }
    },
    data() {
      return {
        formDialogVisible: false,
        mediasFormDialogVisible: false
      }
    }
  }
</script>
