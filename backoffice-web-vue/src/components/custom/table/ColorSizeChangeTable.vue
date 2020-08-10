<!-- 
 * @description: 颜色尺码变动表
 * @fileName: ColorSizeChangeTable.vue 
 * @author: yj 
 * @date: 2020-06-24 13:53:11
 * @version: V1.0.0 
!-->
<template>
  <div class="table-container">
    <table cellspacing="2" width="100%" class="order-table">
      <tr class="order-table-th_row">
        <th style="width: 60px">颜色/尺码</th>
        <template v-for="size in sizes">
          <th :key="size.name">{{size.name}}</th>
        </template>
        <th>合计</th>
      </tr>
      <template v-for="color in colors">
        <tr :key="'tr'+color.code">
          <td>{{color.name}}</td>
          <template v-for="size in sizes">
            <td :key="'td'+size.name">
              <template v-if="readOnly">
                {{getEntryByColorSize(color, size).quantity}}
              </template>
              <template v-else>
                <span class="order-table-input_prefix">{{getOldEntryByColorSize(color, size).quantity}}<i
                    class="el-icon-plus icon-plus" /></span>
                <el-input class="order-table-input" type="number" @mousewheel.native.prevent :min="0"
                  v-number-input.float="{ min: 0,decimal:0}" :disabled="readOnly"
                  v-model="getEntryByColorSize(color, size).quantity">
                </el-input>
              </template>
            </td>
          </template>
          <td style="width:100px">{{countColorsAmount(color)}}</td>
        </tr>
      </template>
      <tr>
        <!-- <td :colspan="getColspanLength(sizes.length)">合计</td> -->
        <td>总计</td>
        <template v-for="size in sizes">
          <td :key="'sum'+size.name" :style="tdStyle">{{countSizesAmount(size)}}</td>
        </template>
        <td>{{countTotalAmount(data)}}</td>
      </tr>
    </table>
  </div>
</template>

<script>
  import {
    getSizeSequence
  } from './table'

  export default {
    name: 'ColorSizeChangeTable',
    props: {
      oldData: {
        type: Array,
        default: () => {
          return [];
        }
      },
      data: {
        type: Array,
        default: () => {
          return [];
        }
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      sizes: function () {
        let sizes = [];
        let sizeKeySet = new Set([]);
        this.data.forEach(element => {
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
        this.data.forEach(element => {
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
      }
    },
    methods: {
      //获取收货单颜色尺码对应entry
      getOldEntryByColorSize(color, size) {
        let index = this.oldData.findIndex(entry => entry.color.code == color.code && entry.size.code == size.code);
        if (index != -1) {
          return this.oldData[index];
        }
      },
      //获取颜色尺码对应entry
      getEntryByColorSize(color, size) {
        let index = this.data.findIndex(entry => entry.color.code == color.code && entry.size.code == size.code);
        if (index != -1) {
          return this.data[index];
        }
      },
      countColorsAmount(color) {
        var amount = 0;
        this.data.filter(entry => entry.color.code == color.code).forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      countSizesAmount(size) {
        var amount = 0;
        this.data.filter(entry => entry.size.code == size.code).forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      countTotalAmount(colorSizeEntries) {
        var amount = 0;
        colorSizeEntries.forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      getColspanLength(size) {
        return size + 1;
      },
    },
    created() {},
    data() {
      return {

      }
    }
  }

</script>
<style scoped>
  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;

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


  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.65);
  }

  .order-table-input>>>.el-input__inner {
    width: auto;
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

</style>
