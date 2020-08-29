<template>
  <div class="uniquecode-form-body">
    <el-row class="uniquecode-form-title-row">
      <div class="uniquecode-form-title">
        <h6 class="uniquecode-form-title_text">唯一码导入</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="center">
      <el-input v-model="uniqueCode" placeholder="输入唯一码">
        <el-button slot="append" @click="onSearch">检索</el-button>
      </el-input>
    </el-row>
    <el-table :data="dataTable" class="form-table" :span-method="objectSpanMethod">
      <el-table-column label="订单号">
        <template>
          <span>{{order.code}}</span>
        </template>
      </el-table-column>
      <el-table-column label="商品">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product!=null?scope.row.product.name:''}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
              <el-row>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="合作商">
        <template>
          <span>{{order.originCooperator!=null?order.originCooperator.name:''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交期">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" justify="center" v-if="order">
      <el-button @click="onSure" class="submit-btn">确认导入</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "UniqueCodeImportForm",
    components: {},
    mixins: [],
    computed: {
      dataTable: function () {
        if (this.order != null && this.order != '') {
          return this.order.taskOrderEntries;
        } else {
          return [];
        }
      }
    },
    methods: {
      async onSearch() {
        const url = this.apis().uniqueCodeCheck(this.uniqueCode);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        if (result['code'] == 1) {
          this.order = result.data;
        }
      },
      onSure() {
        this.$confirm('确认导入？')
          .then(_ => {
            this._onSure();
          })
          .catch(_ => {});
      },
      async _onSure() {
        const url = this.apis().importSalesOrderByUniqueCode(this.uniqueCode);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("导入成功");
        this.$emit('callback');
      },
      objectSpanMethod({
        row,
        column,
        rowIndex,
        columnIndex
      }) {
        // if (columnIndex === 0) {
        //   if (rowIndex == this.dataTable.length - 1) {
        //     return {
        //       rowspan: this.dataTable.length,
        //       colspan: 1
        //     };
        //   } else {
        //     return {
        //       rowspan: 0,
        //       colspan: 1
        //     };
        //   }
        // }

        if (columnIndex === 0) {
          if (rowIndex === 0) {
            return {
              rowspan: this.dataTable.length,
              colspan: 1
            };
          } else {
            return {
              rowspan: 0,
              colspan: 1
            };
          }
        }
      }
    },
    data() {
      return {
        uniqueCode: "",
        order: ''
      };
    },
    created() {},
    mounted() {}
  };

</script>
<style scoped>
  .uniquecode-form-body {
    width: 100%;
  }

  .uniquecode-form-title {
    width: 100%;
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    height: 14px;
  }

  .uniquecode-form-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .uniquecode-form-title-row {
    margin-bottom: 20px;
  }

  .uniquecode-form-order {
    background-color: rgba(0, 0, 0, 0.02);
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
    margin-top: 20px;
  }

  .uniquecode-form-text {
    font-size: 12px;
    color: rgba(51, 48, 48, 0.65);
  }

  .uniquecode-form-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    margin-top: 20px;
  }

  .submit-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    width: 150px;
    margin-top: 20px;
  }

  .form-table {
    width: 100%;
    margin-top: 20px;
  }

</style>
