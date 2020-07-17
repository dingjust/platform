<template>
  <div>
    <div class="container-border">
      <el-row type="flex" justify="space-between" :gutter="20">
        <el-col :span="12">
          <el-row type="flex" justify="start">
            <h6>下单数量</h6>
          </el-row>
          <color-size-table :data="formData.colorSizeEntries" :readOnly="true" />
        </el-col>
        <el-col :span="12">
          <el-row type="flex" justify="start">
            <h6>实收数量</h6>
          </el-row>
          <color-size-table :data="cropColorSizeEntry" :readOnly="true" />
        </el-col>
      </el-row>
    </div>
    <el-row type="flex" justify="end" align="middle" style="margin-top: 20px">
      <el-col :span="4">
        <h6>订单总额：20000000.00</h6>
      </el-col>
      <el-col :span="4">
        <h6>实收总额：20000000.00</h6>
      </el-col>
      <el-col :span="4">
        <h6>累计扣款：20000000.00</h6>
      </el-col>
      <el-col :span="4">
        <h6>累计增款：20000000.00</h6>
      </el-col>
      <el-col :span="4">
        <h6>实付总额：20000000.00</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    ColorSizeTable
  } from '@/components/'
  export default {
    name: 'ReconciliationTasksQuantityTable',
    props: ['formData'],
    components: {
      ColorSizeTable
    },
    computed: {
      // 处理裁剪数量数据
      cropColorSizeEntry: function () {
        if (this.formData.colorSizeEntries != null) {
          let result = this.formData.colorSizeEntries.map(entry => {
            let quantity = this.getEntryFromActualNum(entry.color.name, entry.size.name);
            let color = Object.assign({}, entry.color);
            let size = Object.assign({}, entry.size);
            return {
              color: color,
              size: size,
              quantity: quantity
            };
          });
          return result;
        } else {
          return [];
        }
      },
    },
    methods: {
      //获取实裁数量entry（报单行color,size是Sring类型）
      getEntryFromActualNum(colorName, sizeName) {
        let num = 0;
        if (this.formData.actualCutEntries != null) {
          let index = this.formData.actualCutEntries.findIndex(entry => entry.color == colorName && entry.size ==
            sizeName);
          if (index != -1) {
            let entryQuantity = parseInt(this.formData.actualCutEntries[index].quantity);
            if (!Number.isNaN(entryQuantity)) {
              num += entryQuantity;
            }
          }
        }
        return num;
      }
    },
    data() {
      return {}
    },
    created() {},
    destroyed() {

    }
  }

</script>

<style scoped>
  .container-border {
    border: 2px solid #E5E5E5;
    border-radius: 5px;
    padding: 20px 20px 0px 20px;
  }

</style>
