<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
         <el-button type="primary" size="mini" @click="onUpdateInfo">编辑</el-button>
        </span>
      </div>
      <address-base-form ref="baseForm"
                          :slot-data="slotData"
                          :read-only="true"
                          :is-newly-created="isNewlyCreated">
      </address-base-form>
    </el-card>

    <el-dialog title="更新基本信息" width="90%"
               :visible.sync="formDialogVisible" :close-on-click-modal="false" :modal="false">
      <address-base-form ref="AddressForm"
                     :slot-data="slotData"
                     :read-only="false"
                     :is-newly-created="false">
      </address-base-form>
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
  import axios from 'axios';

  import AddressForm from './AddressForm';
  import AddressBaseForm from './AddressBaseForm';

  export default {
    name: 'AddressDetailsPage',
    components: {AddressBaseForm, AddressForm},
    props: ['slotData', 'isNewlyCreated', 'preview'],
    methods: {
      getValue(){
        return this.slotData;
      },
      onClose() {
        this.fn.closeSlider(false);
      },
      onUpdateInfo() {
        this.formDialogVisible = true;
      },
      onSubmitBaseForm() {
        const baseForm = this.$refs['baseForm'];
        baseForm.validate(valid => {
          if (!valid) {
            return false;
          }

          this.formDialogVisible = false;

          axios.put('/djbrand/system/address',baseForm.getValue())
            .then(() => {
              this.$message.success('保存成功');

              //刷新主体数据
              this.fn.closeSlider();
            }).catch(error => {
              this.$message.error('保存失败，原因：' + error.response);
            }
          );

        });

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
