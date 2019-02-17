<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入姓名查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content">
        <el-table-column label="姓名" prop="fullname"></el-table-column>
        <el-table-column label="手机号" prop="cellphone">
        </el-table-column>
        <el-table-column label="省" prop="region.name"></el-table-column>
        <el-table-column label="市" prop="city.name"></el-table-column>
        <el-table-column label="区" prop="cityDistrict.name"></el-table-column>
        <el-table-column label="详细地址" prop="line1"></el-table-column>
        <el-table-column loabel="操作">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="float-right">
        <el-pagination layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged"
                       :current-page="page.number + 1"
                       :page-size="page.size"
                       :page-count="page.totalPages"
                       :total="page.totalElements">
        </el-pagination>
      </div>
    </el-card>
  </div>
</template>

<script>
  import AddressForm from './AddressForm';
  import AddressDetailsPage from './AddressDetailsPage';

  export default {
    name: 'AddressPage',
    components: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider('添加地址', AddressForm, {
          id: null,
          fullname: '',
          cellphone: '',
          region: {
            isocode: '',
            name: ''
          },
          city: {
            code: '',
            name: ''
          },
          cityDistrict: {
            code: '',
            name: ''
          },
          line1: ''
        });
      },
      async onDetails(item) {
        const result = await this.$http.get('/djbrand/system/address/getAddressById/' + item.id);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.fn.openSlider('地址明细', AddressDetailsPage, result);
      },
      onPageSizeChanged(val) {
        this.reset();
        this.page.size = val;
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1, this.page.size);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      async _onSearch(page, size) {
        const params = {
          text: this.text,
          page: page,
          size: size
        };
        const result = await this.$http.get('/djbrand/system/address', params);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.page = result;
      },
      async changeShelfStatus(row) {
        let request = this.$http.put;
        let message = '启用';
        let url = '/djbrand/system/address/enable/';
        if (row.active === false) {
          message = '禁用';
          url = '/djbrand/system/address/disable/';
        }

        const result = await request(url + row.id);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success(message + '成功');
        this.onSearch();
      },
    },
    watch: {
      '$store.state.sideSliderState': function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    data() {
      return {
        text: '',
        items: [],
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
      }
    }
  }
</script>
