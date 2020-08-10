<template>
  <div class="dept-cascader-container">
    <el-input v-model="showTitle"
            placeholder="请选择"
            :title="showTitle"
            :readonly="true"
            style="width: 194px"
            v-popover:popover>
      <i slot="suffix" :class="suffixIcon" @mouseenter="mouseEnter" @mouseleave="mouseleave" @click="iconClick"></i>
    </el-input>
    <el-popover ref="popover" placement="bottom-start" width="192" trigger="click" 
                @show="popoverShow" 
                @hide="popoverHide">  
      <el-row type="flex" style="padding-top:10px">
        <el-col>
          <dj-select-popover v-if="popoverVisible" :selectData="selectData" :selectedCallBack="selectedCallBack"
                             :keyName="keyName" :options="options" @callback="callback" />
        </el-col>
      </el-row>
    </el-popover>
  </div>
</template>

<script>
/**
 * import { DjMultipleSelect } from '@/components' 
 * @param {Array} [vData]    - 关联数组
 * @param {Array} [options]    - 列表数据
 * @param {String} [keyName]    - 判断选项唯一的字段名
 * @param {Function} [selectedCallBack]     - 回显函数，返回需要回显的数组
 */
import DjSelectPopover from './DjSelectPopover'
export default {
  name: 'DjMultipleSelect',
  props: {
    vSelectData: {
      type: Array,
      default: () => []
    },
    options: {
      type: Array,
      default: () => []
    },
    keyName: {
      type: String,
      default: 'id'
    },
    selectedCallBack:{
      type:Function,
      default:()=>{
        return [];
      }
    }
  },
  computed: {
  },
  components: {
    DjSelectPopover
  },
  methods: {
    iconClick () {
      if (this.suffixIcon === 'el-icon-circle-close' && this.showTitle && this.showTitle != '') {
        this.selectData = [];
        this.showTitle = '';
        this.suffixIcon = 'el-icon-arrow-down'
      }
      if (!this.popoverVisible) {
        //如果提供了事件对象，则这是一个非IE浏览器 
        if (event && event.stopPropagation) {
          //因此它支持W3C的stopPropagation()方法 
          event.stopPropagation();
        } else {
          //否则，我们需要使用IE的方式来取消事件冒泡 
          window.event.cancelBubble = true;
        }
      }
    },
    popoverShow () {
      this.popoverVisible = true;
      this.suffixIcon = 'el-icon-arrow-up';
    },
    popoverHide () {
      this.popoverVisible = false;
      this.suffixIcon = 'el-icon-arrow-down';
    },
    mouseEnter () {
      if (this.showTitle && this.showTitle != '') {
        this.suffixIcon = 'el-icon-circle-close';
      }
    },
    mouseleave () {
      if (this.popoverVisible) {
        this.suffixIcon = 'el-icon-arrow-up';
      } else {
        this.suffixIcon = 'el-icon-arrow-down';
      }
    },
    callback (selectData) {
      let str = '';
      selectData.forEach((item, index) => {
        str += item.name;
        if (index !== selectData.length - 1) {
          str += ' / ';
        }
      })
      this.showTitle = str;
    }
  },
  watch: {
    vSelectData: function (newVal, oldVal) {
      this.selectData = newVal;
    },
    selectData: function (newVal, oldVal) {
      this.$emit('update:vSelectData', newVal);
    }
  },
  data () {
    return {
      suffixIcon: 'el-icon-arrow-down',
      showTitle: '',
      bingData: [],
      selectData: [],
      popoverVisible: false
    }
  },
  created () {
    if(this.vSelectData){
     this.selectData= this.selectedCallBack();
     this.callback(this.selectData);
    }
  }
}
</script>

<style scoped>
</style>