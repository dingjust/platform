<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入发料单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建发料单</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content">
        <el-table-column label="编号" prop="code"></el-table-column>
        <el-table-column label="状态" prop="status">
          <template slot-scope="scope">
            <span>{{scope.row.status | enumTranslate('PickOrderStatus')}}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建用户" prop="user.name"></el-table-column>
        <el-table-column label="创建时间" prop="createdTs">
          <template slot-scope="scope">
            <span>{{scope.row.createdTs | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2"></div>
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
      <div class="clearfix"></div>
    </el-card>
  </div>
</template>

<script>
  import axios from 'axios';
  import PickOrderForm from './PickOrderForm';
  import PickOrderDetailsPage from './PickOrderDetailsPage';

  const DEFAULT_ORDER_TYPE = 'WAIT_FOR_CONFIRM';

  export default {
    name: 'PickOrderPage',
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider('创建发料单', PickOrderForm, {
          id: null,
          code: '',
          order: {
            id: '',
            code: '',
            entries: []
          },
          entries: [],
          status: DEFAULT_ORDER_TYPE
        });
      },
      onDetails(item) {
        console.log(item);
        this.fn.openSlider('订单明细', PickOrderDetailsPage, item);
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
      _onSearch(page, size) {
        const params = {
          text: this.text,
          page: page,
          size: size
        };

        axios.get('/djfactory/pickOrder', {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          console.log(JSON.stringify(error));
          this.$message.error(error.response.data);
        });
      }
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
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
      };
    }
  };
</script>
