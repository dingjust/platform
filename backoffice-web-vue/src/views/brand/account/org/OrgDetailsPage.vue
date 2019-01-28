<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
         <el-button type="primary" size="mini" @click="onUpdateInfo">编辑</el-button>
        </span>
      </div>
      <org-base-form :slot-data="slotData"
                     :read-only="true"
                     :is-newly-created="isNewlyCreated">
      </org-base-form>
    </el-card>
    <el-dialog title="更新基本信息" width="90%"
               :visible.sync="formDialogVisible" :close-on-click-modal="false" :modal="false">
      <org-base-form ref="OrgBaseForm"
                     :slot-data="slotData"
                     :read-only="false"
                     :is-newly-created="false">
      </org-base-form>
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
  import OrgBaseForm from "./OrgBaseForm";
  import axios from "axios";

  export default {
    name: 'OrgDetailsPage',
    components: {OrgBaseForm},
    props: ['slotData', 'isNewlyCreated', 'preview'],
    methods: {
      onClose() {
        this.fn.closeSlider();
      },
      onUpdateInfo() {
        this.formDialogVisible = true;
      },
      onSubmitBaseForm() {
        this.formDialogVisible = false;
        axios.put("/djbrand/org", this.slotData)
          .then(() => {
            this.$message.success("保存成功");
            this.fn.closeSlider(true);
            //刷新主体数据
          }).catch(error => {
            this.$message.error("保存失败，原因：" + error.response.data.message);
          }
        );
      }
    },
    computed: {},
    data() {
      return {
        formDialogVisible: false
      }
    }
  }
</script>
