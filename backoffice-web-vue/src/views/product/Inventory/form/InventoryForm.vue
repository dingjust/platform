<!--
* @Description: 库存产品表单
* @Date 2021/09/29 16:54
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card v-if="detail" class="inventory-form">
      <el-row>
        <div class="orders-list-title">
          <h6>库存修改</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-form :model="detail" label-width="6em">
        <el-form-item label="款号">
          <el-row type="flex" align="center" style="font-size: 14px;color: #606266;">{{detail.skuID}}</el-row>
        </el-form-item>
        <el-form-item label="品类">
          <el-cascader v-model="category" :options="categories" filterable :props="{ value: 'code', label: 'name' }"/>
        </el-form-item>
        <el-form-item label="主图">
          <images-upload :slot-data="detail.images" :limit="5">
            <template slot="picBtn">
              <h6>大小不超过5M/张，且最多5张主图</h6>
            </template>
          </images-upload>
        </el-form-item>
        <el-form-item label="">
          <el-table :data="detail.variants">
            <el-table-column label="款号" prop="skuID" />
            <el-table-column label="颜色">
              <template slot-scope="scope">
                <el-input v-model="scope.row.color.name" placeholder=""></el-input>
              </template>
            </el-table-column>
            <el-table-column label="尺码">
              <template slot-scope="scope">
                <el-input v-model="scope.row.size.name" placeholder=""></el-input>
              </template>
            </el-table-column>
            <el-table-column label="数量" prop="quality">
              <template slot-scope="scope">
                <el-input v-model="scope.row.quality" placeholder=""></el-input>
              </template>
            </el-table-column>
          </el-table>
        </el-form-item>
      </el-form>
      <el-row type="flex" justify="center" align="center">
        <el-button type="primary" @click="onModify">修改</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import { ImagesUpload } from '@/components'

export default {
  name: 'InventoryForm',
  components: { ImagesUpload },
  props: ['id'],
  methods: {
    async getDetail () {
      const url = this.apis().getInventory(this.id)
      const result = await this.$http.get(url)

      if (result.code === 1) {
        result.data.variants.forEach(item => {
          if (!item.color) {
            this.$set(item, 'color', {})
          }
          if (!item.size) {
            this.$set(item, 'size', {})
          }
        })
        this.$set(this, 'detail', result.data)

        if (result.data.category && result.data.category.parent) {
          this.$set(this, 'category', [result.data.category.parent.code, result.data.category.code])
        }
      }
    },
    async getCategories () {
      const url = this.apis().getMinorCategories();
      const result = await this.$http.get(url);
      if (result['errors']) {
        return;
      }
      this.categories = result;
    },
    async onModify () {
      if (this.category) {
        this.detail.category = {
          code: this.category[1]
        }
      }

      const url = this.apis().updateInventory(this.detail.id)
      const result = await this.$http.put(url, this.detail)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.$router.go(-1)
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.error('操作失败！')
      }
    }
  },
  data () {
    return {
      detail: null,
      categories: [],
      category: null
    }
  },
  created () {
    this.getDetail()
    this.getCategories()
  }
}
</script>

<style scoped>
  .inventory-form >>> .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .inventory-form >>> .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .inventory-form >>> .el-table--enable-row-hover .el-table__body tr:hover > td {
    background-color: #FFFFFF !important;
  }
</style>