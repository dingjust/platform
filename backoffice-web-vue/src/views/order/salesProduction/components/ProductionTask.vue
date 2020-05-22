<template>
  <div class="animated fadeIn" style="padding-top: 20px">
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-form :model="slotData" ref="taskForm" label-position="left" :disabled="readOnly">
      <el-row class="basic-form-row_top" type="flex" align="middle">
        <h6 class="info-input-prepend_top">生产要求</h6>
      </el-row>
      <el-row class="basic-form-row" type="flex" :gutter="20" align="middle">
        <el-col :span="8">
          <el-form-item label="外发目标价格" label-width="110px" prop='price'
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-input placeholder="请输入接单价格" size="mini" v-model="slotData.price"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="外发目标交期" label-width="110px" prop='deliveryTime'
            :rules="{required: true, message: '不能为空', trigger: 'blur'}">
            <el-date-picker v-model="slotData.deliveryTime" type="date" placeholder="请选择日期" style="width: 160px">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="外发工厂规模" label-width="110px" prop='populationScale'>
            <el-select v-model="slotData.populationScale" placeholder="请选择">
              <el-option v-for="item in populationScales" :key="item.value" :label="item.name" :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row class="basic-form-row" type="flex" :gutter="20" align="middle">
        <el-col :span="8">
          <el-form-item label="指定生产工厂" label-width="110px" prop='appointFactory.name'>
            <span style="color:orange">{{slotData.appointFactory!=null?slotData.appointFactory.name:''}}</span>
            <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini">选择供应商
            </el-button>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" align="middle" style="padding-left: 15px">
        <el-col :span="19">
          <MTAVAT :machiningTypes.sync="slotData.cooperationModes" :needVoice.sync="slotData.invoiceNeeded"
            :tax.sync="slotData.invoiceTaxPoint" />
        </el-col>
        <!-- <el-col :span="5">
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
      </el-col> -->
      </el-row>
      <el-row style="padding-left: 6px">
        <my-address-form :vAddress.sync="slotData.shippingAddress" ref="addressComp" :readOnly="readOnly" />
      </el-row>
      <el-row class="basic-form-row_top" type="flex" align="middle">
        <h6 class="info-input-prepend_top">人员设置</h6>
      </el-row>
      <el-row type="flex" class="basic-form-row_top">
        <el-col :span="6">
          <el-form-item label="生产负责人" label-width="95px">
            <el-input placeholder="请输入生产负责人" size="mini" v-model="productionLeader.name" :disabled="true">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row class="basic-form-row_top" type="flex" align="middle">
        <h6 class="info-input-prepend_top">备注</h6>
      </el-row>
      <el-row class="basic-form-row" type="flex">
        <el-input type="textarea" placeholder="请输入内容" v-model="slotData.remark">
        </el-input>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';
  import SupplierSelect from '@/components/custom/SupplierSelect';
  export default {
    name: 'ProductionTask',
    props: ['slotData', 'productionLeader'],
    props: {
      slotData: {
        type: Object,
      },
      productionLeader: {
        type: Object,
        default: {
          name: ''
        }
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    components: {
      MyAddressForm,
      MTAVAT,
      SupplierSelect
    },
    computed: {

    },
    methods: {
      //选择供应商
      onSuppliersSelect(val) {
        this.suppliersSelectVisible = false;
        console.log(JSON.stringify(val));
        this.$set(this.slotData, 'appointFactory', {
          name: val.name,
          id: val.id
        });
      },
    },
    data() {
      return {
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        populationScales: this.$store.state.EnumsModule.populationScales,
        suppliersSelectVisible: false,
      }
    },
    mounted() {},
    created() {
      if (this.slotData.shippingAddress == null) {
        this.$set(this.slotData, 'shippingAddress', {
          region: '',
          city: '',
          cityDistrict: '',
          line1: ''
        });
      }
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
