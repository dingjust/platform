<template>
  <div class="animated fadeIn">
    <el-dialog :visible.sync="dialogSealVisible" class="purchase-dialog" :show-close="true"
      :close-on-click-modal="false">
      <contract-seal-list :page="sealPage" :onSearchSeal="onSearchSeal" @onSealSelectChange="onSealSelectChange" />
    </el-dialog>

    <el-dialog :visible.sync="dialogOrderVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <contract-supplement-form v-if="dialogOrderVisible" @openPreviewPdf="previewPdf" :slotData="thisContract"
        @onSearch="onSearch" @closeDialogOrderVisible="closeDialogOrderVisible" />
    </el-dialog>
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :height="autoHeight">
      <el-table-column label="合同名称" fixed>
        <template slot-scope="scope">
          <span class="ellipsis-name" :title="scope.row.title">
            {{scope.row.title}}
            <!--<el-link @click="dialogTableVisible = true">{{scope.row.title}}</el-link>-->
          </span>
        </template>
      </el-table-column>
      <el-table-column label="合同编号" prop="customizeCode"></el-table-column>
      <el-table-column label="合作商" prop="belongTo.name">
        <template slot-scope="scope">
          <span>{{scope.row.partner}}</span>
        </template>
      </el-table-column>
      <el-table-column label="对应单号" prop="orderCode">
        <template slot-scope="scope">
          <div v-if="isShowMore(scope.row.orderCodes) && isMore">
            <template v-for="(code,index) in scope.row.orderCodes">
              <el-row v-if="index < 5" :key="index">
                <span>{{code}}</span>
              </el-row>
            </template>
            <h6 style="color: #4a86e8;font-size: 10px" v-if="isShowMore(scope.row.orderCodes) && isMore"
              @click="turnIsMore()">显示更多>></h6>
          </div>
          <div v-else>
            <template v-for="(code,index) in scope.row.orderCodes">
              <el-row :key="index">
                <span>{{code}}</span>
              </el-row>
            </template>
            <h6 style="color: #4a86e8;font-size: 10px" v-if="isShowMore(scope.row.orderCodes) && !isMore"
              @click="turnIsMore()">点击拉起>></h6>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="合同类型">
        <template slot-scope="scope">
          <span>{{getEnum('TemplateType', scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="当前状态" prop="state" :column-key="'state'">
        <template slot-scope="scope">
          <!-- <el-tag disable-transitions></el-tag> -->
          {{getEnum('contractStates', scope.row.state)}}
        </template>
      </el-table-column>
      <!-- <el-table-column label="创建时间" prop="expectedDeliveryDate">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="操作" min-width="180px">
        <template slot-scope="scope">
          <el-button type="text" @click="previewPdf(scope.row,'')">查看</el-button>
          <!-- <el-button type="text" @click="onDownload(scope.row.code)">下载</el-button> -->
          <!--<el-button v-if="scope.row.state != 'COMPLETE' && scope.row.state != 'INVALID'" type="text"  @click="onRefuse(scope.row.code)">拒签</el-button>-->
          <!--<el-button v-if="scope.row.state != 'COMPLETE' && scope.row.state != 'INVALID'" type="text"  @click="onSearchSeal(scope.row)">签署</el-button>-->
          <!--<el-button v-if="scope.row.state != 'COMPLETE' && scope.row.state != 'INVALID'" type="text" @click="onRevoke(scope.row.code)">撤回</el-button>-->
          <Authorized :permission="['AGREEMENT_CREATE']">
            <el-button type="text" v-if="scope.row.state === 'COMPLETE' && scope.row.type !== 'BCXY' && scope.row.type !== 'ZFXY'" 
                        @click="onBCXY(scope.row)">增加补充协议</el-button>
          </Authorized>
          <Authorized :permission="['AGREEMENT_REMOVE']">
            <el-button type="text" v-if="scope.row.isOffline == true" @click="onDelete(scope.row)">删除</el-button>
          </Authorized>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  import http from '@/common/js/http';
  import {
    createNamespacedHelpers
  } from 'vuex';
  import ContractSealList from '../components/ContractSealList';
  import ContractPreviewPdf from '../components/ContractPreviewPdf'
  import Bus from '@/common/js/bus.js';
  import ContractSupplementForm from '../ContractSupplementForm'

  const {
    mapActions
  } = createNamespacedHelpers('ContractModule');
  const {
    mapGettersSeal,
    mapActionsSeal
  } = createNamespacedHelpers('ContractSealModule');

  import ContractDetails from '../components/ContractDetails';

  export default {
    name: 'ContractSearchResultList',
    props: ['page'],
    components: {
      ContractPreviewPdf,
      ContractDetails,
      ContractSealList,
      ContractSupplementForm
    },
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.ContractModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', 0, val);
          return;
        }

        this.$emit('onSearch', 0, val);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        })
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.ContractModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1, 10);
          return;
        }

        this.$emit('onSearch', val - 1, 10);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        })
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      async onDownload(code) {
        const url = this.apis().downContract(code);
        const result = await http.get(url);

        window.location.href = '/b2b/user/agreement/download/' + result.data;
        // window.location.href = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;

        // window.location.href = 'https://ht.nbyjy.net/b2b/user/agreement/download/' + result.data;
      },
      onConfirm() {
        this.$confirm('是否确认接单?', '接单', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          console.log('ffff');
        });
      },
      async onRefuse(code) {
        const url = this.apis().refuseContract(code);
        const result = await this.$http.get(url);
        this.$message.error(result.msg);
      },
      async onRevoke(code) {
        const url = this.apis().revokeContract(code);
        const result = await this.$http.get(url);
        this.$message.error(result.msg);
      },
      async onSearchSeal(vel, keyword, page, size) {
        if (vel != null) {
          this.contractCode = vel.code;
        }

        if (keyword == null) {
          keyword = '';
        }
        const url = this.apis().getSealsList();
        const result = await this.$http.post(url, {
          keyword: keyword
        }, {
          page: page,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.sealPage = result;
        this.dialogSealVisible = true
      },
      async onSealSelectChange(data) {
        console.log(data);
        this.dialogSealVisible = false;
        const sealCode = data.code;

        const url = this.apis().flowContract(this.thisContract.code, sealCode);
        const result = await http.get(url);

        if (result.data != null) {
          this.$confirm('是否打开页面?', '', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            window.open(result.data, '_blank');
          });

        } else {
          this.$message.success(result.msg);
        }
      },
      closePdfVisible() {
        this.$emit('closePdfVisible');
      },
      async previewPdf(val, code) {
        this.$emit('previewPdf', val, code);
        // this.thisContract = val;
        // console.log(this.thisContract);
        // let queryCode = '';
        // if (code != null && code != '') {
        //   queryCode = code;
        // } else {
        //   queryCode = val.code;
        // }
        // const url = this.apis().downContract(queryCode);
        // const result = await http.get(url);
        //
        // const aa = '/b2b/user/agreement/download/' + result.data;
        //
        // // const aa = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;
        // //
        // // const aa = 'https://ht.nbyjy.net/b2b/user/agreement/download/' + result.data;
        // // window.open('/static/pdf/web/viewer.html?file=' + encodeURIComponent(aa))
        // this.pdfVisible = true;
        // this.fileUrl = encodeURIComponent(aa)
      },
      onBCXY(val) {
        this.thisContract = val;
        this.dialogOrderVisible = true;
      },
      onDelete(val) {
        this.$confirm('此操作将永久删除该合同, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.DeleteContract(val.code);
        })
      },
      async DeleteContract(code) {
        const url = this.apis().deleteContract(code);
        const result = await http.get(url);
        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
        }
        this.$emit('onSearch');
      },
      isShowMore(codes) {
        if (codes.length > 5) {
          return true;
        } else {
          return false;
        }
      },
      turnIsMore() {
        this.isMore = !this.isMore;
      },
      onSearch() {
        this.$emit('onSearch');
      },
      closeDialogOrderVisible() {
        this.dialogOrderVisible = false;
      }
    },
    data() {
      return {
        statuses: this.$store.state.ContractModule.statuses,
        dialogTableVisible: false,
        sealPage: [],
        dialogSealVisible: false,
        contractCode: '',
        pdfVisible: false,
        currentUser: this.$store.getters.currentUser,
        fileUrl: '',
        thisContract: '',
        dialogOrderVisible: false,
        isMore: true
      }
    },
    created() {
      Bus.$on('openSeal', args => {
        this.onSearchSeal();
        this.closePdfVisible();
        this.dialogSealVisible = true;
      });
      Bus.$on('openList', args => {
        // this.dialogSealVisible = true;
      });
      Bus.$on('closePdfView', args => {
        this.closePdfVisible();
      });
      Bus.$on('closeBCXYFrom', args => {
        this.dialogOrderVisible = false;
      });
      Bus.$on('openContract1', args => {
        this.dialogOrderVisible = false;
        this.closePdfVisible();
        this.previewPdf('', args);
      });
      Bus.$on('closeSeal', args => {
        this.dialogSealVisible = false;
      });
    }
  }

</script>
<style>
  .el-table th {
    background-color: #FAFBFC;
  }

  .el-dialog {
    width: 80%;
  }

  /*.el-dialog__body {*/
  /*padding-left: 20px;*/
  /*padding-right: 0px;*/
  /*padding-bottom: 30px;*/
  /*padding-top: 0px;*/
  /*color: #606266;*/
  /*font-size: 14px;*/
  /*word-break: break-all;*/
  /*}*/
  .ellipsis-name {
    width: 50px;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

</style>
