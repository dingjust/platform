<template>
  <div class="animated fadeIn">
    <el-row :gutter="10">
      <el-col :span="24">
        <el-upload
          name="file"
          :disabled="readOnly"
          :action="mediaUploadUrl"
          list-type="picture-card"
          :data="uploadFormData"
          :before-upload="onBeforeUpload"
          :on-success="onSuccess"
          :headers="headers"
          :file-list="slotData.pictures"
          :on-preview="handlePreview"
          :on-remove="handleRemove">
          <i class="el-icon-plus"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible" :modal="false" :close-on-click-modal="false">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
      </el-col>
    </el-row>
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly"
             :rules="rules">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="生产大类" prop="majorCategory">
            <el-select v-model="slotData.majorCategory" class="w-100"
                       value-key="code">
              <el-option v-for="item in majorCategories"
                         :key="item.code"
                         :label="item.name"
                         :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品类别" prop="category">
            <el-select class="w-100"
                       placeholder="请选择"
                       v-model="slotData.category"
                       value-key="code">
              <el-option-group
                v-for="group in categories"
                :key="group.code"
                :label="group.name">
                <el-option
                  v-for="item in group.children"
                  :key="item.code"
                  :label="item.name"
                  :value="item">
                </el-option>
              </el-option-group>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="预计加工总数量" prop="expectedMachiningQuantity">
            <el-input-number class="w-100"
                             v-model="slotData.expectedMachiningQuantity"
                             :min="1">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="预计交货时间" prop="expectedDeliveryDate">
            <el-date-picker class="w-100"
                            type="date"
                            v-model="slotData.expectedDeliveryDate"
                            placeholder="选择日期"
                            value-format="timestamp">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="期望价格" prop="maxExpectedPrice">
            <el-input-number class="w-100"
                             v-model="slotData.maxExpectedPrice">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="加工类型" prop="machiningType">
            <el-select class="w-100" v-model="slotData.machiningType">
              <el-option v-for="item in machiningTypes"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系人" prop="contactPerson">
            <el-input v-model="slotData.contactPerson"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系电话" prop="contactPhone">
            <el-input v-model.number="slotData.contactPhone"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="生产区域" prop="productiveOrientations">
            <el-select class="w-100" v-model="slotData.productiveOrientations"
                       value-key="isocode" multiple>
              <el-option
                v-for="item in regions"
                :key="item.isocode"
                :label="item.name"
                :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否提供样衣" prop="samplesNeeded">
            <el-radio-group v-model="slotData.samplesNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否需要发票" prop="invoiceNeeded">
            <el-radio-group v-model="slotData.invoiceNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否需要打样" prop="proofingNeeded">
            <el-radio-group v-model="slotData.proofingNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
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
        return this.$refs['form'].validate(callback);
      },
      async getMinorCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      async getMajorCategories() {
        const url = this.apis().getMajorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.majorCategories = result;
      },
      async getRegions() {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.regions = result;
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
        this.slotData.pictures.push(response);
      },
      async handleRemove(file) {
        // console.log(JSON.stringify(file));
        const result = await this.$http.delete('/b2b/media/' + file.id);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        const pictures = this.slotData.pictures || [];
        const index = pictures.indexOf(file);
        pictures.splice(index, 1);

        this.$message.success("删除成功");
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      }
    },
    computed: {
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup',
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    data() {
      let checkCategory = (rule, value, callback) => {
        console.log(value);
        if (value==null||value.code === ''||value === {}) {
          callback(new Error('请选择品类'));
        }
        callback();
      };
      let expectedDeliveryDate = (rule, value, callback) => {
          if (this.compareDate(new Date(), new Date(value))) {
            callback(new Error('预计交货时间不能小于当前时间'));
          }
        callback();
      };
      let contactPhone = (rule, value, callback) => {
        console.log(Number.isInteger(value));
        if (!Number.isInteger(value)) {
          callback(new Error('请输入数字值'));
        }
        callback();
      };
      return {
        categories: [],
        majorCategories: [],
        regions: [],
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        dialogImageUrl: '',
        dialogVisible: false,
        rules: {
          category: [{validator: checkCategory, trigger: 'change'},{required: true, message: '必填', trigger: 'change'}],
          expectedMachiningQuantity: [{required: true, message: '必填', trigger: 'blur'}],
          expectedDeliveryDate: [{required: true, message: '必填', trigger: 'blur'},{validator: expectedDeliveryDate, trigger: 'blur'}],
          // contactPhone: [{required: true, message: '必填', trigger: 'blur'},{validator: contactPhone, trigger: 'blur'}],
          contactPerson: [{required: true, message: '必填', trigger: 'blur'}],
        },
      }
    },
    created() {
      this.getMinorCategories();
      this.getMajorCategories();
      this.getRegions();
    }
  }
</script>
