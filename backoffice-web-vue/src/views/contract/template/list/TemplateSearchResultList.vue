<template>
  <div class="animated fadeIn template-body">
    <el-row>
      <el-col :span="3" v-for="(item, index) in mockData" :key="index" :offset="0">
        <div :class="item.code==selectedCode?'template-file_selected':'template-file'" @click="onSelect(item.code)">
          <div class="template-ban" v-show="item.baned">
            <i class="el-icon-remove template-ban_icon"></i>
          </div>
          <el-row type="flex" justify="center">
            <img src="static/img/word.png" class="img-word" alt="" />
          </el-row>
          <el-row type="flex" justify="center">
            <el-col :span="16">
              <h6 class="template-name">XXXXXXXXX采购合同模板</h6>
            </el-col>
          </el-row>
        </div>
      </el-col>
    </el-row>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<style>
  .template-file {
    padding-top: 10px;
    margin-bottom: 10px;
    border-radius: 10px;
    flex-direction: column;
    display: flex;
    border: 1px solid #ffffff;
  }

  .template-file_selected {
    padding-top: 10px;
    margin-bottom: 10px;
    border-radius: 10px;
    flex-direction: column;
    display: flex;
    background-color: #ededed;
    border: 1px solid #ffd60c;
  }

  .template-file:hover {
    background-color: #ededed;
  }

  .template-file:active {
    background-color: #ededed;
  }

  .img-word {
    width: 59px;
    height: 65px;
  }

  .template-name {
    text-align: center;
    font-size: 12px;
  }

  .template-body {
    padding-top: 20px;
  }

  .template-ban {
    z-index: 1;
    position: absolute;
    right: 30px;
  }

  .template-ban_icon {
    color: red;
    font-size: 30px;
  }

</style>

<script>
  export default {
    name: "TemplateSearchResultList",
    props: ["page"],
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        if (this.isAdvancedSearch) {
          this.$emit("onAdvancedSearch", val);
          return;
        }

        this.$emit("onSearch", 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.isAdvancedSearch) {
          this.$emit("onAdvancedSearch", val - 1);
          return;
        }

        this.$emit("onSearch", val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSelect(code) {
        if (code == this.selectedCode) {
          this.selectedCode = "";
        } else {
          this.selectedCode = code;
        }
      },

    },
    data() {
      return {
        selectedCode: "0",
        mockData: [{
            code: "1",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "2",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "3",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "5",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "6",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "7",
            name: "XXXXXXXXX采购合同模板",
            baned:true
          },
          {
            code: "8",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "9",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "10",
            name: "XXXXXXXXX采购合同模板"
          },
        ]
      };
    }
  };

</script>
