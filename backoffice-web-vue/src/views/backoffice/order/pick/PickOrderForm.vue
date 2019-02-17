<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>发料单</span>
      </div>
      <div class="pt-2"></div>
      <el-steps finish-status="success" align-center :active="active">
        <el-step title="基本信息"></el-step>
        <el-step title="发料单行"></el-step>
        <el-step title="完成"></el-step>
      </el-steps>
      <div class="pt-2"></div>
      <div v-show="active === 0">
        <pick-order-base-form ref="baseForm" :slot-data="slotData" :read-only="false"/>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="24">
            <el-button class="btn-block" size="mini" @click="onAddEntries()">下一步</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 1">
        <pick-order-entries-form ref="entriesForm" :slot-data="slotData" :read-only="false"/>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onStep(0)">上一步</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onDetails()">下一步</el-button>
          </el-col>
        </el-row>
      </div>
      <div v-show="active === 2">
        <pick-order-details-page ref="detailsPage" :slot-data="slotData" :read-only="true"/>
        <div class="pt-2"></div>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-button class="btn-block" size="mini" @click="onStep(1)">上一步</el-button>
          </el-col>
          <el-col :span="12">
            <el-button class="btn-block" type="primary" size="mini" @click="onComplete()">完成</el-button>
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('PickOrdersModule');

  import PickOrderBaseForm from './PickOrderBaseForm';
  import PickOrderEntriesForm from "./PickOrderEntriesForm";
  import PickOrderDetailsPage from "./PickOrderDetailsPage";

  export default {
    name: 'PickOrderForm',
    components: {PickOrderBaseForm, PickOrderEntriesForm, PickOrderDetailsPage},
    props: ['slotData'],
    methods: {
      ...mapActions({
        refresh: "refresh"
      }),
      onCancel() {
        this.fn.closeSlider();
      },
      onStep(active) {
        this.active = active;
      },
      onAddEntries() {
        if (!this.$refs['baseForm'].validate()) {
          return;
        }
        this.active = 1;
      },
      onDetails() {
        if (!this.$refs['entriesForm'].validate()) {
          return;
        }
        this.active = 2;
      },
      onComplete() {
        if (!this.$refs['entriesForm'].validate()) {
          return;
        }

        this._onComplete();
      },
      async _onComplete() {
        const result = await this.$http.post('/djbackoffice/pickOrder', this.slotData);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success("发料单创建成功，编号： " + result);
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
        active: 0
      }
    }
  }
</script>
