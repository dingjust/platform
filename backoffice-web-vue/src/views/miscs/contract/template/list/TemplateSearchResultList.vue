<template>
  <div class="animated fadeIn">
    <el-row>
      <el-col :span="4" v-for="(o, index) in 10" :key="o" :offset="0">
        <div style="margin: 10px">
          <el-card :body-style="{ padding: '5px'}">
            <img width="150px" height="150px" src="http://attach.bbs.wps.cn/attachments/forum/201307/04/2227437j184dwnaabrwl71.jpg">
            <div style="padding: 5px;">
              <span>XXXXXXXXX采购合同模板</span>
              <div class="bottom clearfix">
                <el-button type="text" class="button">启用</el-button>
                <el-button type="text" class="button">禁用</el-button>
                <el-button type="text" class="button">下载</el-button>
                <el-button type="text" class="button">删除</el-button>
              </div>
            </div>
          </el-card>
        </div>
      </el-col>
    </el-row>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<style>
  .time {
    font-size: 13px;
    color: #999;
  }

  .bottom {
    margin-top: 13px;
    line-height: 12px;
  }

  .button {
    padding: 0;
  }


  .clearfix:after {
    clear: both
  }
</style>

<script>

  export default {
    name: 'TemplateSearchResultList',
    props: ["page"],
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      }
    },
    data() {
      return {
      }
    }
  }
</script>
