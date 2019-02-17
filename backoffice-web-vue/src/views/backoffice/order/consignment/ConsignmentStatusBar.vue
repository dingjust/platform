<template>
  <div class="animated fadeIn">
    <el-steps align-center
              finish-status="success"
              :active="active">
      <el-step title="待分配"></el-step>
      <el-step>
        <template slot="title">
          备料中<br/>
          {{statusMap.MATERIAL_PREPARATION | timestampToTime(statusMap.MATERIAL_PREPARATION)}}
          <div v-show="showMaterial(statuDaysMap)">
            <span style="color:red">已延期 {{statuDaysMap.MATERIAL_PREPARATION}}天</span>
          </div>
        </template>
      </el-step>
      <el-step title="待裁剪"></el-step>
      <el-step>
        <template slot="title">
          裁剪中<br/>
          {{statusMap.CUTTING | timestampToTime(statusMap.CUTTING)}}
          <div v-show="showCutting(statuDaysMap)">
            <span style="color:red">已延期 {{statuDaysMap.CUTTING}}天</span>
          </div>
        </template>
      </el-step>
      <el-step>
        <template slot="title">
          车缝中<br/>
          {{statusMap.STITCHING | timestampToTime(statusMap.STITCHING)}}
          <div v-show="showStitching(statuDaysMap)">
            <span style="color:red">已延期 {{statuDaysMap.STITCHING}}天</span>
          </div>
        </template>
      </el-step>
      <el-step>
        <template slot="title">
          待验货<br/>
          {{statusMap.INSPECTION | timestampToTime(statusMap.INSPECTION)}}
          <div v-show="showInspection(statuDaysMap)">
            <span style="color:red">已延期 {{statuDaysMap.INSPECTION}}天</span>
          </div>
        </template>
      </el-step>
      <el-step>
        <template slot="title">
          待发货<br/>
          {{statusMap.DELIVERY | timestampToTime(statusMap.DELIVERY)}}
          <div v-show="showDelivery(statuDaysMap)">
            <span style="color:red"> 已延期{{statuDaysMap.DELIVERY}}天</span>
          </div>
        </template>
      </el-step>
      <el-step title="已发货"></el-step>
      <el-step title="已完成"></el-step>
    </el-steps>
  </div>
</template>

<script>
  import {ConsignmentMixin} from 'mixins';

  export default {
    name: 'ConsignmentStatusBar',
    props: ['status', 'statusMap','statuDaysMap'],
    mixins: [ConsignmentMixin],
    methods: {
      showMaterial(statuDays){
        let flat = false;
        if(statuDays.MATERIAL_PREPARATION > 0){
          if(this.status === 'WAIT_FOR_PURCHASE' || this.status === 'PENDING_CUTTING'){
            flat = true;
          }else if(this.status === 'CUTTING' && statuDays.CUTTING <= 0){
            flat = true;
          }
        }
        return flat;
      },
      showCutting(statuDays){
        let flat = false;
        console.log(statuDays);
        if(statuDays.CUTTING > 0){
          if(this.status === 'CUTTING'){
            flat = true;
          }else if(this.status === 'STITCHING' && statuDays.STITCHING <= 0){
            flat = true;
          }
        }
        return flat;
      },
      showStitching(statuDays){
        let flat = false;
        if(statuDays.STITCHING > 0){
          if(this.status === 'STITCHING'){
            flat = true;
          }else if(this.status === 'QC' && statuDays.INSPECTION <= 0){
            flat = true;
          }
        }
        return flat;
      },
      showInspection(statuDays){
        let flat = false;
        if(statuDays.INSPECTION > 0){
          if(this.status === 'QC'){
            flat = true;
          }else if(this.status === 'PENDING_DELIVERY' && statuDays.DELIVERY <= 0){
            flat = true;
          }
        }
        return flat;
      },
      showDelivery(statuDays){
        let flat = false;
        if(statuDays.DELIVERY > 0){
          if(this.status === 'PENDING_DELIVERY'){
            flat = true;
          }
        }
        return flat;
      },
    },
    computed: {
      active: function () {
        return this.consignmentStatusProcessFlow[this.status];
      }
    },
    data(){
      return{}
    }
  }
</script>
