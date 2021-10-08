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
        <el-form-item label="标题">
          <el-input v-model="detail.name" style="width: 194px"></el-input>
        </el-form-item>
        <el-form-item label="品牌">
          <el-input v-model="detail.brand" style="width: 194px"></el-input>
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
        <el-row type="flex" justify="end" style="margin-bottom: 10px">
          <el-button type="primary" @click="modifyVisible = true">批量修改价格</el-button>
        </el-row>
        <el-form-item label="">
          <table class="item-table" cellspacing="2">
            <tr>
              <td v-for="(val, index) in tableHeader" :key="index">{{val}}</td>
            </tr>
            <template v-for="(item, index) in detail.variants">
              <tr :key="item.id">
                <td>{{item.skuID}}</td>
                <td>
                  <el-input v-model="item.color.name" />
                </td>
                <td>
                  <el-input v-model="item.size.name" />
                </td>
                <td>
                  <el-input v-model="item.quality">
                    <span slot="suffix">件</span>
                  </el-input>
                </td>
                <td>
                  <el-input v-model="item.defectiveQuality">
                    <span slot="suffix">件</span>
                  </el-input>
                </td>
                <td>
                  <el-input v-model="item.tailQuality">
                    <span slot="suffix">件</span>
                  </el-input>
                </td>
              </tr>
              <tr :key="item.id + '-' + index">
                <td />
                <td />
                <td />
                <td>
                  <el-input v-model="item.price">
                    <span slot="suffix">元 / 件</span>
                  </el-input>
                </td>
                <td>
                  <el-input v-model="item.defectivePrice">
                    <span slot="suffix">元 / 件</span>
                  </el-input>
                </td>
                <td>
                  <el-input v-model="item.tailPrice">
                    <span slot="suffix">元 / 件</span>
                  </el-input>
                </td>
              </tr>
            </template>
          </table>
        </el-form-item>
      </el-form>
      <el-row type="flex" justify="center" align="center">
        <el-button type="primary" @click="onModify">修改</el-button>
      </el-row>
    </el-card>
    <el-dialog title="批量修改价格" :visible.sync="modifyVisible" width="400px" :close-on-click-modal="false">
      <el-input placeholder="请输入批量修改价格" v-model="modifyPrice">
        <el-select v-model="modifyPriceType" slot="prepend" placeholder="请选择" style="min-width: 100px">
          <el-option label="全部" value="ALL"></el-option>
          <el-option label="正品价格" value="price"></el-option>
          <el-option label="次品价格" value="defectivePrice"></el-option>
          <el-option label="尾货价格" value="tailPrice"></el-option>
        </el-select>
      </el-input>
      <el-row type="flex" justify="end" style="margin-top: 20px">
        <el-button type="default" @click="modifyVisible = false">取消</el-button>
        <el-button type="primary" @click="onModifyPrice">确定</el-button>
      </el-row>
    </el-dialog>
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
    },
    onModifyPrice () {
      if (Number.isNaN(Number.parseFloat(this.modifyPrice))) {
        this.$message.error('请输入合法的价格数量')
        return
      }
      if (this.modifyPriceType === 'ALL') {
        this.detail.variants.forEach(item => {
          item.price = this.modifyPrice
          item.defectivePrice = this.modifyPrice
          item.tailPrice = this.modifyPrice
        })
      } else {
        this.detail.variants.forEach(item => {
          item[this.modifyPriceType] = this.modifyPrice
        })
      }

      this.modifyVisible = false
    }
  },
  data () {
    return {
      detail: null,
      categories: [],
      category: null,
      tableHeader: ['款号', '颜色', '尺码', '正品', '次品', '尾货'],
      modifyVisible: false,
      modifyPrice: null,
      modifyPriceType: 'ALL'
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

  .item-table {
    border-right: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
    margin: 0 12px 12px 0;
  }

  .item-table tr td,
  .item-table tr th {
    font-size: 10px;
    height: 4em;
    border-top: 1px solid #DCDFE6;
    border-left: 1px solid #DCDFE6;
    text-align: center;
    min-width: 10em;
  }

  .item-table >>> .el-input__inner {
    border: 0px solid;
  }
</style>