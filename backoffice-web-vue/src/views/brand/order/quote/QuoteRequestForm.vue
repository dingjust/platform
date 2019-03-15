<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="面料单价" prop="unitPriceOfFabric">
            <el-input-number class="w-100"
                             v-model="slotData.unitPriceOfFabric"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="辅料单价" prop="unitPriceOfExcipients">
            <el-input-number class="w-100"
                             v-model="slotData.unitPriceOfExcipients"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="加工单价" prop="unitPriceOfProcessing">
            <el-input-number class="w-100"
                             v-model="slotData.unitPriceOfProcessing"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="其他" prop="costOfOther">
            <el-input-number class="w-100"
                             v-model="slotData.costOfOther"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="打样费" prop="costOfSamples">
            <el-input-number class="w-100"
                             v-model="slotData.costOfSamples"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="确认交货时间" prop="expectedDeliveryDate">
            <el-date-picker class="w-100"
                            type="date"
                            v-model="slotData.expectedDeliveryDate"
                            placeholder="选择日期"
                            value-format="timestamp">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="备注" prop="remarks">
            <el-input class="w-100" v-model="slotData.remarks"></el-input>
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
        this.$refs['form'].validate(callback);
      },
      async getMinorCategories() {
        const result = await this.$http.get('/b2b/categories/cascaded');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      async getMajorCategories() {
        const result = await this.$http.get('/b2b/categories/majors');
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
        this.slotData.details.pictures.push(response);
      },
      async handleRemove(file) {
        // console.log(JSON.stringify(file));
        const result = await this.$http.delete('/djwebservices/media/' + file.id);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        const pictures = this.slotData.details.pictures || [];
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
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    data() {
      return {
        categories: [],
        majorCategories: [],
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
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
