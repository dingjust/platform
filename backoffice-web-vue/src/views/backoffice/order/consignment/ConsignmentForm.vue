<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>生产订单</span>
      </div>
      <consignment-base-form :slot-data="slotData"></consignment-base-form>
      <div class="pt-2"></div>
      <el-steps finish-status="success" align-center :active="active">
        <el-step title="选择订单"></el-step>
        <el-step title="选择工厂"></el-step>
        <el-step title="添加发货行"></el-step>
        <el-step title="合同上传"></el-step>
        <el-step title="完成"></el-step>
      </el-steps>
      <div class="pt-2"></div>
      <div v-show="active === 0">
        <consignment-order-search-form :slot-data="slotData"></consignment-order-search-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="24">
            <el-button class="btn-block" size="mini" @click="onSelectOrder">下一步</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 1">
        <consignment-factory-search-form :slot-data="slotData"></consignment-factory-search-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onStep(0)">上一步</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onSelectFactory()">下一步</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 2">
        <consignment-entries-form :slot-data="slotData" :read-only="true"></consignment-entries-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onStep(1)">上一步</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" type="primary" size="mini" @click="onAddEntries()">保存</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 3">
        <consignment-media-upload-form ref="mediaUploadForm"
                                       :slot-data="slotData"
                                       :read-only="false">
        </consignment-media-upload-form>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block bg-primary" size="mini" @click="onMediaUpload">上传</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onStep(4)">下一步</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 4">
        <consignment-details-page :slot-data="slotData" :read-only="true"></consignment-details-page>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onStep(3)">上一步</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" type="primary" size="mini" @click="onComplete">完成</el-button>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('ProductionOrdersModule');

  import ConsignmentOrderSearchForm from './ConsignmentOrderSearchForm';
  import ConsignmentFactorySearchForm from './ConsignmentFactorySearchForm';
  import ConsignmentBaseForm from './ConsignmentBaseForm';
  import ConsignmentEntriesForm from './ConsignmentEntriesForm';
  import ConsignmentMediaUploadForm from './ConsignmentMediaUploadForm';
  import ConsignmentDetailsPage from './ConsignmentDetailsPage';

  export default {
    name: 'ConsignmentForm',
    components: {
      ConsignmentBaseForm,
      ConsignmentFactorySearchForm,
      ConsignmentOrderSearchForm,
      ConsignmentEntriesForm,
      ConsignmentMediaUploadForm,
      ConsignmentDetailsPage
    },
    props: ['slotData', 'readOnly'],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onCancel() {
        this.fn.closeSlider();
      },
      onStep(active) {
        this.active = active;
      },
      onSelectOrder() {
        this.active = 1;
      },
      onSelectFactory() {
        this.active = 2;
      },
      async onAddEntries() {
        // TODO: validate and submit
        // console.log('all data: ' + JSON.stringify(this.slotData));
        let formData = {
          code: this.slotData.code,
          order: {
            code: this.slotData.order.code
          },
          assignedTo: this.slotData.assignedTo,
          consignmentEntries: this.slotData.consignmentEntries
        };

        const result = await this.$http.post('/djbackoffice/consignment/new', formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('生产订单创建成功，编号： ' + response.data);
        this.$set(this.slotData, 'code', response.data);
        this.refreshProgresses();
        this.active = 3;
      },
      onMediaUpload() {
        this.$refs['mediaUploadForm'].onSubmit();
      },
      onComplete() {
        this.fn.closeSlider(true);
      },
      async refreshProgresses() {
        const result = await this.$http.get('/djbackoffice/consignment/progresses', {
          code: this.slotData.code
        });
        if (result['errors']) {
          this.$message.error('更新需求信息失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$set(this.slotData, 'progresses', result);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        active: 0
      }
    }
  }
</script>
