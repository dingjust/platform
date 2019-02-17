<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :rules="rules"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="发料单号" prop="code">
            <el-input v-model="slotData.code" disabled placeholder="系统自动生成"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="生产单号" prop="order">
            <el-select placeholder="请输入订单编号查询" style="width: 100%"
                       filterable remote reserve-keyword v-model="slotData.order.code"
                       :remote-method="onFilter" @change="onOrderSelected">
              <el-option v-for="item in orders" :key="item.code" :label="item.code" :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'PickOrderBaseForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate() {
        if (this.slotData.order.code == null || this.slotData.order.code == '') {
          this.$message.error('参考订单不允许为空');
          return false;
        } else {
          return true;
        }
      },
      getValue() {
        return this.slotData;
      },
      onOrderSelected(current) {
        const slotData = this.slotData;
        this.orders.filter(value => {
          return current === value.code;
        }).forEach(order => {
          this.showDetails = true;
          this.order = order;
          this.$set(slotData, 'order', order);
        });
      },
      async onFilter(query) {
        this.orders = [];
        if (query !== '') {
          const result = await this.$http.get('/djfactory/consignment', {
            text: query
          });

          if (result["errors"]) {
            this.$message.error(result["errors"][0].message);
            return;
          }

          this.orders = result.content;
        }
      }
    },
    computed: {},
    data() {
      return {
        active: 0,
        order: {},
        orders: [],
        rules: {
          order: [{required: true, message: '必填', trigger: 'blur'}]
        }
      }
    }
  }
</script>
