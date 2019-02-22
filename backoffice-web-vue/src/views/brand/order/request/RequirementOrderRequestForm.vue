<template>
  <div class="animated fadeIn">
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload
          name="file"
          :action="mediaUploadUrl"
          list-type="picture-card"
          :data="uploadFormData"
          :before-upload="onBeforeUpload"
          :on-success="onSuccess"
          :file-list="files"
          :on-preview="handlePictureCardPreview"
          :on-remove="handleRemove">
          <i class="el-icon-plus"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" :modal="false">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
      </el-col>
    </el-row>
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="产品类别" prop="minorCategories">
            <el-cascader class="w-100"
                         v-model="slotData.details.minorCategories"
                         :options="categories"
                         :props="categoryProps"
                         :show-all-levels="false">
            </el-cascader>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="产品大类" prop="majorCategory">
            <el-select v-model="slotData.details.majorCategory.code" class="w-100">
              <el-option v-for="item in majorCategories"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="预计加工总数量" prop="expectedMachiningQuantity">
            <el-input-number class="w-100"
                             v-model="slotData.details.expectedMachiningQuantity">
            </el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="预计交货时间" prop="expectedDeliveryDate">
            <el-date-picker class="w-100"
                            type="date"
                            v-model="slotData.details.expectedDeliveryDate"
                            placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="期望价格" prop="maxExpectedPrice">
            <el-input-number class="w-100"
                             v-model="slotData.details.maxExpectedPrice">
            </el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="加工类型" prop="machiningType">
            <el-select class="w-100" v-model="slotData.details.machiningType">
              <el-option v-for="item in machiningTypes"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="联系人" prop="contactPerson">
            <el-input v-model="slotData.details.contactPerson"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="联系电话" prop="contactPhone">
            <el-input v-model="slotData.details.contactPhone"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="是否提供样衣" prop="samplesNeeded">
            <el-radio-group v-model="slotData.details.samplesNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="是否需要发票" prop="invoiceNeeded">
            <el-radio-group v-model="slotData.details.invoiceNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <!--<el-col :span="20">
          <el-upload ref="uploadForm" :disabled="readOnly"
                     name="files"
                     :multiple="true"
                     list-type="picture-card"
                     :file-list="files"
                     :auto-upload="false">
            <i class="el-icon-plus"></i>
            <div slot="tip" class="el-upload__tip">文件大小不超过10MB</div>
          </el-upload>
        </el-col>-->
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderRequestForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async getMinorCategories() {
        const result = await this.$http.get('/djbackoffice/product/category/cascaded');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      async getMajorCategories() {
        const result = await this.$http.get('/djbackoffice/product/category/majors');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.majorCategories = result;
      },
      onBeforeUpload(file) {
        if (file.type !== 'image/jpeg'
          && file.type !== 'image/png'
          && file.type !== 'image/gif') {
          this.$message.error('只允许上传图片');
          return false;
        }
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onSuccess(response) {
        // this.slotData.images.push(response);
        // this.$set(this.slotData, "images", this.slotData.images);
      },
      async handleRemove(file) {
        // console.log(JSON.stringify(file));
        const result = await this.$http.delete('/djwebservices/media/' + file.response.id);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success("删除成功");
      },
      handlePictureCardPreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      }
    },
    computed: {
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
        };
      },
    },
    data() {
      return {
        categories: [],
        majorCategories: [],
        machiningTypes: [{
          code: 'LABOR_AND_MATERIAL',
          name: '包工包料'
        }, {
          code: 'LIGHT_PROCESSING',
          name: '清加工'
        }],
        categoryProps: {
          label: 'name',
          value: 'code',
          children: 'children'
        },
        files: [],
        dialogImageUrl: '',
        dialogVisible: false
      }
    },
    created() {
      this.getMinorCategories();
      this.getMajorCategories();
    }
  }
</script>
