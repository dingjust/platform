<template>
  <div class="animated fadeIn">
    <pick-order-status-bar :status="slotData.status"></pick-order-status-bar>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <pick-order-base-form ref="pickOrderBaseForm" :slot-data="slotData" :read-only="true"/>
      <div class="pt-2"></div>
    </el-card>
    <div class="pt-2"></div>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>发料单行</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateOrAddEntries">编辑</el-button>
        </span>
      </div>
      <pick-order-entries-form ref="pickOrderEntriesForm" :slot-data="slotData" :read-only="true"/>
    </el-card>

    <el-dialog title="更新发料单行信息" width="90%"
               :visible.sync="entriesFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <pick-order-entries-form ref="PickOrderEntriesForm"
                               :slot-data="entriesData"
                               :read-only="false"
                               :is-newly-created="false">
      </pick-order-entries-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitBaseForm(slotData)">确 定</el-button>
        <el-button @click="entriesFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from 'axios';
  import PickOrderBaseForm from './PickOrderBaseForm';
  import PickOrderEntriesForm from "./PickOrderEntriesForm";
  import PickOrderStatusBar from "./PickOrderStatusBar";

  export default {
    name: "PickOrderDetailsPage",
    props: ["slotData", "readOnly"],
    components: {PickOrderStatusBar, PickOrderBaseForm, PickOrderEntriesForm},
    methods: {
      onUpdateOrAddEntries() {
        Object.assign(this.entriesData.entries, this.slotData.entries);
        this.entriesFormDialogVisible = true;
      },
      onSubmitBaseForm(data) {
        this.entriesFormDialogVisible = false;
        if (!this.$refs['PickOrderEntriesForm'].validate()) {
          return;
        }
        let formData = this.slotData;
        formData.entries = this.entriesData.entries;
        console.log(formData);
        axios.put('/djbackoffice/pickOrder', formData)
          .then(response => {

            this.$message.success("物料单行修改成功!");

            this.fn.closeSlider(true);
          }).catch(error => {
            this.$message.success("物料单行修改失败!");
          }
        );
      }
    },
    computed: {},
    data() {
      return {
        entriesFormDialogVisible: false,
        entriesData: {
          id: null,
          createdTs: '',
          code: this.slotData.code,
          entries: []
        }
      }
    }
  }
</script>
