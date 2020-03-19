<template>
  <div>
    <el-table :data="tableData" show-summary style="width: 100%" :summary-method="getSummaries">
      <el-table-column prop="product.skuID" label="货号"></el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product.name}}</span>
              </el-row>
              <el-row>
                <span>颜色：{{scope.row.product.color}} 尺码：{{scope.row.product.size}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column prop="product.price" label="单价（元）"></el-table-column>
      <el-table-column prop="product.num" sortable label="数量（件）"></el-table-column>
      <el-table-column prop="product.totalPrice" sortable label="货品总价（元）"></el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: "OrderRowsTable",
    components: {},
    computed: {},
    methods: {
      getSummaries(param) {
        const {
          columns,
          data
        } = param;
        const sums = [];
        columns.forEach((column, index) => {
          if (index === 0) {
            sums[index] = '总计';
            return;
          }
          var values;
          if (index === 3) {
            values = data.map(item => item.product.num);
          } else if (index === 4) {
            values = data.map(item => item.product.totalPrice);
          } else {
            sums[index] = '';
            return;
          }
          // const values = data.map(item => Number(item[column.property]));
          if (!values.every(value => isNaN(value))) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return prev + curr;
              } else {
                return prev;
              }
            }, 0);
            sums[index] += ' ';
          } else {
            sums[index] = '';
          }
        });

        return sums;
      }
    },
    data() {
      return {
        tableData: [{
          product: {
            skuID: "ASAS11",
            name: '夏季2011裙装阿萨的窘境阿斯顿',
            size: 'S',
            color: '蓝色',
            price: 10,
            num: 200,
            totalPrice: 2000,
            thumbnail: {
              url: "/resource/hf5/h95/8821490221086.jpg"
            },
          },
        }, {
          product: {
            skuID: "ASAS11",
            name: '夏季2011裙装阿萨的窘境阿斯顿',
            size: 'S',
            color: '蓝色',
            price: 10,
            num: 200,
            totalPrice: 2000,
            thumbnail: {
              url: "/resource/hf5/h95/8821490221086.jpg"
            },
          },
        }, {
          product: {
            skuID: "ASAS11",
            name: '夏季2011裙装阿萨的窘境阿斯顿',
            size: 'S',
            color: '蓝色',
            price: 10,
            num: 200,
            totalPrice: 2000,
            thumbnail: {
              url: "/resource/hf5/h95/8821490221086.jpg"
            },
          },
        }, {
          product: {
            skuID: "ASAS11",
            name: '夏季2011裙装阿萨的窘境阿斯顿',
            size: 'S',
            color: '蓝色',
            price: 10,
            num: 200,
            totalPrice: 2000,
            thumbnail: {
              url: "/resource/hf5/h95/8821490221086.jpg"
            },
          },
        }, {
          product: {
            skuID: "ASAS11",
            name: '夏季2011裙装阿萨的窘境阿斯顿',
            size: 'S',
            color: '蓝色',
            price: 10,
            num: 200,
            totalPrice: 2000,
            thumbnail: {
              url: "/resource/hf5/h95/8821490221086.jpg"
            },
          },
        }]
      };
    },
    created() {},
    mounted() {}
  };

</script>
<style>
</style>
