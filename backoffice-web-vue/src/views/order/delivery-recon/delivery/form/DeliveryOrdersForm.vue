<template>
  <div class="animated fadeIn content">
    <el-card class="delivery-form">
      <el-row type="flex" justify="space-between">
        <el-col class="list-title">
          <h6>创建出货单</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :model="formData" :inline="true" class="form-container" label-width="80px">
        <el-row type="flex" align="top">
          <el-form-item label="标题" prop="title" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
            <el-input v-model="formData.title" placeholder="请输入出货单标题"></el-input>
          </el-form-item>
        </el-row>
        <el-row type="flex" align="top">
          <div style="display: flex;">
            <div>
              <el-form-item label="合作商" prop="cooperator" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
                <el-input v-model="formData.cooperator.name" :disabled="true"></el-input>
              </el-form-item>
            </div>
            <div>
              <el-button type="primary" class="select-btn" @click="cooperatorVisible = true">选择</el-button>
            </div>
          </div>
        </el-row>
        <el-row type="flex" align="top">
          <el-form-item label="单据" prop="medias" :rules="{ required: true, message: '不能为空', trigger: 'change' }">
            <images-upload ref="imagesUpload" :slotData="formData.medias" :limit="10"></images-upload>
          </el-form-item>
        </el-row>
        <el-row type="flex" align="top">
          <el-form-item label="备注">
            <el-input v-model="formData.remarks" placeholder="请输入备注"></el-input>
          </el-form-item>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center">
        <el-button class="sumbit-btn" @click="onCreate">创建</el-button>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="cooperatorVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <supplier-select v-if="cooperatorVisible" @onSelect="onSuppliersSelect" />
    </el-dialog>
  </div>
</template>

<script>
import { ImagesUpload, SupplierSelect } from '@/components'

export default {
  name: 'DeliveryOrdersForm',
  components: {
    ImagesUpload,
    SupplierSelect
  },
  data () {
    return {
      cooperatorVisible: false,
      formData: {
        title: '',
        cooperator: '',
        medias: [],
        remarks: ''
      }
    }
  },
  methods: {
    onSuppliersSelect (val) {
      this.formData.cooperator = val;
      this.cooperatorVisible = false;
    },
    validateField (name) {
      this.$refs.form.validateField(name);
    },
    onCreate () {
      if (this.$refs.imagesUpload.isUploading()) {
        this.$message.warning('图片正在上传中，请稍等...');
        return;
      }

      this.$refs.form.validate((valid) => {
        if (valid) {
          this._onCreate();
        } else {
          this.$message.error("请完善表单信息！");
        }
      })
    },
    async _onCreate () {
      const form = Object.assign({}, this.formData);

      const url = this.apis().createDelivery();
      const result = await this.$http.post(url, form);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.$message.success('出货单创建成功！');
      this.$router.push('/order/delivery-Reconciliation');
    }
  },
  watch: {
    'formData.medias': function (nval, oval) {
      this.validateField('medias');
    },
  },
}
</script>

<style scoped>
  .list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 16px;
  }
  
  .form-container {
    margin: 0 0 0 20px;
  }

  .select-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
  }

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
    width: 80px;
  }

  .delivery-form >>> .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .delivery-form >>> .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }
</style>