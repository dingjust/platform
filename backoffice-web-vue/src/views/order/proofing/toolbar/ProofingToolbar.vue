<template>
  <div class="proofing-toolbar">
    <el-form :inline="true" size="mini">
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">订单信息</h6>
        </template>
        <el-input style="width: 200px" placeholder="输入订单号、产品号或货号" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">跟单员</h6>
        </template>
        <el-input v-if="isBrand()" style="width: 200px" placeholder="输入跟单员姓名" v-model="queryFormData.brandOperatorName"></el-input>
        <el-input v-if="isFactory()" style="width: 200px" placeholder="输入跟单员姓名" v-model="queryFormData.factoryOperatorName"></el-input>
<!--        <el-input v-if="isTenant()" style="width: 200px" placeholder="输入跟单员姓名" v-popover:queryOperatorNamePopover-->
<!--                  v-model="operatorName" @blur="bindingOperatorName()">-->
<!--          <template slot="append">{{queryOperatorNameType ? '工厂' : '品牌'}}</template>-->
<!--        </el-input>-->
        <el-input v-if="isTenant()" placeholder="输入跟单员姓名" v-model="operatorName" @blur="bindingOperatorName()" style="width: 200px;">
          <el-select v-model="queryOperatorNameType" slot="prepend"
                     placeholder="请选择" style="width: 70px;" @change="queryOperatorNameSelect">
            <el-option label="工厂" value="1"></el-option>
            <el-option label="品牌" value="2"></el-option>
          </el-select>
        </el-input>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">分类</h6>
        </template>
        <el-cascader
          style="width: 115px"
          v-model="queryFormData.categories"
          placeholder="点击选择"
          clearable
          :options="categories"
          :props="{ expandTrigger: 'hover' ,value:'code',label:'name'}"
          :show-all-levels="false">

        </el-cascader>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">合作商</h6>
        </template>
        <el-input v-if="isFactory()" style="width: 200px" placeholder="输入合作商名称" v-model="queryFormData.brandReferenceName"></el-input>
        <el-input v-if="isBrand()" style="width: 200px" placeholder="输入合作商名称" v-model="queryFormData.factoryReferenceName"></el-input>
<!--        <el-input v-if="isTenant()" style="width: 200px" placeholder="输入合作商名称" v-popover:queryCompanyPopover-->
<!--                  v-model="referenceName" @blur="bindingReferenceName()">-->
<!--          <template slot="append">{{queryCompanyType ? '工厂' : '品牌'}}</template>-->
<!--        </el-input>-->
        <el-input v-if="isTenant()" placeholder="输入合作商名称" v-model="referenceName" @blur="bindingReferenceName()" style="width: 200px;">
          <el-select v-model="queryCompanyType" slot="prepend"
                     placeholder="请选择" style="width: 70px;" @change="queryCompanySelect">
            <el-option label="工厂" value="1"></el-option>
            <el-option label="品牌" value="2"></el-option>
          </el-select>
        </el-input>
      </el-form-item>
      <el-button-group>
        <el-button style="background-color: #FFD60C" @click="onAdvancedSearch">搜索</el-button>
        <el-button @click="onReset">重置</el-button>
      </el-button-group>
    </el-form>
    <el-popover ref="queryOperatorNamePopover" placement="top-end" width="60" v-model="popoverOperatorNameVisible">
      <div style="text-align: center; margin: 0">
        <el-button size="mini" type="text" @click="queryOperatorNameSelect(true)">工厂</el-button>
        <el-button type="text" size="mini" @click="queryOperatorNameSelect(false)">品牌</el-button>
      </div>
    </el-popover>
    <el-popover ref="queryCompanyPopover" placement="top-end" width="60" v-model="popoverCompanyVisible">
      <div style="text-align: center; margin: 0">
        <el-button size="mini" type="text" @click="queryCompanySelect(true)">工厂</el-button>
        <el-button type="text" size="mini" @click="queryCompanySelect(false)">品牌</el-button>
      </div>
    </el-popover>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('ProofingsModule');

  export default {
    name: 'ProofingToolbar',
    props: [],
    mixins: [],
    components: {},
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData',
        categories: 'categories'
      })
    },
    methods: {
      ...mapMutations({
        setQueryFormData: 'queryFormData'
      }),
      ...mapActions({
        clearQueryFormData: 'clearQueryFormData'
      }),
      onSearch () {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch () {
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onReset () {
        this.referenceName = '';
        this.operatorName = '';
        this.$emit('clearQueryFormData');
      },
      queryOperatorNameSelect (val) {
        this.queryOperatorNameType = val;
        this.popoverOperatorNameVisible = false;
        this.bindingOperatorName();
      },
      bindingOperatorName () {
        if (this.queryOperatorNameType === '1') {
          this.queryFormData.brandOperatorName = '';
          this.queryFormData.factoryOperatorName = this.operatorName;
        } else {
          this.queryFormData.factoryOperatorName = '';
          this.queryFormData.brandOperatorName = this.operatorName;
        }
      },
      queryCompanySelect (flag) {
        this.queryCompanyType = flag;
        this.popoverCompanyVisible = false;
        this.bindingReferenceName();
      },
      bindingReferenceName () {
        if (this.queryCompanyType === '1') {
          this.queryFormData.brandReferenceName = '';
          this.queryFormData.factoryReferenceName = this.referenceName;
        } else {
          this.queryFormData.factoryReferenceName = '';
          this.queryFormData.brandReferenceName = this.referenceName;
        }
      }
    },
    data () {
      return {
        operatorName: '',
        referenceName: '',
        popoverOperatorNameVisible: false,
        queryOperatorNameType: '1',
        popoverCompanyVisible: false,
        queryCompanyType: '1'
      }
    },
    watch: {

    }
  }
</script>

<style scoped>
  .proofing-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }
  .input-with-select .el-input-group__prepend {
    background-color: #fff;
  }
</style>
