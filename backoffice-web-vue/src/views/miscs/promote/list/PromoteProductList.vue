<template>
  <div>
    <el-row>
      <el-form ref="form" :inline="true">
        <el-form-item prop="firstTitle">
          <template slot="label">
            <h6 class="formLabel">选择对应商品:</h6>
          </template>
          <el-button style="background-color: #FFD60C" size="mini" @click="onProuductSelect">点击选择</el-button>
        </el-form-item>
        <el-form-item prop="secondTitle">
          <template slot="label">
            <h6 class="formLabel">产品</h6>
          </template>
          <el-input v-model="keyword" style="width: 200px" placeholder="请输入名称或款号" suffix-icon="el-icon-search"></el-input>
          <el-button style="background-color: #FFD60C" size="mini" @click="onListSearch">搜索</el-button>
        </el-form-item>
      </el-form>
      <div class="recommend-list-style">
        <el-table ref="resultTable" stripe :height="autoHeight" :data="formData">
          <el-table-column label="产品图片" min-width="100">
            <template slot-scope="scope">
              <el-row type="flex" align="middle" justify="start">
                <el-col>
                  <img width="54px" height="54px"
                       :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'">
                </el-col>
              </el-row>
            </template>
          </el-table-column>
          <el-table-column label="产品名" prop="product.name" min-width="120"></el-table-column>
          <el-table-column label="款号" prop="product.skuID" min-width="120"></el-table-column>
          <el-table-column label="品类" min-width="120">
            <template slot-scope="scope">
              <span>{{scope.row.product.category.name}}</span> </template>
          </el-table-column>
          <el-table-column v-if="isTenant()" label="供应商" prop="product.belongTo" min-width="250">
            <template slot-scope="scope">
              <el-button type="text" @click="onBelongDetail(scope.row.product)">
                {{scope.row.product.belongTo != undefined ? scope.row.product.belongTo.name:''}}
              </el-button>
            </template>
          </el-table-column>
          <el-table-column label="状态" prop="product.approvalStatus" min-width="100">
            <template slot-scope="scope">
              <span>{{getEnum('approvalStatuses', scope.row.product.approvalStatus)}}</span>
            </template>
          </el-table-column>
          <el-table-column label="序号" min-width="80">
            <template slot-scope="scope">
              <text-to-input :value="scope.row.sequence"
                             :input-type="'number'"
                             :show-input="showInput && scope.row.sequence == selectId"
                             @blur="moveNumber($event, scope.row)"
                             :max-number="20">
              </text-to-input>
            </template>
          </el-table-column>
<!--          <el-table-column label="序号" type="index">-->
<!--          </el-table-column>-->
          <el-table-column label="操作" min-width="150">
            <template slot-scope="scope">
              <el-row>
                <el-button type="text" @click="onDelete(scope.row)" class="purchase-list-button">删除</el-button>
                <el-divider direction="vertical"></el-divider>
                <el-button type="text" @click="onMove(scope.row, scope.$index)" class="purchase-list-button">移动</el-button>
<!--                <el-button type="text" @click="onMoveUp(scope.row, scope.$index)" class="purchase-list-button" v-if="scope.$index > 0">上移</el-button>-->
<!--                <el-divider direction="vertical" v-if="scope.$index > 0"></el-divider>-->
<!--                <el-button type="text" @click="onMoveDown(scope.row, scope.$index)" class="purchase-list-button" v-if="scope.$index < formData.length - 1">下移</el-button>-->
              </el-row>
            </template>
          </el-table-column>
        </el-table>
