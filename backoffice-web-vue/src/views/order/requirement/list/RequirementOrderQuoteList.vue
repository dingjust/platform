<template>
  <div class="animated fadeIn">
    <el-row type="flex" v-for="item of page.content" align="middle" style="margin-top: 10px">
      <el-col :span="18">
        <el-row type="flex">
          <el-col :span="3">
            <h6 style="color: #c8c8c8">{{item.creationtime | timestampToTime}}</h6>
          </el-col>
          <el-col :span="21" >
            <h6 style="font-weight: bold;">{{item.belongTo.name}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" align="middle">
          <el-col :span="2" style="margin-right: 26px"></el-col>
          <el-col :span="3">
            <h6 style="margin-right:20px">订单报价</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="color:red;font-weight: bold;">￥{{item.unitPrice ? item.unitPrice : '--'}}</h6>
          </el-col>
          <el-col :span="4">
            <h6 v-if="!isShowDetailPrice">
              <i style="color: #c8c8c8;font-size: 12px;cursor: pointer"
                 class="iconfont icon_arrow"
                 @click="handleChanged">
                查看详细报价&#xe714;&nbsp;
              </i>
            </h6>
            <h6 v-if="isShowDetailPrice">
              <i style="color: #c8c8c8;font-size: 12px;cursor: pointer"
                 class="iconfont icon_arrow"
                 @click="handleChanged">
                收起详细报价&#xe713;&nbsp;
              </i>
            </h6>
          </el-col>
          <el-col :span="3"></el-col>
          <el-col :span="3">
            <h6 style="margin-right: 20px">交货时间</h6>
          </el-col>
          <el-col :span="4">
            <h6 style="color:red;font-weight: bold;">{{item.expectedDeliveryDate | timestampToTime}}</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="margin-right: 20px">打样费</h6>
          </el-col>
          <el-col :span="2">
            <h6 style="color:red;font-weight: bold;">￥{{item.costOfSamples ? item.costOfSamples : '--'}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" align="middle" v-if="isShowDetailPrice">
          <el-col :span="2"></el-col>
          ​​​​​​​<div class="one">
          <el-col :span="3">
            <h6 style="margin-right:20px">面料价格</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="color:red;font-weight: bold;">￥{{item.unitPriceOfFabric ? item.unitPriceOfFabric : '--'}}</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="margin-right:20px">辅料价格</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="color:red;font-weight: bold;">￥{{item.unitPriceOfExcipients ? item.unitPriceOfExcipients : '--'}}</h6>
          </el-col>
          <el-col :span="2"></el-col>
          <el-col :span="3">
            <h6 style="margin-right: 20px">加工价格</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="color:red;font-weight: bold">￥{{item.unitPriceOfProcessing ? item.unitPriceOfProcessing : '--'}}</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="margin-right: 20px">其他价格</h6>
          </el-col>
          <el-col :span="3">
            <h6 style="color:red;font-weight: bold">￥{{item.costOfOther ? item.costOfOther : '--'}}</h6>
          </el-col>
            <div class="one0">
            </div>
        </div>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" justify="space-around" v-if="item.state == 'SELLER_SUBMITTED'">
            <el-button class="btn-class" @click="onApprove(item)">确认工厂</el-button>
            <el-button class="btn-class-1" @click="writeReason(item)">拒绝工厂</el-button>
        </el-row>
        <el-row type="flex" justify="space-around" v-if="item.state == 'BUYER_REJECTED'">
          <el-tag style="padding: 10px 20px;line-height: 3px;background-color: #c8c8c8;color: white">已拒绝</el-tag>
        </el-row>
        <el-row type="flex" justify="space-around" v-if="item.state == 'BUYER_APPROVED'">
          <el-tag style="padding: 10px 20px;line-height: 3px;background-color: green;color: white">已通过</el-tag>
        </el-row>
      </el-col>
    </el-row>
    <el-row v-if="page.content.length <= 0" type="flex" justify="center" style="margin-top: 20px">
      <h6>暂无报价</h6>
    </el-row>

    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-sizes="[8, 10, 20]"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>

    <el-dialog  :visible.sync="reasonDialogVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <el-row type="flex" justify="center">
        <h6 style="font-size: 18px;font-weight: bold">填写拒绝原因</h6>
      </el-row>
      <el-row>
        <el-input type="textarea" :autosize="{minRows:4,maxRows: 8}" v-model="comment">

        </el-input>
      </el-row>
      <el-row type="flex" justify="center">
        <el-button class="btn-class" style="width: 150px;margin-top: 20px" @click="onReject(code)">确认</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters, mapActions, mapMutations
  } = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'RequirementOrderQuoteList',
    props: ['page'],
    components: {},
    computed: {
      ...mapGetters({
        isShowDetailPrice: 'isShowDetailPrice'
      })
    },
    methods: {
      ...mapMutations({
        setOrdersPageNumber: 'setOrdersPageNumber',
        setOrdersPageSize: 'setOrdersPageSize',
        setIsShowDetailPrice: 'isShowDetailPrice'
      }),
      ...mapActions({
        searchQuotesAdvanced: 'searchQuotesAdvanced'
      }),
      onPageSizeChanged (val) {
        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch', val - 1);
      },
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      onDelete (row) {
        this.$emit('onDelete', row);
      },
      handleChanged(){
        this.setIsShowDetailPrice(!this.isShowDetailPrice);
      },
      async onApprove(item){
        this.$confirm('是否确认报价', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async () => {
          const url = this.apis().approveQuote(item.code);
          const result = await this.$http.put(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('确认报价成功');
          this.$emit('onRefresh', 'approve');
        });
      },
      writeReason (item) {
        this.code = item.code;
        this.reasonDialogVisible = !this.reasonDialogVisible;
      },
      async onReject(code) {
        this.$confirm('是否拒绝报价', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async () => {
          const url = this.apis().rejectQuote(code);
          const result = await this.$http.put(url, {
            reason: this.comment
          });
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('拒绝报价成功');
          this.$emit('onRefresh', 'reject');
          this.reasonDialogVisible = false;
        });
      }
    },
    data () {
      return {
        reasonDialogVisible: false,
        comment: '',
        code: '',
      }
    }
  }
</script>
<style scoped>
  .one{
    width: 100%;
    /*相对位置*/
    position: relative;
    border:1px solid #FFD60C;
    padding: 10px 0px 0px 10px;
  }
  .one0{
    width: 0;
    height: 0;
    border: 10px solid #ffd60c;
    border-top: none;
    border-right-color: transparent;
    border-left-color: transparent;
    position: absolute;
    top: -10px;
    left: 112px;
  }
  .btnClass1{
    width: 100px;background-color: red;color: white;
  }

  .btnClass{
    width: 100px;
    background-color: #FFD60C;
    color: black;
  }
</style>
