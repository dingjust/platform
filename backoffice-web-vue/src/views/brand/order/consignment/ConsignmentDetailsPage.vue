<template>
  <div class="animated fadeIn">
    <consignment-status-bar :status="slotData.status" :status-map="statusMap" :statu-days-map="statuDaysMap"></consignment-status-bar>
    <!--<div v-show="isCuttingCompleted" class="pt-2"></div>
    <el-row v-show="isCuttingCompleted" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCuttingCompleted">
          裁剪确认
        </el-button>
      </el-col>
    </el-row>-->
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <consignment-base-form :slot-data="slotData" :read-only="true"></consignment-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>归属订单</span>
      </div>
      <order-base-form :slot-data="slotData.order" :read-only="true"></order-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>分配工厂</span>
      </div>
      <consignment-factory-base-form :slot-data="slotData.assignedTo"
                                     :read-only="true">
      </consignment-factory-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>生产单行</span>
      </div>
      <consignment-entries-form :slot-data="slotData" :read-only="true"></consignment-entries-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>生产进度</span>
        <!--<span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateEntries">编辑</el-button>
        </span>-->
      </div>
      <consignment-progress-form :slot-data="slotData"></consignment-progress-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <consignment-contracts-form ref="contractsForm"
                                  :slot-data="slotData"
                                  :read-only="true">
      </consignment-contracts-form>
    </el-card>
    <div v-show="isCuttingCompleted" class="pt-2"></div>
    <el-row v-show="isCuttingCompleted" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onCuttingCompleted">
          裁剪确认
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import axios from "axios";
  import OrderBaseForm from "../order/OrderBaseForm";
  import ConsignmentBaseForm from "./ConsignmentBaseForm";
  import ConsignmentEntriesForm from "./ConsignmentEntriesForm";
  import ConsignmentFactoryBaseForm from "./ConsignmentFactoryBaseForm";
  import ConsignmentStatusBar from "./ConsignmentStatusBar";
  import ConsignmentContractsForm from "./ConsignmentContractsForm";
  import ConsignmentProgressForm from "./ConsignmentProgressForm";

  export default {
    name: "ConsignmentDetailsPage",
    components: {
      ConsignmentStatusBar,
      OrderBaseForm,
      ConsignmentBaseForm,
      ConsignmentEntriesForm,
      ConsignmentFactoryBaseForm,
      ConsignmentContractsForm,
      ConsignmentProgressForm
    },
    props: ["slotData", "readOnly"],
    methods: {
      onCuttingCompleted() {
        // 裁剪完成后的确认动作
        this.$confirm('是否拒绝审核', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put('/djbrand/processes/consignment/cuttingConfirm/' + this.slotData.code)
            .then(response => {
              this.$message.success('裁剪确认成功');

              this.$set(this.slotData, "status", response.data);
            }).catch(error => {
              this.$message.error('裁剪确认失败，原因：' + error.response.data);
            }
          );
        }).catch(() => {
        });
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      },
      isCuttingCompleted: function () {
        return this.slotData.status === "COMPLETE_CUTTING";
      },
      statusMap:function () {
        let map = {};
        this.slotData.progresses.map(progress => {
          this.$set(map,progress.phase,progress.estimatedDate);
        });
        return map;
      },
      statuDaysMap:function () {
        let map = {};
        this.slotData.progresses.map(progress => {
          let days = 0;
          if(progress.estimatedDate != null){
            const estimated = progress.estimatedDate;
            let finish;
            if(progress.finishDate != null){
              finish = progress.finishDate;
            }else{
              finish = new Date().getTime();
            }
            days = parseInt((finish - estimated) / (1000 * 60 * 60 * 24));
          }
          this.$set(map,progress.phase,days);
        });
        return map;
      }
    },
    data() {
      return {}
    }
  }
</script>
