<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
         <el-button type="primary" size="mini" @click="onUpdateInfo">编辑</el-button>
        </span>
      </div>
      <partners-base-form ref="baseForm"
                          :slot-data="slotData"
                          :read-only="true"
                          :is-newly-created="isNewlyCreated">
      </partners-base-form>
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
      <partners-base-form :slot-data="slotData"
                          :read-only="readOnly"
                          :is-newly-created="isNewlyCreated">
      </partners-base-form>
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
      <partners-media-form ref="mediaForm"
                           :slot-data="slotData"
                           :read-only="readOnly"
                           :is-newly-created="isNewlyCreated">
      </partners-media-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitMediaForm(slotData)">确 定</el-button>
        <el-button @click="mediasFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import PartnersBaseForm from "./PartnersBaseForm";
  import PartnersMediaForm from "./PartnersMediaForm";
  import axios from "axios";

  export default {
    name: 'PartnersDetailsPage',
    components: {PartnersBaseForm, PartnersMediaForm},
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
      onSubmitBaseForm() {
        this.formDialogVisible = false;
        const baseForm = this.$refs['baseForm'];
        console.log(baseForm.getValue());
        axios.put("/djbackoffice/system/partners", baseForm.getValue())
          .then(() => {
            this.$message.success("保存成功");
            this.fn.closeSlider(true);
            //刷新主体数据
          }).catch(error => {
            this.$message.error("保存失败，原因：" + error.response.data.message);
          }
        );
      },
      onSubmitMediaForm() {
        this.$refs['mediaForm'].onSubmit();
      }
    },
    computed: {},
    data() {
      return {
        formDialogVisible: false,
        mediasFormDialogVisible: false
      }
    }
  }
</script>
