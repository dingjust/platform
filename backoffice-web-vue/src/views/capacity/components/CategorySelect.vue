<template>
  <div class="animated fadeIn category-select">
    <el-row type="flex">
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane v-for="(item,index) in listData" :label="item.name" :name="item.name" :key="index">
          <!-- <span slot="label" v-if="selectCounts[item.code]" >
            <el-badge :value="selectCounts[item.code]" class="item">
              {{item.name}}
            </el-badge>
          </span> -->
          <el-tag  v-for="(val, i) of item.children" :key="i" class="elTagClass" :color="isSelected(val) ? '#FFD60C' : '#ffffff'"
            @click="handleTagClick(val)" size="medium">
            {{val.name}}
          </el-tag>
        </el-tab-pane>
      </el-tabs>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'CategorySelect',
    props: {
      selectDatas: {
        type: Array,
        default: []
      },
      multiple: {
        type: Boolean,
        default: true
      },
      maxNum: {
        type: Number,
        default: 999
      }
    },
    computed: {},
    methods: {
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.listData = result;
      },
      handleClick(tab, event) {
      },
      handleTagClick(val) {
        var index = this.selectCodes.indexOf(val.code);
        if (index > -1) {
          this.selectDatas.splice(index, 1);
          this.selectCodes.splice(index, 1);
        } else {
          if (!this.multiple) {
            this.selectDatas.splice(0);
            this.selectCodes.splice(0);
          } else if (this.selectCodes.length < this.maxNum) {
            this.selectDatas.push(
              {'category':val,'capacityRange':0}
            );
            this.selectCodes.push(val.code);
          }
        }
      },
      isSelected(item) {
        var index = this.selectCodes.indexOf(item.code);
        if (index > -1) {
          return true;
        } else {
          return false;
        }
      },
      init() {
        // 设置tab初始值
        if (this.listData.length > 0) {
          this.activeName = this.listData[0].name;
        }

        this.selectCodes = this.selectDatas.map(data => data.category.code);

        // for (var data of this.listData) {
        //   this.selectCounts[data.code] = 0;
        // }
        // for (var item of this.selectDatas) {
        //   this.selectCounts[item.parent.code] += 1;
        // }
      }
    },
    watch: {
      'listData': function (n, o) {
        this.init();
      },
    },
    data() {
      return {
        activeName: '',
        selectCodes: [],
        selectCounts: {},
        listData: []
      }
    },
    created() {
      this.getCategories();
      if (this.listData.length > 0) {
        this.init();
      }
    }
  }

</script>

<style>
  .category-select .el-tabs__item is-top is-active {
    color: #FFD60C;
  }

  .category-select .tab-pane-span-class {
    padding: 5px 10px;
    margin-right: 20px;
    background-color: #FFD60C;
    border-radius: 8px;
  }

  .category-select .el-tag {
    border-color: #FFffff;
  }

  .elTagClass {
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor: pointer;
  }

  .category-select .el-badge__content.is-fixed {
    top: 18px;
    right: 0px;
    line-height: 16px;
  }

</style>
