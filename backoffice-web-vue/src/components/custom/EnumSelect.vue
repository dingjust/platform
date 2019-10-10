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
    name: 'EnumSelect',
    props: ['mapData', 'mapSelectData'],
    computed: {
    },
    methods: {
      handleClick (tab, event) {
        console.log(tab, event);
      },
      handleTagClick (val) {
        for (let key in this.mapData) {
          for (var value of this.mapData[key]) {
            if (value.code === val.code) {
              // this.$set(value, 'color', '#FFD60C');
              if (value.color.toLowerCase() === '#ffffff') {
                value.color = '#FFD60C';
                this.$forceUpdate();
                this.mapSelectData[key].push(value.code);
              } else {
                value.color = '#ffffff';
                this.$forceUpdate();
                var index = this.mapSelectData[key].indexOf(value.code);
                if(index > -1){
                  this.mapSelectData[key].splice(index,1);
                }
              }
            }
          }
        }
      }
    },
    data () {
      return {
        activeName: '',
        activeColor: ''
      }
    },
    created () {
      // 设置tab初始值
      for (var key in this.mapData) {
        this.activeName = key;
        break;
      }

      // 初始化数据
      for (let key in this.mapData) {
        for (var value of this.mapData[key]) {
          var index = this.mapSelectData[key].indexOf(value.code);
          if (index > -1) {
            value.color = '#FFD60C';
            this.$forceUpdate();
          } else {
            value.color = '#ffffff';
            this.$forceUpdate();
          }
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
