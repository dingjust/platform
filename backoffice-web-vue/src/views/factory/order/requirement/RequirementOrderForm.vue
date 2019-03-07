<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData"
                                      :read-only="readOnly">
      </requirement-order-request-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card" v-show="slotData.attachments.length">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <requirement-order-attachments-form :slot-data="slotData"
                                          :read-only="readOnly">
      </requirement-order-attachments-form>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('FactoryRequirementOrdersModule');

  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderAttachmentsForm from './RequirementOrderAttachmentsForm';
  import RequirementOrderDetailsPage from './RequirementOrderDetailsPage';

  import {OrderMixin} from '@/mixins';

  export default {
    name: 'RequirementOrderFrom',
    components: {
      RequirementOrderRequestForm,
      RequirementOrderAttachmentsForm,
      RequirementOrderDetailsPage
    },
    mixins: [OrderMixin],
    props: ['slotData', 'readOnly'],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
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
      return {}
    }
  }
</script>
