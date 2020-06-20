<!-- 
 * @description: 颜色尺码表-colorSizes
 * @fileName: ColorSizeTable.vue 
 * @author: yj 
 * @date: 2020-06-19 14:04:40
 * @version: V1.0.0 
!-->
<template>
  <div>
    <table cellspacing="2" width="100%" class="order-table">
      <tr class="order-table-th_row">
        <td style="width: 60px">颜色/尺码</td>
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
                <el-input class="order-table-input" type="number" @mousewheel.native.prevent :min="1"
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
  export default {
    name: 'ColorSizeTable',
    props: {
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
      //获取颜色尺码对应entry
      getEntryByColorSize(color, size) {
        let index = this.data.findIndex(entry => entry.color.code == color.code && entry.size.code == size.code);
        if (index != -1) {
          return this.data[index];
        }
        // else {
        //   //没找到，则创建对应对象
        //   var newObj = {
        //     color: color,
        //     size: size,
        //     quantity: '',
        //   };
        //   this.data.push(newObj);
        //   return newObj;
        // }
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
<style>
  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;

    white-space: nowrap;
    overflow: hidden;
    overflow-x: scroll;
  }

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
    padding: 0px;
    text-align: center;
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

</style>
