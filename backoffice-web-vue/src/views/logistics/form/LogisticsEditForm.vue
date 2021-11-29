<!--
* @Description: 物流单号编辑表单
* @Date 2021/11/29 11:29
* @Author L.G.Y
-->
<template>
  <div v-if="form">
    <el-form :model="form" :inline="true" label-position="left" label-width="6em">
      <el-form-item label="换货编号">
        <el-input v-model="form.relationCode"></el-input>
      </el-form-item>
      <el-form-item label="快递类型">
        <el-select v-model="form.type">
          <el-option v-for="item in ExpressType" :key="item.code" :label="item.name" :value="item.code" />
        </el-select>
      </el-form-item>
      <el-form-item label="款号">
        <el-input v-model="form.skuID"></el-input>
      </el-form-item>
      <el-form-item label="产品名称">
        <el-input v-model="form.productName"></el-input>
      </el-form-item>
      <el-form-item label="颜色">
        <el-select v-model="form.colors" multiple filterable allow-create default-first-option >
          <el-option v-for="item in colorOptions" :key="item" :label="item" :value="item" />
        </el-select>
      </el-form-item>
      <el-form-item label="尺码">
        <el-select v-model="form.sizes" multiple filterable allow-create default-first-option >
          <el-option v-for="item in sizeOptions" :key="item" :label="item" :value="item" />
        </el-select>
      </el-form-item>
      <el-form-item label="质量问题">
        <el-select v-model="form.defected">
          <el-option label="有" :value="true"></el-option>
          <el-option label="无" :value="false"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="备注">
        <el-input v-model="form.remarks"></el-input>
      </el-form-item>
    </el-form>
    <el-row type="flex" justify="end">
      <el-button type="default" @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onConfirm">确定</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'LogisticsEditForm',
  props: ['handleRow'],
  methods: {
    onCancel () {
      this.$emit('closeDialog')
    },
    onConfirm () {
      this.$confirm('是否提交编辑数据?', '提示', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onConfirm()
      });
    },
    async _onConfirm () {
      const form = this.form

      const url = this.apis().createLogistics()
      const result = await this.$http.post(url, form)

      if (result.code === 1) {
        this.$message.success('操作成功')
        this.$emit('callback')
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.error('操作失败')
      }
    }
  },
  data () {
    return {
      form: null,
      ExpressType: [
        {
          code: 'RETURNED',
          name: '退货'
        },
        {
          code: 'EXCHANGED',
          name: '换货'
        }
      ],
      colorOptions: ['白色', '绿色', '紫色', '红色', '粉红', '金色'],
      sizeOptions: ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL', 'XXXXXL']
    }
  },
  created () {
    if (this.handleRow) {
      this.form = JSON.parse(JSON.stringify(this.handleRow))
    }
  }
}
</script>

<style>

</style>