<template>
  <div class="animated fadeIn">
    <el-row>
      <el-button @click="onSearch" type="text">刷新</el-button>
    </el-row>
    <el-table ref="resultTable" stripe :data="suppliers" highlight-current-row @current-change="handleCurrentChange"
      @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="32"></el-table-column> -->
      <el-table-column>
        <template slot-scope="scope">
          <el-row>
            <!-- <el-col :span="4">
              <img width="54px" height="54px"
                :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'">
            </el-col> -->
            <el-col :span="20">
              <el-row>
                <h6 class="product-info">{{getCooperator(scope.row).name}}</h6>
              </el-row>
              <el-row>
                <h6 class="product-info">{{getCooperator(scope.row).person}}</h6>
              </el-row>
              <el-row>
                <h6 class="product-info">{{getCooperator(scope.row).phone}}</h6>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" justify="center" style="margin-top:20px;">
      <el-button class="product-select-btn" @click="onSure">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'SuppliersSelect',
    computed: {

    },
    methods: {
      async onSearch() {
        var url;
        url = this.apis().getCooperators();
        const result = await this.$http.get(url, {
          keyword: '',
          page: 0,
          size: 99
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.suppliers = result;
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
        this.selectSupplier = val;
      },
      onSure() {
        var result = {};
        if (this.selectSupplier.partner != null) {
          result = {
            id: this.selectSupplier.id,
            name: this.selectSupplier.partner.name,
            person: this.selectSupplier.partner.contactPerson,
            phone: this.selectSupplier.partner.contactPhone
          };
        } else {
          result = {
            id: this.selectSupplier.id,
            name: this.selectSupplier.name,
            person: this.selectSupplier.contactPerson,
            phone: this.selectSupplier.contactPhone
          };
        }
        this.$emit('onSelect', result);
      },
      getCooperator(cooperator) {
        if (cooperator.partner != null) {
          return {
            name: cooperator.partner.name,
            person: cooperator.partner.contactPerson,
            phone: cooperator.partner.contactPhone
          };
        } else {
          return {
            name: cooperator.name,
            person: cooperator.contactPerson,
            phone: cooperator.contactPhone
          };
        }
      },
    },
    created() {
      this.onSearch();
    },
    data() {
      return {
        suppliers: [],
        multipleSelection: [],
        selectSupplier: ''
      }
    }
  }

</script>
<style>
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
    height: 25px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

</style>
