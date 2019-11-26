<template>
  <div>
    <el-dialog :visible.sync="updateFormVisible" width="70%" class="purchase-dialog" append-to-body>
      <order-progress-update-form :slotData="selectProgressModel" :order="slotData" @callback="onCallback"
        v-if="hackSet" @editSubmit="onEditSubmit" />
    </el-dialog>
    <el-row type="flex" justify="space-between">
      <template v-for="(item,index) in slotData.progresses">
        <el-col :span="5" :key="index" class="progress-block" @mouseenter.native="onShowButton(true,index)"
          @mouseleave.native="onShowButton(false,index)">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="progress-status">{{getEnum('productionProgressPhaseTypes', item.phase)}}</h6>
          </el-row>
          <el-row type="flex" justify="center" align="middle">
            <div :class="getLeftLine(index,slotData.progresses)" />
            <el-col :span="6">
              <div
                :class="item.sequence<=currentSequence?'progress-icon-container':isDoing(index,slotData.progresses)?'progress-icon-container_doing':'progress-icon-container_none'">
                <i class="iconfont2 progress-icon" v-html="phaseIcon[item.phase]"
                  v-if="!isDoing(index,slotData.progresses)"></i>
                <h6 v-if="isDoing(index,slotData.progresses)" class="progress-icon-container_text">进行</h6>
              </div>
            </el-col>
            <div :class="getRightLine(index,slotData.progresses)" />
          </el-row>
          <el-row type="flex" justify="center" align="middle">
            <div class="progress-line-horizon_none" />
            <div :class="item.sequence==currentSequence?'progress-line-vertical':'progress-line-vertical_none'">
            </div>
            <div class="progress-line-horizon_none" />
          </el-row>
          <!-- <el-row type="flex" justify="center" align="middle" v-if="item.medias!=null&&item.medias.length!=0">
            <img class="progress-img" :src="item.medias[0].url">
          </el-row> -->
          <el-row type="flex" justify="center" align="middle" class="progress-info-row" v-if="item.estimatedDate!=null">
            <el-col :span="19">
              <h6 class="progress-info">完成日期: {{item.estimatedDate | timestampToTime}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center" class="progress-info-row" align="middle" v-if="item.quantity!=null">
            <el-col :span="19">
              <h6 class="progress-info">完成数量: {{item.quantity}}</h6>
            </el-col>
          </el-row>
          <!-- <el-row type="flex" justify="center" class="progress-info-row" align="middle" v-if="item.remarks!=null">
            <el-col :span="19">
              <h6 class="progress-info">备注: {{item.remarks}}</h6>
            </el-col>
          </el-row> -->
          <el-row type="flex" style="margin-top:5px;" justify="center" align="middle"
            v-if="isDoing(index,slotData.progresses)&&slotData.status=='IN_PRODUCTION'&&isFactory()">
            <el-button size="mini" class="info-detail-logistics_info-btn1" @click="onProgressFinish(item,index)">
              {{getEnum('productionProgressPhaseTypes', item.phase)}}完成</el-button>
          </el-row>
          <div class="progress-block-modal" :style="getBlockStyle(index)" v-show="showButtonArray[index]">
            <el-row type="flex" justify="center" align="middle" class="progress-block-modal-row"
              v-if="item.sequence>=currentSequence&&slotData.status=='IN_PRODUCTION'&&isFactory()">
              <el-button type="primary" plain @click="onEdit(item)">编辑</el-button>
            </el-row>
          </div>
        </el-col>
      </template>
    </el-row>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";
  import Bus from '@/common/js/bus.js';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    "PurchaseOrdersModule"
  );

  import OrderProgressUpdateForm from './OrderProgressUpdateForm';

  export default {
    name: "PurchaseOrderProgress",
    props: ['slotData'],
    components: {
      OrderProgressUpdateForm
    },
    computed: {
      ...mapGetters({
        contentData: "detailData"
      }),
      currentSequence: function () {
        var result = 0;
        this.slotData.progresses.forEach(element => {
          if (element.phase == this.slotData.currentPhase) {
            result = element.sequence;
          }
        });
        return result;
      },
    },
    methods: {
      ...mapActions({
        refreshDetail: "refreshDetail",
      }),
      ///判断左边线样式
      getLeftLine(index, data) {
        if (index == 0) {
          return 'progress-line-horizon_none'
        } else {
          if (data[index].sequence <= this.currentSequence) {
            return 'progress-line-horizon';
          } else {
            return 'progress-line-horizon_grey';
          }
        }
      },
      ///判断右边线样式
      getRightLine(index, data) {
        if (index == data.length - 1) {
          return 'progress-line-horizon_none'
        } else {
          if (data[index].sequence <= this.currentSequence) {
            if (data[index].phase == this.slotData.currentPhase) {
              return 'progress-line-horizon_grey';
            } else {
              return 'progress-line-horizon';
            }
          } else {
            return 'progress-line-horizon_grey';
          }
        }
      },
      ///判断是否正在进行中
      isDoing(index, data) {
        if (this.slotData.status == 'IN_PRODUCTION') {
          return data[index].phase == this.slotData.currentPhase;
        } else {
          return false;
        }
      },
      onEdit(item) {
        this.selectProgressModel = item;
        this.selectProgressModel.updateOnly = true;
        this.updateFormVisible = !this.updateFormVisible;
      },
      async onEditSubmit() {
        if (this.compareDate(new Date(), new Date(this.selectProgressModel.estimatedDate))) {
          this.$message.error('预计完成时间不能小于当前时间');
          return false;
        }
        const url = this.apis().updateProgressOfPurchaseOrder(this.slotData.code, this.selectProgressModel.id);
        const result = await this.$http.put(url, this.selectProgressModel);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('更新成功');
        this.updateFormVisible = false;
      },
      async onProgressFinish(item, index) {
        item.updateOnly = false;
        const url = this.apis().updateProgressOfPurchaseOrder(this.slotData.code, item.id);
        const result = await this.$http.put(url, item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('更新成功');
        this.updateFormVisible = false;
        if (index != this.slotData.progresses.length - 1) {
          this.slotData.currentPhase = this.slotData.progresses[index + 1].phase;
        } else {
          this.slotData.status = 'WAIT_FOR_OUT_OF_STORE';
        }
      },
      onShowButton(value, index) {
        this.$set(this.showButtonArray, index, value);
      },
      getShowVal(index) {
        return this.showButtonArray[index];
      },
      getBlockStyle(index) {
        var width = 100 / this.slotData.progresses.length;
        return {
          'width': width + '%',
          'left': width * index + '%',
        }
      },
      async onCallback() {
        await this.refreshDetail();
        this.contentData.progresses.forEach(item => {
          if (item.id == this.selectProgressModel.id) {            
            this.selectProgressModel=item;            
          }
        });
      }
    },
    data() {
      return {
        updateFormVisible: false,
        hackSet: true,
        phaseIcon: {
          MATERIAL_PREPARATION: '&#xe675;',
          CUTTING: '&#xe677;',
          STITCHING: '&#xe67a;',
          AFTER_FINISHING: '&#xe67a;',
          INSPECTION: '&#xe689;',
        },
        selectProgressModel: '',
        showButtonArray: [],
      };
    },
    created() {
      this.showButtonArray = this.slotData.progresses.map((val) => false);
    }
  };

</script>
<style>
  .progress-status {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
    font-size: 12px;
  }

  .progress-vertical-line {
    height: 100px;
    width: 1px;
    background-color: aqua;
  }

  .progress-icon-container {
    background-color: #ffd60c;
    /* background-color: rgb(87, 84, 68); */
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }

  .progress-icon-container_doing {
    background-color: rgba(5, 0, 1, 0.45);
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }

  .progress-icon-container_text {
    font-size: 10px;
    color: #fff;
    line-height: 35px;
  }

  .progress-icon-container_none {
    background-color: #F2EFF0;
    /* background-color: rgb(87, 84, 68); */
    border-radius: 50%;
    width: 35px;
    height: 35px;
    text-align: center;
    line-height: 35px;
  }


  .progress-icon {
    font-size: 24px;
  }

  .progress-line-horizon {
    width: 100%;
    height: 2px;
    border-top: 2px dashed #FFD60C;
  }

  .progress-line-horizon_none {
    width: 100%;
    height: 2px;
    /* border-top: 1px dashed #FFD60C; */
  }

  .progress-line-horizon_grey {
    width: 100%;
    height: 2px;
    border-top: 2px dashed #F2EFF0;
  }

  .progress-line-vertical {
    width: 1px;
    height: 50px;
    border-left: 0.5px solid #FFD60C;
    margin-left: 3px;
    /* margin-left:  */
  }

  .progress-line-vertical_none {
    width: 1px;
    height: 50px;
    border-left: 0.5px solid #F2EFF0;
    margin-left: 3px;
    /* margin-left:  */
  }

  .progress-img {
    width: 90px;
    height: 50px;
    border-radius: 5px;
  }

  .progress-info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 10px;
  }

  .progress-row {
    margin-top: 2px;
  }

  .progress-info-row {
    text-align: center;
  }

  .progress-block {
    padding-top: 10px;
    padding-bottom: 10px;
  }


  .progress-block-modal {
    position: absolute;
    background-color: rgba(255, 214, 12, 0.35);
    /* width: 100%; */
    height: 100%;
    /* left: 0px; */
    top: 0px;
    z-index: 2;
  }

  .progress-block-modal-row {
    height: 100%;
    width: 100%;
  }

</style>
