<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="请输入产品货号/名称查询" v-model="keyword"></el-input>
      </el-form-item>
      <!-- <el-button-group> -->
      <el-button type="text" @click="onSearch">查找</el-button>
      <!-- </el-button-group> -->
      <el-button class="product-select-btn" @click="onSure">确定</el-button>
    </el-form>
    <el-table ref="resultTable" stripe :data="page.content" :height="suppliers" highlight-current-row
      @current-change="handleCurrentChange" @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="32"></el-table-column> -->
      <el-table-column>
        <template slot-scope="scope">
          <el-row>
            <el-col :span="4">
              <img width="54px" height="54px"
                :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'">
            </el-col>
            <el-col :span="20">
              <el-row>
                <h6 class="product-info">{{scope.row.name}}</h6>
              </el-row>
              <el-row>
                <h6 class="product-info">{{scope.row.skuID}}</h6>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
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
        if (this.isBrand()) {
          url = this.apis().getBrandSuppliers();
        } else if (this.isFactory()) {
          url = this.apis().getFactoriesSuppliers();
        }
        const result = await this.$http.get(url, {}, {
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
        this.selectProduct = val;
      },
      onSure() {
        this.$emit('onSelect', this.selectProduct);
      }
    },
    created() {
      this.onSearch();
    },
    data() {
      return {
        suppliers: []
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
