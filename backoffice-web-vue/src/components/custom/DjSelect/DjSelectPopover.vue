<template>
  <el-row type="flex">
    <el-col>
      <div class="out-container"> 
        <div class="inner-container">
          <div class="popover-container">
            <div class="basic-container">
              <template v-for="item in options">
                <el-row type="flex" justify="space-between" align="middle" class="basic-row"
                        :key="item[keyName]" 
                        @click.native="selectRow(item)">
                  <li style="list-style:none;">
                    <span :style="showIcon(item) ? 'color: #409eff' : ''">{{item.name}}</span>
                  </li>
                  <i class="el-icon-check" :style="showIcon(item) ? 'color: #409eff' : ''" v-if="showIcon(item)"></i>
                </el-row>
              </template>
            </div>
          </div>
        </div>
      </div>
    </el-col>
  </el-row>
</template>

<script>
export default {
  name: 'CustomizePopover',
  props: {
    options: {
      type: Array,
      default: () => []
    },
    selectData: {
      type: Array,
      default: () => []
    },
    keyName: {
      type: String,
      default: 'id'
    },
  },
  computed: {
  },
  methods: {
    showIcon (item) {
      return this.selectData.findIndex(val => val[this.keyName] === item[this.keyName]) > -1;
    },
    selectRow (item) {
      let index = this.selectData.findIndex(val => val[this.keyName] === item[this.keyName]);
      if (index < 0) {
        this.selectData.push(item);
      } else {
        this.selectData.splice(index, 1);
      }
      this.$emit('callback', this.selectData);
    }
  },
  data () {
    return {
    }
  }
}
</script>

<style lang="scss" scoped>
  .out-container {
    width: 192px;
    overflow: hidden;
    margin: -12px;

    .inner-container {
      width: 207px;
      margin-right: -17px;
      overflow: scroll;
      margin-bottom: -17px;
    
      .popover-container {
        height: 204px;
        margin-bottom: -17px;
        margin-right: -17px;
    
        .basic-container {
          width: 192px;
          .basic-row {
            height: 34px;
            padding: 0 20px;

            .basic-row-h6 {
              white-space: nowrap;
              overflow: hidden;
              text-overflow: ellipsis;
              width: 140px;
              margin-bottom: 0px;
              color: #606266;
              font-size: 14px;
            }
          }
          .basic-row:hover {
            background: #f5f7fa;
          }
        }
      }
    }
  }
</style>