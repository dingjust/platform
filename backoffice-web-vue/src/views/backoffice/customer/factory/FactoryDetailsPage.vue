<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateBaseFactory">编辑</el-button>
        </span>
      </div>
      <factory-base-form :slot-data="slotData" :read-only="true"></factory-base-form>
    </el-card>

    <div class="pt-2"></div>

    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
        <span class="float-right">
          <el-button type="primary" size="mini" @click="onUpdateCertificateFactory">编辑</el-button>
        </span>
      </div>
      <factory-certificate-form :slot-data="slotData" :read-only="true" :is-newly-created="false"></factory-certificate-form>
      <el-carousel :interval="4000" type="card" >
        <el-carousel-item v-for="media in slotData.certificate" :key="media.url">
          <img style="width:100%;height: 100%" :src="media.url">
        </el-carousel-item>
      </el-carousel>
    </el-card>

    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!preview">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose">
          关闭
        </el-button>
      </el-col>
    </el-row>

    <el-dialog title="更新基本信息" width="90%"
               :visible.sync="factoryBaseFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <factory-Base-Form ref="FactoryBaseForm"
                         :slot-data="slotData"
                         :read-only="false"
                         :is-newly-created="false">
      </factory-Base-Form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitBaseForm(slotData)">确 定</el-button>
        <el-button @click="factoryBaseFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>

    <el-dialog title="更新认证信息" width="90%"
               :visible.sync="factoryCertificateFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <factory-certificate-form ref="FactoryCertificateForm"
                                :slot-data="slotData"
                                :read-only="false"
                                :is-newly-created="true">
      </factory-certificate-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="onSubmitCertificateForm(slotData)">确 定</el-button>
        <el-button @click="factoryCertificateFormDialogVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from 'axios';
  import FactoryBaseForm from './FactoryBaseForm';
  import FactoryCertificateForm from './FactoryCertificateForm';

  export default {
    name: 'FactoryDetailsPage',
    props: ['slotData', 'isNewlyCreated', 'preview'],
    components: {FactoryBaseForm, FactoryCertificateForm},
    methods: {
      onUpdateBaseFactory() {
        //Object.assign(this.slotData, this.slotData);
        this.factoryBaseFormDialogVisible = true;
      },
      onUpdateCertificateFactory() {
        //Object.assign(this.slotData, this.slotData);
        this.factoryCertificateFormDialogVisible = true;
      },
      onSubmitBaseForm(data) {
        const baseForm = this.$refs['FactoryBaseForm'];
        console.log(baseForm.getValue());
        axios.put('/djfactory/factory/updateBase', baseForm.getValue())
          .then(() => {
            // Bus.$emit('refreshVal', '');
            this.$message({
              type: 'success',
              message: '保存成功'
            });
            this.fn.closeSlider();
            // 刷新主体数据
          })
          .catch(error => {
            this.$message.error('保存失败');
          });
      },
      onSubmitCertificateForm(data) {
        const certificateForm = this.$refs['FactoryCertificateForm'];

        axios.put('/djfactory/factory/updateCertificate', certificateForm.getValue())
          .then(() => {
            // Bus.$emit('refreshVal', '');
            this.$message({
              type: 'success',
              message: '保存成功'
            });

            this.$refs.FactoryCertificateForm.onSubmit();

            this.fn.closeSlider();
            // 刷新主体数据
          })
          .catch(error => {
            this.$message.error('保存失败');
          });
      },
      onClose() {
        this.fn.closeSlider();
      }
    },
    data() {
      return {
        factoryBaseFormDialogVisible: false,
        factoryCertificateFormDialogVisible: false
      };
    }
  };
</script>
