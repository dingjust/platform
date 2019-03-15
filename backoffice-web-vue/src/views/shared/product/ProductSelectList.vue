<template>
  <div class="animated fadeIn">
    <el-table stripe :data="page.content"
              highlight-current-row
              @current-change="handleCurrentChange"
              @selection-change="handleSelectionChange">
      <el-table-column v-if="multipleSelection" type="selection" width="55"></el-table-column>
      <el-table-column label="商品货号" prop="skuID"></el-table-column>
      <el-table-column label="商品名称" prop="name"></el-table-column>
      <el-table-column label="商品价格" prop="price"></el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!--<div class="float-right">
      <el-pagination layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged"
                     :current-page="page.number + 1"
                     :page-size="page.size"
                     :page-count="page.totalPages"
                     :total="page.totalElements">
      </el-pagination>
    </div>-->
  </div>
</template>

<script>
  export default {
    name: 'ProductSelectList',
    props: ['multipleSelection'],
    mixins: [],
    computed: {},
    methods: {
      handleCurrentChange(current) {
        this.value = current;

        this.$emit('onSelected', current);
      },
      handleSelectionChange(current) {
        this.value = current;

        this.$emit('onSelected', current);
      },
      getValue() {
        return this.value;
      }
    },
    data() {
      return {
        value: null,
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [{
            skuID: 'K001',
            name: '样衣1',
            price: 20,
            variants: [
              {
                code: 'P01C01S01',
                name: '',
                color: {
                  code: 'C01',
                  name: '红色'
                },
                size: {
                  code: 'S01',
                  name: 'XXL'
                }
              },
              {
                code: 'P01C01S02',
                name: '',
                color: {
                  code: 'C01',
                  name: '红色'
                },
                size: {
                  code: 'S02',
                  name: 'XXL'
                }
              }
            ]
          }, {
            skuID: 'K002',
            name: '样衣1',
            price: 20,
            variants: [
              {
                code: 'P01C01S01',
                name: '',
                color: {
                  code: 'C01',
                  name: '红色'
                },
                size: {
                  code: 'S01',
                  name: 'XL'
                }
              },
              {
                code: 'P01C01S02',
                name: '',
                color: {
                  code: 'C01',
                  name: '红色'
                },
                size: {
                  code: 'S02',
                  name: 'XXL'
                }
              }
            ]
          }] // 当前页数据
        },
      }
    },
    created() {
    }
  }
</script>
