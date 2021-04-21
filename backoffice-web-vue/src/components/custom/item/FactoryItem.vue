<template>
  <div class="animated fadeIn requirement-factory-item">
    <el-row type="flex"  align="middle">
      <el-col :span="22">
        <el-row type="flex" justify="space-between" style="width: 100%">
          <el-col :span="12" style="margin-bottom: 8px"><h6>{{slotData.name}}</h6></el-col>
          <el-tag v-for="(label, index) of slotData.labels" :key="index"
                  style="padding: 0px 8px;height: 16px;line-height: 12px;margin-right: 5px;font-size: 10px;">
            {{label.name}}
          </el-tag>
        </el-row>
        <el-row type="flex" style="width: 100%">
          <el-col :span="4">
            <img :src="slotData.profilePicture ? slotData.profilePicture.url : 'static/img/nopicture.png'" style="width: 60px;height: 60px;border-radius: 8px;"/>
          </el-col>
          <el-col :span="20">
            <el-row type="flex">
              <el-col :span="8">
                <h6 v-if="slotData.populationScale" style="color: #c8c8c8">
                {{getEnum('populationScales',slotData.populationScale)}}
                </h6>
              </el-col>
              <el-col :span="6"><h6>已接<span style="color: red">{{slotData.historyOrdersCount ? slotData.historyOrdersCount : 0}}</span>单</h6></el-col>
              <el-col :span="10">
                <el-row type="flex">
                  <h6><el-rate style="font-size: 15px"
                    :value="slotData.starLevel"
                    disabled
                    :colors="starColors"
                    disabled-void-color="#D3D3D3">
                  </el-rate></h6>
                </el-row>
              </el-col>
            </el-row>
            <el-row type="flex">
              <h6 style="color: #c8c8c8">{{categories}}</h6>
            </el-row>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="2">
        <el-row type="flex" align="middle" v-if="!isSelect">
          <el-tag
            :title="selectedTip"
            v-if="isSelected"
            class="hook" style="cursor: not-allowed">
          </el-tag>
          <el-tag
            @click="handleFactorySelectionChange(slotData)"
            style="border-radius: 50%;width: 30px;background-color: white;height: 30px;cursor: pointer;border: 1px solid #c8c8c8"
            v-else>
          </el-tag>
        </el-row>
        <el-row type="flex" align="middle" v-else>
          <el-tag
            @click="handleFactorySelectionChange(slotData)"
            class="cha">
          </el-tag>
        </el-row>

      </el-col>
    </el-row>

    <!--<div title="Tooltip text for first div">啊啊啊</div>-->
    <!--<div title="Tooltip text for second div">哈哈哈</div>-->
  </div>
</template>

<script>
  export default {
    name: 'FactoryItem',
    props: {
      slotData:{
        type: Object
      },
      isSelected: {
        type: Boolean,
        default: false
      },
      isSelect:{
        type: Boolean,
        default: false
      },
      selectedTip: {
        type: String,
        default: '该工厂已选择'
      }
    },
    computed: {
      categories: function () {
        var text = '';
        for (var item of this.slotData.adeptAtCategories) {
          text += item.name;
          text += '\xa0\xa0';
        }
        return text;
      }
    },
    methods: {
      handleFactorySelectionChange (data) {
        this.$emit('handleFactorySelectionChange', data);
      }
    },
    data () {
      return {
        starColors: ['#FFD60C', '#FFD60C', '#FFD60C']
      }
    }
  }
</script>

<style>
  .requirement-factory-item .el-rate__icon{
    margin-right: 3px;
  }

  el-tag:before{ content:attr(title); display:none; }
  el-tag:hover::before{
    width:200px;
    display:block;
    background:yellow;
    border:1px solid black;
    padding:8px;
    margin:25px 0 0 10px;
    position:absolute;
  }
  el-tag:hover{ z-index:10; position:relative; }
</style>
