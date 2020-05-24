<template>
  <div class="animated fadeIn" style="padding-top: 20px">
    <el-row class="basic-form-row_top" type="flex" align="middle">
      <h6 class="info-input-prepend_top">{{title ? title : '发单需求'}}</h6>
    </el-row>
    <el-row class="basic-form-row" type="flex" :gutter="20">
      <el-col :span="6">
        <el-form-item label="外发目标价格" label-width="100px">
          <el-input placeholder="请输入接单价格" size="mini"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="外发目标交期" label-width="100px">
          <el-date-picker v-model="value" type="date" placeholder="请选择日期" style="width: 160px"></el-date-picker>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="外发工厂规模" label-width="100px">
          <el-select v-model="value" placeholder="请选择">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="指定生产工厂" label-width="100px">
          <el-select v-model="value" placeholder="请选择">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
            <el-row type="flex" justify="center" align="middle">
              <el-button type="text" @click="loadMore">点击加载更多</el-button>
            </el-row>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle" style="padding-left: 15px">
      <el-col :span="19">
        <MTAVAT :machiningTypes.sync="form.machiningType" :needVoice.sync="form.needVoice" :tax.sync="form.tax" />
      </el-col>
      <el-col :span="5">
        <el-form-item  label="入仓方式" label-width="100px">
          <el-select v-model="value" placeholder="请选择">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row style="padding-left: 6px">
      <my-address-form :vAddress.sync="form.address" />
    </el-row>
    <el-row class="basic-form-row_top" type="flex" align="middle">
      <h6 class="info-input-prepend_top">人员设置</h6>
    </el-row>
    <el-row type="flex">
      <el-col :span="6">
        <el-form-item label="生产负责人" label-width="95px">
          <el-input placeholder="请输入生产负责人" size="mini"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row class="basic-form-row_top" type="flex" align="middle">
      <h6 class="info-input-prepend_top">备注</h6>
    </el-row>
    <el-row class="basic-form-row" type="flex">
        <el-input
          type="textarea"
          placeholder="请输入内容">
        </el-input>
    </el-row>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions,
    mapGetters
  } = createNamespacedHelpers('CooperatorModule');

  import MTAVAT from '../../../../../components/custom/order-form/MTAVAT';
  import MyAddressForm from '../../../../../components/custom/order-form/MyAddressForm';
  export default {
    name: 'ProductionTaskInvoiceForm',
    props: ['title'],
    components: {MyAddressForm, MTAVAT},
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapActions({
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const queryFormData = {'type': 'online'};
        const url = this.apis().getCooperators();
        this.searchAdvanced({
          url,
          queryFormData,
          page,
          size
        });
        this.cooperators = this.page.content;
      },
      loadMore () {
        this.options = this.options.concat(this.optionsZ);
      }
    },
    data () {
      return {
        cooperators: [],
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        invoiceStatus: [
          {
            code: 'hasInvoice',
            name: '开发票'
          },
          {
            code: 'notHasInvoice',
            name: '不开发票'
          }
        ],
        options: [{
          value: '选项1',
          label: '黄金糕'
        }, {
          value: '选项2',
          label: '双皮奶'
        }, {
          value: '选项3',
          label: '蚵仔煎'
        }, {
          value: '选项4',
          label: '龙须面'
        }, {
          value: '选项5',
          label: '北京烤鸭'
        }],
        optionsZ: [{
          value: '选项6',
          label: '黄金糕'
        }, {
          value: '选项7',
          label: '双皮奶'
        }, {
          value: '选项8',
          label: '蚵仔煎'
        }, {
          value: '选项9',
          label: '龙须面'
        }, {
          value: '选项10',
          label: '北京烤鸭'
        }],
        form: {
          machiningTypes: '',
          needVoice: '',
          tax: '',
          address: {}
        },
        value: '',
        regions: [],
        formData: {
          contactAddress: {
            city: {
              cityDistrict: {}
            }
          }
        }
      }
    },
    mounted () {
    },
    created () {
      this.onSearch();
    }
  }
</script>

<style scoped>
  .basic-form-row_top {
    padding-left: 8px;
    margin-bottom: 10px;
  }
  .basic-form-row {
    padding-left: 9px;
    /*margin-bottom: 20px;*/
  }

  .info-input-prepend_top {
    display: inline-block;
    margin: 0 5px;
    /*margin-top: 5px; */
    width: 60px;
    font-size: 14px;
    font-weight: 500;
    padding-top: 2px;
  }
</style>