<!--        <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"-->
<!--                       @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="formData.number + 1"-->
<!--                       :page-size="formData.size" :page-count="formData.totalPages" :total="formData.totalElements">-->
<!--        </el-pagination>-->
      </div>
    </el-row>
    <el-dialog :visible.sync="factoryDetailsPageVisible" width="80%" class="purchase-dialog"
               :close-on-click-modal="false" append-to-body>
      <factory-details-read v-if="factoryDetailsPageVisible" :slotData="belongDetailsData"></factory-details-read>
    </el-dialog>
    <el-dialog :visible.sync="brandDetailsPageVisible" width="80%" class="purchase-dialog"
               :close-on-click-modal="false" append-to-body>
      <brand-details-read v-if="brandDetailsPageVisible" :slotData="belongDetailsData">
      </brand-details-read>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations
  } = createNamespacedHelpers('PromoteProductModule');

  import FactoryDetailsRead from '../../../user/company/factory/details/FactoryDetailsRead';
  import BrandDetailsRead from '../../../user/company/brand/details/BrandDetailsRead';
  import TextToInput from '../../../../components/custom/TextToInput';
  export default {
    name: 'PromoteProductList',
    components: {TextToInput, BrandDetailsRead, FactoryDetailsRead},
    props: ['formData'],
    computed: {
      ...mapGetters({
        promoteProductList: 'promoteProductList'
      })
    },
    methods: {
      ...mapMutations({
        setPromoteProductList: 'promoteProductList'
      }),
      onPageSizeChanged () {

      },
      onCurrentPageChanged () {

      },
      getIndex (row) {
        return this.promoteProductList.indexOf(row) + 1;
      },
      clickInput (value) {
        value = value.replace(/^(0+)|[^\d]+/g, '');
      },
      // onSearch () {
      //   const key = this.keyword;
      //   const originData = this.promoteProductList;
      //   if (this.keyword.replace(/\s*/g, '').length == 0) {
      //     this.formData = originData;
      //   } else {
      //     const searchData = originData.filter(function (item) {
      //       return item.name.search(key) > -1 || item.skuID.search(key) > -1;
      //     })
      //     this.formData = searchData;
      //   }
      // },
      onListSearch () {
        const keyword = this.keyword;
        this.$emit('onListSearch', keyword);
      },
      onDelete (row, index) {
        // let index;
        // for (let i = 0; i < this.formData.length; i++) {
        //   if (row.id == this.formData[i].id) {
        //     index = i;
        //   }
        // }
        // this.formData.splice(index, 1);
        // this.$store.state.PromoteProductModule.promoteProductList = this.formData;
        const keyword = this.keyword;
        this.$emit('onDelete', row, keyword);
      },
      onMoveUp (row, index) {
        console.log(this.formData);
        const item = this.formData.splice(index, 1);
        this.formData.splice(index - 1, 0, item[0]);
        this.$store.state.PromoteProductModule.promoteProductList = this.formData;
      },
      onMoveDown (row, index) {
        const item = this.formData.splice(index, 1);
        this.formData.splice(index + 1, 0, item[0]);
        this.$store.state.PromoteProductModule.promoteProductList = this.formData;
      },
      onProuductSelect () {
        this.$emit('onProuductSelect');
      },
      onMove (row) {
        this.selectId = row.sequence;
        this.showInput = true;
        this.moveButtonDisabled = true;
      },
      moveNumber (modifyIndex, row) {
        const index = row.sequence + 1;
        setTimeout(() => {
          this.$confirm('是否将 ' + row.product.name + ' 的序号从 ' + index + ' 移动到 ' + modifyIndex, '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this._moveNumber(index, modifyIndex);
          });
        }, 100);
        this.moveButtonDisabled = false;
        this.showInput = false;
      },
      //              4       1
      _moveNumber (index, modifyText) {
        const keyword = this.keyword;
        this.$emit('_moveNumber', index, modifyText, keyword);
        // const modifyT = modifyText - this.formData.length > 0 ? this.formData.length : modifyText;
        // const item = this.formData.splice(index - 1, 1);
        // this.formData.splice(modifyT - 1, 0, item[0]);
        // this.$store.state.PromoteProductModule.promoteProductList = this.formData;
        // this.$message.success('移动商品序号成功');
      },
      async onBelongDetail (item) {
        // 工厂
        if (item.belongTo.type == 'FACTORY') {
          let url = this.apis().getFactory(item.belongTo.uid);
          if (this.isTenant()) {
            url += '?sort=creationtime,desc';
          }
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.belongDetailsData = result;
          this.factoryDetailsPageVisible = true;
        } else if (item.belongTo.type == 'BRAND') {
          // 品牌
          let url = this.apis().getBrand(item.belongTo.uid);
          if (this.isTenant()) {
            url += '?sort=creationtime,desc';
          }
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          if (result.duties == null || result.duties == undefined) {
            result.duties = '经理';
          }
          this.belongDetailsData = result;
          this.brandDetailsPageVisible = true;
        } else {

        }
      }
    },
    data () {
      return {
        belongDetailsData: '',
        factoryDetailsPageVisible: false,
        brandDetailsPageVisible: false,
        showInput: false,
        selectId: '',
        moveButtonDisabled: false,
        keyword: '',
        searchData: this.promoteProductList
        // originData: [],
      }
    },
    created () {
    }
  }
</script>
<style scoped>
  .formLabel {
    font-size: 12px;display: inline-block;
  }
  .recommend-list-style {
    border: solid #DCDFE6 1px;
    border-radius: 5px;
    padding: 12px;
  }

  /*.el-input__inner {*/
  /*  width: 50px;*/
  /*  height: 20px;*/
  /*  line-height: 32px;*/
  /*  border-radius: 2px;*/
  /*  padding: 0px;*/
  /*}*/

</style>
