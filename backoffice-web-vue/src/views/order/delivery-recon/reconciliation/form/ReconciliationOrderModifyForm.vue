<template>
  <div>
    <el-form :model="order">
      <reconciliation-info-table :formData="order" :tableCol="tableCol"/>
      <reconciliation-additional :formData="order"/>
      <el-row type="flex" style="margin-top: 10px">
        <h6 class="title-text">附件</h6>
      </el-row>
      <el-row type="flex" class="basic-container">
        <files-upload ref="filesUpload" :slotData="order.medias" :limit="20"/>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button class="sumbit-btn" @click="onModify">修改</el-button>
    </el-row>
  </div>
</template>

<script>
import ReconciliationInfoTable from './ReconciliationInfoTable'
import ReconciliationAdditional from './ReconciliationAdditional.vue'
import { FilesUpload } from '@/components'

export default {
  name: 'ReconciliationOrderModifyForm',
  props: ['order', 'tableCol'],
  components: {
    ReconciliationInfoTable,
    ReconciliationAdditional,
    FilesUpload
  },
  methods: {
    onModify () {
      if (this.order.entries.some(item => item.product.id === '')) {
        this.$message.error('存在对账内容没有产品，请先进行处理');
        return;
      }

      this.$confirm('是否进行修改操作?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onModify();
      });
    },
    async _onModify () {
      let data = JSON.parse(JSON.stringify(this.order));

      data.entries.forEach(item => {
        item.customColumns = [];
        data.colNames.forEach(val => {
          item.customColumns.push({
            id: item[val.id].id !== '' ? item[val.id].id : null, 
            name: val.value,
            value: item[val.id].value
          })
          this.$delete(item, val.id);
        })

        // 将非必须字段都转换为自定义字段
        for (const key in this.tableCol) {
          const element = this.tableCol[key];
          if (element.have) {
            item.customColumns.push({
              name: element.name,
              value: item[key]
            })
          }
          this.$delete(item, key);
        }
      });

      data.colNames = this.order.colNames.map(item => item.value);

      for (const key in this.tableCol) {
        if (this.tableCol[key].have) {
          data.colNames.push(this.tableCol[key].name);
        }
      }

      const url = this.apis().reconciliationOrderModify();
      const result = await this.$http.put(url, data);

      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('callback', result.data);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    }
  }  
}
</script>

<style scoped>
  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
    width: 80px;
  }

  .basic-container {
    margin: 10px 0px 20px 25px;
  }
</style>