<template>
  <div class="animated fadeIn enum-select">
    <el-row type="flex" >
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane v-for="(values, key) in mapData" :label="key" :name="key" >
          <span slot="label" v-if="mapSelectData[key].length > 0">
             <el-badge :value="mapSelectData[key].length" class="item">
               {{key}}
             </el-badge>
          </span>
          <el-tag
            v-for="val of values"
            class="elTagClass"
            :color="isSelected(val) ? '#FFD60C' : '#ffffff'"
            @click="handleTagClick(key,val)"
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
    name: 'EnumSelect',
    props: ['mapData', 'mapSelectData'],
    computed: {
    },
    methods: {
      handleClick (tab, event) {
        console.log(tab, event);
      },
      handleTagClick (key,val) {
        console.log(key);
        var mapIndex = this.mapSelectData[key].indexOf(val.code);
        if (mapIndex > -1) {
          this.mapSelectData[key].splice(mapIndex, 1);
        } else {
          this.mapSelectData[key].push(val.code);
        }

        var index = this.selectCodes.indexOf(val.code);
        if (index > -1) {
          this.selectCodes.splice(index, 1);
        } else {
          this.selectCodes.push(val.code);
        }
      },
      isSelected (item) {
        var index = this.selectCodes.indexOf(item.code);
        if (index > -1) {
          return true;
        } else {
          return false;
        }
      },
    },
    data () {
      return {
        activeName: '',
        activeColor: '',
        selectCodes: []
      }
    },
    created () {
      // 设置tab初始值
      for (var key in this.mapData) {
        this.activeName = key;
        break;
      }

      for (let key in this.mapSelectData) {
        for (var value of this.mapSelectData[key]) {
          this.selectCodes.push(value);
        }
      }

    }
  }
</script>

<style>
  .enum-select .el-tabs__item is-top is-active{
    color: #FFD60C;
  }

  .enum-select .tab-pane-span-class{
    padding: 5px 10px;
    margin-right: 20px;
    background-color: #FFD60C;
    border-radius: 8px;
  }

  .enum-select .el-tag{
    border-color: #FFffff;
  }

  .enum-select .elTagClass{
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor:pointer;
  }

  .enum-select .el-badge__content.is-fixed{
    top:18px;
    right:0px;
    line-height: 16px;
  }
</style>
