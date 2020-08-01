<template>
  <div class="animated fadeIn">
    <el-row type="flex" justify="space-between">
      <el-col :span="8">
        <h6 class="product-info">选择地址</h6>
      </el-col>
      <el-col :span="8">
        <Authorized :permission="['COMPANY_ADDRESS_CREATE']">
          <el-button type="text" icon="el-icon-plus" @click="onNew">新增</el-button>
        </Authorized>
        <el-button class="product-select-btn" @click="onSure">确定</el-button>
      </el-col>
      <!-- <el-col :span="4"> -->
      <!-- </el-col> -->
    </el-row>
    <el-table ref="resultTable" stripe :data="address" highlight-current-row @current-change="handleCurrentChange"
      @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="32"></el-table-column> -->
      <el-table-column>
        <template slot-scope="scope">
          <el-row>
            <el-col :span="6">
              <el-row>
                <h6 class="product-info">{{scope.row.fullname}}</h6>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row>
                <h6 class="product-info">{{scope.row.cellphone}}</h6>
              </el-row>
            </el-col>
            <el-col :span="12">
              <el-row>
                <h6 class="product-info">{{scope.row.details}}</h6>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <!-- <el-row type="flex" justify="center" style="margin-top:20px;">
      <el-button class="product-select-btn" @click="onSure">确定</el-button>
    </el-row> -->
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <address-details-page :slotData="form" v-if="dialogVisible" @callback="oncallback"/>
    </el-dialog>
  </div>
</template>

<script>
  import AddressDetailsPage from '../../views/user/address/details/AddressDetailsPage';

  export default {
    name: 'AddressSelect',
    components: {
      AddressDetailsPage
    },
    computed: {

    },
    methods: {
      async onSearch() {
        const result = await this.$http.get(this.apis().getAddresses());
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.address = result;
      },
      numberFormatter(val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      },
      //选中行
      handleCurrentChange(val) {
        this.selectAddress = val;
      },
      onSure() {
        this.$emit('onSelect', this.selectAddress);
      },
      onNew() {
        // this.fn.openSlider('新建地址', AddressDetailsPage, this.form);
        this.form = Object.assign({}, this.formData);
        this.dialogVisible=true;
      },
      oncallback(){
        this.dialogVisible=false;
        this.onSearch();
      }
    },
    created() {
      this.onSearch();
    },
    data() {
      return {
        address: [],
        multipleSelection: [],
        selectAddress: '',
        dialogVisible: false,
        form: {},
        formData: {
          "id": null,
          "fullname": "",
          "cellphone": "",
          "region": {
            "isocode": "",
            "name": ""
          },
          "city": {
            "code": "",
            "name": ""
          },
          "cityDistrict": {
            "code": "",
            "name": ""
          },
          "line1": "",
          "defaultAddress": false
        }
      }
    }
  }

</script>
<style scoped>
  .product-info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 12px;
  }

  .el-table--striped .el-table__body tr.el-table__row--striped.current-row td {
    background-color: #ffc107;
  }

  .product-select-btn {
    width: 70px;
    /* height: 25px; */
    background-color: #FFD60C;
    /* font-weight: 400; */
    color: rgba(0, 0, 0, 0.85);
    /* font-size: 10px; */
    /* border-radius: 0px; */
    border: 0px solid #FFD60C;
  }

  .product-select-btn:focus, .product-select-btn:hover {
    color: rgba(0, 0, 0, 0.85)!important;
    border-color: #FFD60C!important;
    background-color: #FFD60C!important;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

</style>
