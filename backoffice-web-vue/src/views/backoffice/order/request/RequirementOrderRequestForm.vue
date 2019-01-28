<template>
  <div class="animated fadeIn">
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
                            :value-format="defaultDateValueFormat"
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
  import axios from "axios";

  export default {
    name: "RequirementOrderRequestForm",
    props: ["slotData", "readOnly"],
    methods: {
      validate(callback) {
        this.$refs["form"].validate(callback);
      },
      getMinorCategories() {
        return axios.get('/djbackoffice/product/category/cascaded');
      },
      getMajorCategories() {
        return axios.get('/djbackoffice/product/category/majors');
      }
    },
    computed: {},
    data() {
      return {
        categories: [],
        majorCategories: [],
        machiningTypes: [{
          code: "LABOR_AND_MATERIAL",
          name: "包工包料"
        }, {
          code: "LIGHT_PROCESSING",
          name: "清加工"
        }],
        categoryProps: {
          label: "name",
          value: "code",
          children: "children"
        }
      }
    },
    created() {
      const _this = this;
      axios.all([this.getMinorCategories(), this.getMajorCategories()])
        .then(axios.spread(function (minors, majors) {
          _this.categories = minors.data;
          _this.majorCategories = majors.data;
        }));
    }
  }
</script>
