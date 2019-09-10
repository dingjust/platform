<template>
  <div class="animated fadeIn">
    <el-dialog :visible.sync="dialogSealVisible" :show-close="false">
      <contract-seal-list :page="sealPage" :onSearchSeal="onSearchSeal" @onSealSelectChange="onSealSelectChange" />
    </el-dialog>

    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :height="autoHeight">
      <el-table-column label="合同名称" fixed>
        <template slot-scope="scope">
          <span>
            {{scope.row.title}}
            <!--<el-link @click="dialogTableVisible = true">{{scope.row.title}}</el-link>-->
          </span>
        </template>
      </el-table-column>
      <el-table-column label="合同编号" prop="code"></el-table-column>
      <el-table-column label="签署对象" prop="belongTo.name">
        <template slot-scope="scope">
          <span>{{scope.row.partner}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="当前状态" prop="state" :column-key="'state'" :filters="statuses">
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
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">查看</el-button>
          <el-button type="text"  icon="el-icon-edit" @click="onDownload(scope.row.code)">下载</el-button>
          <!--<a javascript="this.apis().downContract(code)">111</a>-->
          <el-button v-if="scope.row.state == 'SIGN' || scope.row.state == 'PARTY_A_SIGN' || scope.row.state == 'PARTY_B_SIGN'" type="text" icon="el-icon-edit" @click="onRefuse(scope.row.code)">拒签</el-button>
          <el-button v-if="scope.row.state == 'SIGN' || scope.row.state == 'PARTY_A_SIGN' || scope.row.state == 'PARTY_B_SIGN'" type="text" icon="el-icon-edit" @click="onSearchSeal(scope.row)">签署</el-button>
          <!-- <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">撤回</el-button> -->
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
  import ContractSealList from "../components/ContractSealList";

  const {
    mapActions
  } = createNamespacedHelpers('ContractModule');
  const {mapGettersSeal, mapActionsSeal} = createNamespacedHelpers('ContractSealModule');

  import ContractDetails from "../components/ContractDetails";

  export default {
    name: 'ContractSearchResultList',
    props: ["page"],
    components: {
      ContractDetails,
      ContractSealList
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
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.ContractModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      async onDownload(code){
        const url = this.apis().downContract(code);
        const result = await http.get(url);
        console.log(result);

        window.location.href = 'http://localhost:8081/b2b/user/agreement/download/' + result.data;

      },
      async onRefuse(code){
        const url = this.apis().refuseContract(code);
        const result = await this.$http.get(url);

        this.$message.error(result.msg);
      },
      async onSearchSeal(vel,keyword,page, size) {
        this.contractCode = vel.code;
        if(keyword == null){
          keyword = '';
        }
        const url = this.apis().getSealsList();
        console.log(url)
        const result = await this.$http.post(url,{
          keyword: keyword
        }, {
          page: page,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.sealPage = result;
        this.dialogSealVisible=true
      },
      async onSealSelectChange(data) {
        this.dialogSealVisible = false;
        const sealCode = data.code;

        const url = this.apis().flowContract(this.contractCode,sealCode);
        const result = await http.get(url);

        if(result.data !=  null){
          window.open(result.data, '_blank');
        }else{
          this.$message.success(result.msg);
        }
      },

    },
    data() {
      return {
        statuses: this.$store.state.ContractModule.statuses,
        dialogTableVisible: false,
        sealPage:[],
        dialogSealVisible:false,
        contractCode:'',
      }
    },
    created(){
    }
  }

</script>
<style>
  .el-table th {
    background-color: #FAFBFC;
  }

  .el-dialog__body {
    padding-left: 20px;
    padding-right: 0px;
    padding-bottom: 30px;
    padding-top: 0px;
    color: #606266;
    font-size: 14px;
    word-break: break-all;
  }

</style>
