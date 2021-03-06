<!-- 
 * @description: 颜色尺码箱变动表
 * @fileName: ColorSizeBoxChangeTable.vue 
 * @author: yj 
 * @date: 2020-06-23 18:34:09
 * @version: V1.0.0 
!-->
<template>
  <div class="table-container">
    <div class="table-box">
      <table cellspacing="2" width="100%" class="order-table">
        <tr class="order-table-th_row">
          <th style="width: 100px">箱号</th>
          <th style="width: 60px">颜色/尺码</th>
          <template v-for="size in sizes">
            <th :key="size.name">{{size.name}}</th>
          </template>
          <th>数量小计</th>
          <th>合计</th>
        </tr>
        <template v-for="(entry,entryIndex) in data">
          <template v-for="(color,colorIndex) in colors">
            <tr :key="'entry'+entryIndex+'color'+colorIndex"
              v-if="readOnly?countColorsAmount(color,entryIndex)!=0:true">
              <td v-if="colorIndex==0" :rowspan="getRowspanLength(entryIndex)">
                <el-row type="flex" justify="center">
                  <div class="index-container">
                    <el-row type="flex" justify="center" align="middle">
                      <h6 style="padding-top:5px">{{entryIndex+1}}</h6>
                    </el-row>
                  </div>
                </el-row>
              </td>
              <td>{{color.name}}</td>
              <template v-for="size in sizes">
                <td :key="'td'+size.name">
                  <template v-if="readOnly">
                    {{getEntryByColorSize(color, size,entryIndex).quantity}}
                  </template>
                  <template v-else>
                    <span class="order-table-input_prefix">{{getOldEntryByColorSize(color, size,entryIndex).quantity}}<i
                        class="el-icon-plus icon-plus" /></span>
                    <el-input class="order-table-input" type="number" @mousewheel.native.prevent :min="0"
                      v-number-input.float="{ min: 0,decimal:0}" :disabled="readOnly"
                      v-model="getEntryByColorSize(color, size,entryIndex).quantity">
                    </el-input>
                  </template>
                </td>
              </template>
              <td style="width:100px" class="grey-td">
                {{countColorsAmount(color,entryIndex)}}
              </td>
              <td v-if="colorIndex==0" :rowspan="colors.length" style="width:100px">
                {{countEntryAmount(entryIndex)}}
              </td>
            </tr>
          </template>
        </template>
        <tr>
          <td :colspan="2" class="end-td grey-td">总计</td>
          <td :colspan="sizes.length+2" class="end-td grey-td">{{countTotalAmount}}</td>
        </tr>
      </table>
    </div>
    <el-row type="flex" justify="space-around" align="middle" style="margin-top:10px">
      <h6>总箱数：{{data.length}}</h6>
      <h6>总件数：{{countTotalAmount}}</h6>
    </el-row>
  </div>
</template>

