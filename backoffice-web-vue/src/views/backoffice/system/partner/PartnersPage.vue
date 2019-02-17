<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="图片" prop="media">
          <template slot-scope="scope">
            <img :src="scope.row.media" width="200" height="60"></img>
          </template>
        </el-table-column>
        <el-table-column label="跳转动作" prop="action"></el-table-column>
        <el-table-column label="是否启用">
          <template slot-scope="scope">
            <el-switch active-color="#13ce66" inactive-color="#ff4949"
                       v-model="scope.row.active"
                       @change="changeShelfStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="描述" prop="description"></el-table-column>
        <el-table-column label="操作" prop="description">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                      @size-change="onPageSizeChanged"
                      @current-change="onCurrentPageChanged"
                      :current-page="page.number + 1"
                      :page-size="page.size"
                      :page-count="page.totalPages"
                      :total="page.totalElements">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
  import axios from 'axios';
  import autoHeight from 'mixins/autoHeight'
  import PartnersForm from './PartnersForm';
  import PartnersDetailsPage from './PartnersDetailsPage';

  export default {
    name: 'PartnersPage',
    mixins: [autoHeight],
    components: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider('添加图片', PartnersForm, {
          name: '',
          description: '',
          active: true,
          action: '',
          media: ''
        });
      },
      onDetails(item) {
        console.log(item);
        this.fn.openSlider('图片详情', PartnersDetailsPage, item);
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
        axios.get('/djbackoffice/system/partners', {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error('获取数据失败');
        });
      },
      changeShelfStatus(row) {
        let request = axios.put;
        let message = '启用';
        let url = '/djbackoffice/system/partners/enable/';
        if (row.active === false) {
          message = '禁用';
          url = '/djbackoffice/system/partners/disable/';
        }

        request(url + row.id)
          .then(() => {
            this.$message.success(message + '成功');

            this.onSearch();
          }).catch(error => {
            this.$message({
              type: 'error',
              message: message + '失败， 原因：' + error.response.data
            });
          }
        );
      },
    },
    created(){
      this.onSearch();
    },
    computed: {},
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
