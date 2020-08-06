<template>
  <div class="table-body">
    <el-row type="flex" justify="space-between" align="middle" style="margin-bottom:20px;">
      <span>{{noteVariantTotal}}/{{orderEntriesTotal}}</span>
    </el-row>
    <table cellspacing="2" width="100%" :height="(colors.length+5)*30" class="order-table">
      <tr class="order-table-th_row">
        <td style="width:40px">颜色</td>
        <template v-for="item in sizes">
          <th :key="item.code">{{item.name}}</th>
        </template>
      </tr>
      <template v-for="(color,colorIndex) in colors">
        <tr :key="colorIndex">
          <td>{{color}}</td>
          <template v-for="(size,sizeIndex) in sizes">
            <td style="width:80px" :key="sizeIndex">{{getVarinatStr(color,size.name)}}</td>
          </template>
        </tr>
      </template>
    </table>
  </div>
</template>

<script>
  import {
    getSizeSequence
  } from '@/components/'

  export default {
    name: 'ProgressReportCommon',
    props: {
      orderEntries: {
        type: Array,
        default: []
      },
      noteEntries: {
        type: Array,
        default: []
      },
      orderEntriesTotal: {
        type: Number,
        default: 0
      },
      readonly: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      sizes: function () {
        var sizes = [];
        this.orderEntries.forEach(element => {
          sizes.push(element.size);
        });
        const res = new Map();
        var result = sizes.filter((size) => !res.has(size.code) && res.set(size.code, 1));
        //排序
        result.sort((o1, o2) => {
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
        return result;      
      },
      colors: function () {
        var colors = new Set([]);
        this.orderEntries.forEach(element => {
          colors.add(element.color.name);
        });
        return colors;
      },
      noteVariantTotal: function () {
        var result = 0;
        this.noteEntries.filter(entry => entry.status == 'PASS').forEach((entry) => {
          entry.entries.forEach(item => {
            if (this.colors.has(item.color)) {
              result += item.quantity;
              var a = [];
            }
          })
        });
        return result;
      }
    },
    methods: {
      getOrderVariant(color, size) {
        var result = this.orderEntries.filter(
          item => item.color.name == color && item.size.name == size
        );
        if (result.length != 0) {
          return result[0].quantity;
        } else {
          return '';
        }
      },
      getNoteVariantSum(color, size) {
        var sum = 0;
        this.noteEntries.filter(entry => entry.status == 'PASS').forEach((entry) => {
          var result = entry.entries.filter(
            item => item.color == color && item.size == size
          );
          if (result.length != 0) {
            sum += result[0].quantity;
          }
        });
        return sum;
      },
      getVarinatStr(color, size) {
        if (this.getOrderVariant(color, size) == '') {
          if (this.getNoteVariantSum(color, size) != 0) {
            return '+' + this.getNoteVariantSum(color, size);
          } else {
            return '';
          }
        } else {
          return this.getNoteVariantSum(color, size) + '/' + this.getOrderVariant(color, size);
        }
      },
      onOrder() {
        this.$emit('onOrder')
      }
    },
    created() {},
    data() {
      return {

      }
    }
  }

</script>
<style scoped>
  .table-body {
    width: 100%;
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
  }

  /* .order-table-th_row {
    height: 80px;
  } */

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
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

  .order-table-btn_add {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
  }

</style>
