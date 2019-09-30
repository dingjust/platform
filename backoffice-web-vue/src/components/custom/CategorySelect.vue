<template>
  <div class="animated fadeIn category-select">
    <el-row type="flex" >
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane v-for="(item,index) in listData" :label="item.name" :name="item.name" >
          <span slot="label" v-if="selectCounts[item.code]">
             <el-badge :value="selectCounts[item.code]" class="item">
               {{item.name}}
             </el-badge>
          </span>
          <el-tag
            v-for="val of item.children"
            class="elTagClass"
            :color="val.color"
            @click="handleTagClick(val)"
            size="medium">
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
    props: ['listData', 'selectDatas'],
    computed: {
    },
    methods: {
      handleClick (tab, event) {
        console.log(tab, event);
      },
      handleTagClick (val) {
        for (var i = 0; i < this.listData.length; i++) {
          for (var j = 0; j < this.listData[i].children.length; j++) {
            if (this.listData[i].children[j].code === val.code) {
              var index = this.selectCodes.indexOf(val.code);
              if (index > -1) {
                this.listData[i].children[j].color = '#ffffff';
                this.$forceUpdate();
                this.selectDatas.splice(index, 1);
                this.selectCodes.splice(index, 1);
                // this.selectCounts[this.listData[i].code].splice(index, 1);
              } else {
                this.listData[i].children[j].color = '#FFD60C';
                this.$forceUpdate();
                this.selectDatas.push(this.listData[i].children[j]);
                this.selectCodes.push(this.listData[i].children[j].code);
                // this.selectCounts[this.listData[i].code].push(val.code);
              }
            }
          }
        }
      },
      init () {
        // 设置tab初始值
        if (this.listData.length > 0) {
          this.activeName = this.listData[0].name;
        }

        this.selectCodes = this.selectDatas.map(data => data.code);

        for (var data of this.listData) {
          this.selectCounts[data.code] = 0;
        }
        for (var item of this.selectDatas) {
          this.selectCounts[item.parent.code] += 1;
        }

        this.renderSelect();
      },
      renderSelect () {
        for (var i = 0; i < this.listData.length; i++) {
          for (var j = 0; j < this.listData[i].children.length; j++) {
            var index = this.selectCodes.indexOf(this.listData[i].children[j].code);
            if (index > -1) {
              this.listData[i].children[j].color = '#FFD60C';
              this.$forceUpdate();
            } else {
              this.listData[i].children[j].color = '#ffffff';
              this.$forceUpdate();
            }
          }
        }
      }
    },
    watch: {
      'listData': function (n, o) {
        this.init();
      },
      'selectDatas': function (n, o) {
        for (var data of this.listData) {
          this.selectCounts[data.code] = 0;
        }

        for (var item of this.selectDatas) {
          this.selectCounts[item.parent.code] += 1;
        }
      }
    },
    data () {
      return {
        activeName: '',
        activeColor: '',
        selectCodes: [],
        selectCounts: {}
      }
    },
    created () {
    }
  }
</script>

<style>
  .category-select .el-tabs__item is-top is-active{
    color: #FFD60C;
  }

  .category-select .tab-pane-span-class{
    padding: 5px 10px;
    margin-right: 20px;
    background-color: #FFD60C;
    border-radius: 8px;
  }

  .category-select .el-tag{
    border-color: #FFffff;
  }

  .elTagClass{
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor:pointer;
  }

  .category-select .el-badge__content.is-fixed{
    top:18px;
    right:0px;
    line-height: 16px;
  }
</style>