<script>
  import {
    getSizeSequence
  } from '@/store/modules/shared'

  export default {
    name: 'ColorSizeBoxChangeTable',
    props: {
      oldData: {
        type: Array,
        default: () => {
          return [];
        }
      },
      vdata: {
        type: Array,
        default: () => {
          return [];
        }
      },
      colorSizeEntries: {
        type: Array,
        required: true,
        default: () => {
          return [];
        }
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      //是否隐藏数量为0的颜色行
      hideEmptyColors: {
        type: Boolean,
        default: true
      }
    },
    computed: {
      sizes: function () {
        let sizes = [];
        let sizeKeySet = new Set([]);
        this.colorSizeEntries.forEach(element => {
          if (!sizeKeySet.has(element.size.code)) {
            sizes.push(element.size);
            sizeKeySet.add(element.size.code);
          }
        });
        //排序
        sizes.sort((o1, o2) => {
          let o1Sequence = getSizeSequence(o1.code);
          let o2Sequence = getSizeSequence(o2.code);
          if (o1Sequence && o2Sequence) {
            return o1Sequence - o2Sequence;
          } else if (o1Sequence && !o2Sequence) {
            return -1;
          } else if (!o1Sequence && o2Sequence) {
            return 1;
          } else {
            return -1;
          }
        });
        return sizes;
      },
      colors: function () {
        let colors = [];
        let colorKeySet = new Set([]);
        this.colorSizeEntries.filter(entry => this.hideEmptyColors ? entry.quantity > 0 : true).forEach(element => {
          if (!colorKeySet.has(element.color.code)) {
            colors.push(element.color);
            colorKeySet.add(element.color.code);
          }
        });
        return colors;
      },
      tdStyle: function () {
        if (!this.readOnly) {
          return {
            'padding-right': '15px'
          };
        } else {
          return {};
        }
      },
      //总数
      countTotalAmount: function () {
        var amount = 0;
        this.data.forEach(entry => {
          if (entry != null) {
            entry.colorSizeEntries.forEach(item => {
              let num = parseFloat(item.quantity);
              if (!Number.isNaN(num)) {
                amount += num;
              }
            });
          }
        });
        return amount;
      },
    },
    methods: {
      //获取收货单颜色尺码对应entry
      getOldEntryByColorSize(color, size, entryIndex) {
        let index = this.oldData[entryIndex].colorSizeEntries.findIndex(entry => entry.color.code == color.code && entry
          .size.code ==
          size
          .code);
        if (index != -1) {
          return this.oldData[entryIndex].colorSizeEntries[index];
        } else {
          return {
            quantity: ''
          };
        }
      },
      //获取颜色尺码对应entry
      getEntryByColorSize(color, size, entryIndex) {
        let index = this.data[entryIndex].colorSizeEntries.findIndex(entry => entry.color.code == color.code && entry
          .size.code == size
          .code);
        if (index != -1) {
          return this.data[entryIndex].colorSizeEntries[index];
        } else {
          return {
            quantity: ''
          };
        }
      },
      countColorsAmount(color, entryIndex) {
        var amount = 0;
        if (this.data != null) {
          this.data[entryIndex].colorSizeEntries.filter(entry => entry.color.code == color.code).forEach(entry => {
            let num = parseFloat(entry.quantity);
            if (!Number.isNaN(num)) {
              amount += num;
            }
          });
        }
        return amount;
      },
      countSizesAmount(size) {
        var amount = 0;
        if (this.data != null) {
          this.data.filter(entry => entry.size.code == size.code).forEach(entry => {
            let num = parseFloat(entry.quantity);
            if (!Number.isNaN(num)) {
              amount += num;
            }
          });
        }
        return amount;
      },
      countEntryAmount(index) {
        var amount = 0;
        if (this.data[index] != null) {
          this.data[index].colorSizeEntries.forEach(entry => {
            let num = parseFloat(entry.quantity);
            if (!Number.isNaN(num)) {
              amount += num;
            }
          });
        }
        return amount;
      },
      getColspanLength(size) {
        return size + 1;
      },
      //计算行合并值
      getRowspanLength(index) {
        //若只读则省略合计为0的颜色行
        if (this.readOnly) {
          //先计算该entry忽略颜色行的值
          let num = 0;
          this.colors.forEach(color => {
            if (this.countColorsAmount(color, index) == 0) {
              num++;
            }
          });
          return this.colors.length - num;
        } else {
          return this.colors.length;
        }
      },
    },
    created() {
      if (this.vdata.length != 0) {
        Object.assign(this.data, this.vdata);
      }
    },
    watch: {
      data: function (newVal, oldVal) {
        this.$emit("update:vdata", newVal);
      },
      vdata: function (newVal, oldVal) {
        this.data = newVal;
      },
    },
    data() {
      return {
        data: []
      }
    }
  }

</script>
<style scoped>
  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 2px;
    white-space: nowrap;
    overflow: hidden;
    overflow-x: scroll;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }


  .order-table tr td {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.65);
  }

  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
    background: rgba(247, 247, 247, 1);
  }

  .add_btn {
    width: 100%;
    height: 50px;
    line-height: 50px;
    border: 0.5px dashed rgba(0, 0, 0, 0.15);
    text-align: center;
    align-content: center;
    color: rgba(0, 0, 0, 0.65);
  }

  .add_btn:hover {
    background: rgba(247, 247, 247, 1);
    cursor: pointer;
  }

  .index-container {
    border-radius: 30px;
    width: 30px;
    height: 30px;
    text-align: center;
    align-content: center;
    /* padding: 10px; */
    border: 1px solid rgba(0, 0, 0, 0.5);
  }

  .grey-td {
    background: rgba(247, 247, 247, 1);
  }

  .end-td {
    height: 50px;
  }

  .order-table-input>>>.el-input__inner {
    width: 80px;
    border: 0px solid #fff;
    /* padding: 0px; */
    text-align: start;
  }

  .table-container>>>.el-input {
    /* width: unset !important; */
    width: min-content;
  }

  .order-table-input>>>.el-input__prefix {
    /* left: 30%; */
    top: 16%;
    text-align: center;
    -webkit-transition: all .3s;
    transition: all .3s;
    font-size: 14px;
  }

  .order-table-input_prefix {
    margin-left: 20px;
  }

  .icon-plus {
    color: red;
    margin-left: 10px;
  }

  .table-box {
    overflow-x: scroll;
  }

</style>
