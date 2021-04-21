<template>
  <div class="animated fadeIn factory-cooperator-transfer-form">
    <el-row type="flex">
      <el-col :span="12">
        <el-radio-group v-model="isFactorySelection" @change="handleChanged">
          <el-radio border :label="false">合作商</el-radio>
          <el-radio border :label="true">全部工厂</el-radio>
        </el-radio-group>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle">
      <el-col :span="11">
        <div style="padding: 10px;border:1px solid #c8c8c8;border-radius: 8px;height: 400px;overflow:scroll;">
          <el-row type="flex" style="margin-bottom: 10px" v-if="isFactorySelection">
            <el-input v-model="factoryQueryFormData.keyword" placeholder="请输入工厂名称" ></el-input>
            <el-button @click="onSearch">搜索</el-button>
            <el-select
              v-model="factoryQueryFormData.productiveOrientations"
              clearable
              value-key="isocode"
              placeholder="地区">
              <el-option
                v-for="item in regions"
                :key="item.isocode"
                :label="item.name"
                :value="item.isocode">
              </el-option>
            </el-select>
            <el-cascader
              v-model="factoryQueryFormData.adeptAtCategories"
              placeholder="分类"
              clearable
              :options="categories"
              :props="{ expandTrigger: 'hover' ,value:'code',label:'name'}"
              :show-all-levels="false">

            </el-cascader>
            <el-popover
              placement="bottom"
              width="234"
              trigger="click">
              <el-row type="flex" justify="end" style="margin-bottom: 20px">
                <h6 style="margin-right: 39px">面料类别</h6>
                <el-button style="padding: 5px;background-color: #c8c8c8;" @click="clearFactoryQueryFormData">重置</el-button>
              </el-row>
              <el-row>
                <el-tag
                  v-for="(item,index) of majorCategories"
                  :key="index"
                  :style="{'margin-right':(index+1) % 3 !== 0 ? '20px':'0px','color': '#0b0e0f', 'margin-bottom': '10px',  'cursor': 'pointer', }"
                  :color="factoryQueryFormData.categories.indexOf(item.code) > -1 ? '#FFD60C' : '#ffffff'"
                  @click="handleMajorCategoriesTagClick(item)"
                  size="medium">
                  {{item.name}}
                </el-tag>
              </el-row>
              <el-row type="flex" justify="center" style="margin-bottom: 20px">加工方式</el-row>
              <el-row type="flex" justify="space-around">
                <el-tag
                  v-for="(item,index) of machiningTypes"
                  :key="index"
                  class="elTagClass"
                  :color="factoryQueryFormData.machiningTypes.indexOf(item.code) > -1 ? '#FFD60C' : '#ffffff'"
                  @click="handleMachiningTypesTagClick(item)"
                  size="medium">
                  {{item.name}}
                </el-tag>
              </el-row>
              <el-row type="flex" justify="center" style="margin-bottom: 20px">工厂规模</el-row>
              <el-row>
                <el-tag
                  v-for="(item,index) of populationScales"
                  :key="index"
                  class="elTagClass"
                  :color="factoryQueryFormData.populationScales.indexOf(item.code) > -1 ? '#FFD60C' : '#ffffff'"
                  @click="handlePopulationScalesTagClick(item)"
                  size="medium">
                  {{item.name}}
                </el-tag>
              </el-row>
              <el-row type="flex" justify="center" style="margin-bottom: 20px">属性标签</el-row>
              <el-row>
                <el-tag
                  v-for="(item,index) of labels"
                  :key="index"
                  class="elTagClass"
                  :color="factoryQueryFormData.labels.indexOf(item.id) > -1 ? '#FFD60C' : '#ffffff'"
                  @click="handleLabelsTagClick(item)"
                  size="medium">
                  {{item.name}}
                </el-tag>
              </el-row>
              <el-button slot="reference">其他</el-button>
            </el-popover>
          </el-row>
          <el-row type="flex" style="margin-bottom: 10px" v-else>
            <el-input v-model="cooperatorQueryFormData.keyword" placeholder="请输入合作商名称" ></el-input>
            <el-button @click="onSearch">搜索</el-button>
          </el-row>
          <div v-if="!isFactorySelection">
            <div v-for="(item, index) of cooperatorPage.content" :key="index" style="margin-bottom: 10px">
              <cooperator-item
                class="transfer-item"
                :slotData="item"
                :isSelected="isCooperatorSelected(item)"
                @handleCooperatorSelectionChange="handleCooperatorSelect">

              </cooperator-item>
            </div>
          </div>
          <div v-if="isFactorySelection">
            <div v-for="(item, index) of factoryPage.content" :key="index" style="margin-bottom: 10px">
              <factory-item
                class="transfer-item"
                :slotData="item"
                :isSelected="isFactorySelected(item)"
                @handleFactorySelectionChange="handleFactorySelect">

              </factory-item>
            </div>
          </div>
          <el-row type="flex" style="position:sticky; bottom:0;background-color: white">
            <el-pagination v-if="!isFactorySelection" layout="total, sizes, prev, pager, next, jumper" small
                           hide-on-single-page
                           @size-change="onCooperatorPageSizeChanged"
                           @current-change="onCooperatorPageChanged"
                           :current-page="cooperatorPage.number + 1"
                           :page-size="cooperatorPage.size"
                           :page-count="cooperatorPage.totalPages"
                           :total="cooperatorPage.totalElements">
            </el-pagination>
          </el-row>
          <el-row type="flex" style="position:sticky; bottom:0;background-color: white">
            <el-pagination v-if="isFactorySelection" layout="total, sizes, prev, pager, next, jumper"  small
                           hide-on-single-page
                           @size-change="onFactoryPageSizeChanged"
                           @current-change="onFactoryPageChanged"
                           :current-page="factoryPage.number + 1"
                           :page-size="factoryPage.size"
                           :page-count="factoryPage.totalPages"
                           :total="factoryPage.totalElements">
            </el-pagination>
          </el-row>
        </div>
      </el-col>
      <el-col :span="2">
        <el-row type="flex" justify="center">
          <img src="static/img/left_right.jpg" width="30px" height="30px"/>
        </el-row>
      </el-col>
      <el-col :span="11">
        <div style="padding: 10px;border:1px solid #c8c8c8;border-radius: 8px;height: 400px;overflow:scroll;">
          <div v-for="(item, index) of selectCooperators" :key="index" style="margin-bottom: 10px">
            <cooperator-item
              class="transfer-item"
              :slotData="item"
              :isSelect="true"
              :isSelected="isCooperatorSelected(item)"
              @handleCooperatorSelectionChange="handleCooperatorRemove">

            </cooperator-item>
          </div>
          <div v-for="(item, index) of selectFactories" :key="index" style="margin-bottom: 10px">
              <factory-item
                class="transfer-item"
                :slotData="item"
                :isSelect="true"
                :isSelected="isFactorySelected(item)"
                @handleFactorySelectionChange="handleFactoryRemove">

              </factory-item>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import CooperatorItem from "../../../../components/custom/item/CooperatorItem";
  import FactoryItem from "../../../../components/custom/item/FactoryItem";

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'FactoryCooperatorTransferForm',
    props: ['selectUids', 'selectPhoneNumbers','selectFactories','selectCooperators','selectFactoryUids','selectCooperatorIds'],
    computed: {
      ...mapGetters({
        regions: 'regions',
        labels: 'labels',
        categories: 'categories',
        majorCategories: 'majorCategories',
        factoryPage: 'factoryPage',
        cooperatorPage: 'cooperatorPage',
        cooperatorQueryFormData: 'cooperatorQueryFormData',
        factoryQueryFormData: 'factoryQueryFormData'
      })
    },
    components: {FactoryItem, CooperatorItem},
    methods: {
      ...mapMutations({
        setLabels: 'labels'
      }),
      ...mapActions({
        searchAdvanced: 'searchAdvanced',
        searchCooperatorsAdvanced: 'searchCooperatorsAdvanced',
        searchFactoriesAdvanced: 'searchFactoriesAdvanced',
        clearFactoryQueryFormData: 'clearFactoryQueryFormData',
        clearCooperatorQueryFormData: 'clearCooperatorQueryFormData'
      }),
      onCooperatorPageSizeChanged (val) {
        this.onSearchCooperator(0, val);
      },
      onCooperatorPageChanged (val) {
        this.onSearchCooperator(val - 1);
      },
      onFactoryPageSizeChanged (val) {
        this.onSearchFactory(0, val);
      },
      onFactoryPageChanged (val) {
        this.onSearchFactory(val - 1);
      },
      onSearch () {
        if (this.isFactorySelection) {
          this.onSearchFactory();
        } else {
          this.onSearchCooperator();
        }
      },
      async getLabels () {
        const url = this.apis().getLabels();
        const results = await this.$http.post(url, {
          groups: ['FACTORY', 'PLATFORM']
        });
        if (results['errors']) {
          this.$message.error(results['errors'][0].message);
          return;
        }

        this.setLabels(results.content);
      },
      handleCooperatorSelect (val) {
        var index = this.selectCooperatorIds.indexOf(val.id);
        if (index <= -1) {
          this.selectCooperatorIds.push(val.id);
          this.selectCooperators.push(val);
          if (val.type === 'ONLINE') {
            this.selectUids.push(val.partner.uid);
          }
        }
      },
      handleCooperatorRemove (val) {
        var index = this.selectCooperatorIds.indexOf(val.id);
        if (index > -1) {
          this.selectCooperatorIds.splice(index, 1);
          this.selectCooperators.splice(index, 1);
          if (val.type === 'ONLINE') {
            var index1 = this.selectUids.indexOf(val.partner.uid);
            if (index1 > -1) {
              this.selectUids.splice(index1, 1);
            }
          }
        }
      },
      handleFactorySelect (val) {
        var index = this.selectUids.indexOf(val.uid);
        if (index <= -1) {
          this.selectFactoryUids.push(val.uid);
          this.selectUids.push(val.uid);
          this.selectFactories.push(val);
        }
      },
      handleFactoryRemove (val) {
        var index1 = this.selectUids.indexOf(val.uid);
        if (index1 > -1) {
          this.selectUids.splice(index1, 1);
          var index = this.selectFactoryUids.indexOf(val.uid);
          if (index > -1) {
            this.selectFactoryUids.splice(index, 1);
            this.selectFactories.splice(index, 1);
          }
        }
      },
      // 选中行
      handleCurrentChange (val) {
        this.selectPayPlan = val;
      },
      onSure () {
        this.$emit('onSelect', this.selectPayPlan);
      },
      async onSearchFactory (page, size) {
        const url = this.apis().getFactories();
        const query = this.factoryQueryFormData;
        this.searchFactoriesAdvanced({
          url,
          query,
          page,
          size
        });
        this.isFactorySearched = true;
        if (this.labels.length <= 0) {
          this.getLabels();
        }
      },
      async onSearchCooperator (page, size) {
        const url = this.apis().getCooperators();
        this.cooperatorQueryFormData.type = 'ONLINE';
        const query = this.cooperatorQueryFormData;
        this.searchCooperatorsAdvanced({
          url,
          query,
          page,
          size
        });
        this.isCooperatorSearched = true;
      },
      handleChanged (val) {
        if (val && !this.isFactorySearched) {
          this.onSearchFactory();
        } else if (!this.isCooperatorSearched) {
          this.onSearchCooperator();
        }
      },
      isCooperatorSelected (item) {
        var flag = false;
        if (item.type === 'ONLINE') {
          flag = this.selectUids.indexOf(item.partner.uid) > -1;
        } else {
          flag = this.selectCooperatorIds.indexOf(item.id) > -1;
        }
        return flag;
      },
      isFactorySelected (item) {
        return this.selectUids.indexOf(item.uid) > -1;
      },
      handleMajorCategoriesTagClick (item) {
        var index = this.factoryQueryFormData.categories.indexOf(item.code);
        if (index > -1) {
          this.factoryQueryFormData.categories.splice(index, 1);
        } else {
          if (this.factoryQueryFormData.categories.length > 0) {
            this.factoryQueryFormData.categories.splice(index, 1);
          }
          this.factoryQueryFormData.categories.push(item.code);
        }
      },
      handleMachiningTypesTagClick (item) {
        var index = this.factoryQueryFormData.machiningTypes.indexOf(item.code);
        if (index > -1) {
          this.factoryQueryFormData.machiningTypes.splice(index, 1);
        } else {
          if (this.factoryQueryFormData.machiningTypes.length > 0) {
            this.factoryQueryFormData.machiningTypes.splice(index, 1);
          }
          this.factoryQueryFormData.machiningTypes.push(item.code);
        }
      },
      handlePopulationScalesTagClick (item) {
        var index = this.factoryQueryFormData.populationScales.indexOf(item.code);
        if (index > -1) {
          this.factoryQueryFormData.populationScales.splice(index, 1);
        } else {
          if (this.factoryQueryFormData.populationScales.length > 0) {
            this.factoryQueryFormData.populationScales.splice(index, 1);
          }
          this.factoryQueryFormData.populationScales.push(item.code);
        }
      },
      handleLabelsTagClick (item) {
        var index = this.factoryQueryFormData.labels.indexOf(item.id);
        if (index > -1) {
          this.factoryQueryFormData.labels.splice(index, 1);
        } else {
          if (this.factoryQueryFormData.labels.length > 0) {
            this.factoryQueryFormData.labels.splice(index, 1);
          }
          this.factoryQueryFormData.labels.push(item.id);
        }
      },
    },
    data () {
      return {
        multipleSelection: [],
        selectPayPlan: '',
        keyword: '',
        isFactorySelection: false,
        isFactorySearched: false,
        isCooperatorSearched: false,
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        populationScales: this.$store.state.EnumsModule.populationScales,
      }
    },
    created () {
      this.onSearch();
    },
    destroyed(){
      this.clearFactoryQueryFormData();
      this.clearCooperatorQueryFormData();
    }
  }
</script>
<style>
  .factory-cooperator-transfer-form .el-table--striped .el-table__body tr.el-table__row--striped.current-row td {
    background-color: #ffc107;
  }

  .factory-cooperator-transfer-form .product-select-btn {
    width: 90px;
    height: 30px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

  .factory-cooperator-transfer-form .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

  .factory-cooperator-transfer-form .el-transfer-panel{
    width: 400px;
  }
  .factory-cooperator-transfer-form .transfer-item{
    border: 1px solid #c8c8c8;
    padding: 10px 0px 10px 10px;
  }

  .factory-cooperator-transfer-form  .elTagClass{
    color: #0b0e0f;
    margin-right: 10px;
    margin-bottom: 10px;
    cursor:pointer;
  }

  .factory-cooperator-transfer-form  .elTagClass2{
    color: #0b0e0f;
    margin-bottom: 10px;
    cursor:pointer;
  }



</style>
