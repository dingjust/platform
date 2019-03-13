<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <el-form ref="requestForm"
               label-position="top"
               :model="slotData">
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="产品类别" prop="category">
              <el-select class="w-100"
                         placeholder="请选择"
                         v-model="slotData.details.category.code">
                <el-option-group
                  v-for="group in categories"
                  :key="group.code"
                  :label="group.name">
                  <el-option
                    v-for="item in group.children"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-option-group>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="加工数量" prop="expectedMachiningQuantity">
              <el-input-number class="w-100"
                               v-model="slotData.details.expectedMachiningQuantity">
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

  const {mapActions} = createNamespacedHelpers('BrandRequirementOrdersModule');

  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderAttachmentsForm from './RequirementOrderAttachmentsForm';
  import RequirementOrderDetailsPage from './RequirementOrderDetailsPage';

  // import {OrderMixin} from '@/mixins';

  export default {
    name: 'RequirementOrderSimpleFrom',
    components: {
      RequirementOrderRequestForm,
      RequirementOrderAttachmentsForm,
      RequirementOrderDetailsPage
    },
    // mixins: [OrderMixin],
    props: ['slotData'],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async getMinorCategories() {
        const result = await this.$http.get('/b2b/categories/cascaded');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      onSubmit() {
        this.$refs['requestForm'].validate((valid) => {
            if (!valid) {
              return false;
            }

            this._onSubmit();

            return true;
          }
        );
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;
        const result = await this.$http.post('/b2b/orders/requirement/new', formData);
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
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        categories: [],
      }
    },
    created() {
      this.getMinorCategories();
    }
  }
</script>
