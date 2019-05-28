<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <el-form ref="basicForm"
               label-position="top"
               :model="slotData">
        <el-form-item label="自动关闭时间" prop="cancelledDate">
          <el-row :gutter="10">
            <el-col :span="6">
              <el-date-picker class="w-100"
                              type="date"
                              v-model="slotData.cancelledDate"
                              placeholder="选择日期"
                              value-format="timestamp">
              </el-date-picker>
            </el-col>

          </el-row>
        </el-form-item>
      </el-form>
    </el-card>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
        <el-form ref="simpleRequestForm"
                 label-position="top"
                 :model="slotData.details"
                 :rules="rulesSimple">
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="产品类别" prop="category">
              <el-select class="w-100"
                         placeholder="请选择"
                         v-model="slotData.details.category"
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
            <el-form-item label="加工数量" prop="expectedMachiningQuantity">
              <el-input-number class="w-100"
                               v-model="slotData.details.expectedMachiningQuantity"
                               :min="1">
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="交货时间" prop="expectedDeliveryDate">
              <el-date-picker class="w-100"
                              type="date"
                              v-model="slotData.details.expectedDeliveryDate"
                              placeholder="选择日期"
                              value-format="timestamp">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
          <el-row :gutter="10">
            <el-col :span="6">
              <el-form-item label="联系人" prop="contactPerson">
                <el-input v-model="slotData.details.contactPerson"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="联系电话" prop="contactPhone">
                <el-input v-model.number="slotData.details.contactPhone"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
      </el-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit()">提交</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'RequirementOrderSimpleFrom',
    components: {},
    // mixins: [OrderMixin],
    props: ['slotData'],
    methods: {
      validate(callback) {
        return this.$refs['simpleRequestForm'].validate(callback);
      },
      ...mapActions({
        refresh: 'refresh'
      }),
      async getMinorCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      onSubmit() {
        this.$refs['simpleRequestForm'].validate((valid) => {
            if (valid) {

              this._onSubmit();
              return true;
            }

            return false;
          }
        );
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;
        console.log(this.slotData);

        const url = this.apis().createRequirementOrder();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('发布需求成功，订单编号： ' + result);
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
      }
    },
    computed: {},
    data() {
      let checkCategory = (rule, value, callback) => {
        console.log(value);
        if (value==null||value.code === ''||value === {}) {
          callback(new Error('请选择品类'));
        }
        callback();
      };
      let expectedDeliveryDate = (rule, value, callback) => {
        console.log(value);
        console.log("expectedDeliveryDate");
          if (this.compareDate(new Date(), new Date(value))) {
            callback(new Error('预计交货时间不能小于当前时间'));
        }
        callback();
      };
      let contactPhone = (rule, value, callback) => {
        if (!Number.isInteger(value)) {
          callback(new Error('请输入数字值'));
        }
        callback();
      };
      return {
        categories: [],
        rulesSimple: {
          category: [{required: true, message: '必填', trigger: 'blur'},{validator: checkCategory, trigger: 'change'}],
          expectedMachiningQuantity: [{required: true, message: '必填', trigger: 'blur'}],
          expectedDeliveryDate: [{required: true, message: '必填', trigger: 'blur'},{validator: expectedDeliveryDate, trigger: 'blur'}],
          contactPhone: [{required: true, message: '必填', trigger: 'blur'},{validator: contactPhone, trigger: 'blur'}],
          contactPerson: [{required: true, message: '必填', trigger: 'blur'}],
        },
      }
    },
    created() {
      this.getMinorCategories();
    }
  }
</script>
