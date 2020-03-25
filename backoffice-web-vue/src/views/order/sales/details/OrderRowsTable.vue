<template>
  <div>
    <el-table :data="slotData.entries" show-summary style="width: 100%" :summary-method="getSummaries">
      <el-table-column label="货号">
        <template slot-scope="scope">
          <span>{{scope.row.product.baseProductDetail.skuID}}</span>
        </template>
      </el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
<!--              <img width="54px" v-if="scope.row.product!=null" height="54px"-->
<!--                :src="scope.row.product.images!=null&&scope.row.product.images.length!=0?scope.row.product.images.url:'static/img/nopicture.png'" />-->
              <img width="54px" v-if="scope.row.product.baseProductDetail !=null" height="54px"
                   :src="scope.row.product.baseProductDetail.images != null && scope.row.product.baseProductDetail.images.length != 0 ?
                      scope.row.product.baseProductDetail.images[0].url : 'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product.baseProductDetail.name}}</span>
              </el-row>
              <el-row>
                <span>颜色：{{scope.row.product.color.name}}</span>
                <span style="margin-left: 10px">尺码：{{scope.row.product.size.name}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column prop="basePrice" label="单价（元）"></el-table-column>
      <el-table-column prop="quantity" sortable label="数量（件）"></el-table-column>
      <el-table-column prop="totalPrice" sortable label="货品总价（元）"></el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'OrderRowsTable',
    components: {},
    props: ['slotData'],
    computed: {
    },
    methods: {
      getSummaries (param) {
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
            values = data.map(item => item.quantity);
          } else if (index === 4) {
            values = data.map(item => item.totalPrice);
          } else {
            sums[index] = '';
            return;
          }
          // const values = data.map(item => Number(item[column.property]));
          if (!values.every(value => isNaN(value))) {
            sums[index] = values.reduce((prev, curr) => {
              const value = Number(curr);
              if (!isNaN(value)) {
                return (prev * 1000 + curr * 1000) / 1000;
              } else {
                return prev;
              }
            }, 0);
            sums[index] = sums[index];
            sums[index] += ' ';
          } else {
            sums[index] = '';
          }
        });
        this.$emit('summary', sums[sums.length - 1]);
        return sums;
      }
    },
    data () {
      return {
        tableData: []
        // tableData: [{
        //   product: {
        //     skuID: 'ASAS11',
        //     name: '夏季2011裙装阿萨的窘境阿斯顿',
        //     size: 'S',
        //     color: '蓝色',
        //     price: 10,
        //     num: 200,
        //     totalPrice: 2000,
        //     thumbnail: {
        //       url: '/resource/hf5/h95/8821490221086.jpg'
        //     }
        //   }
        // }, {
        //   product: {
        //     skuID: 'ASAS11',
        //     name: '夏季2011裙装阿萨的窘境阿斯顿',
        //     size: 'S',
        //     color: '蓝色',
        //     price: 10,
        //     num: 200,
        //     totalPrice: 2000,
        //     thumbnail: {
        //       url: '/resource/hf5/h95/8821490221086.jpg'
        //     }
        //   }
        // }, {
        //   product: {
        //     skuID: 'ASAS11',
        //     name: '夏季2011裙装阿萨的窘境阿斯顿',
        //     size: 'S',
        //     color: '蓝色',
        //     price: 10,
        //     num: 200,
        //     totalPrice: 2000,
        //     thumbnail: {
        //       url: '/resource/hf5/h95/8821490221086.jpg'
        //     }
        //   }
        // }, {
        //   product: {
        //     skuID: 'ASAS11',
        //     name: '夏季2011裙装阿萨的窘境阿斯顿',
        //     size: 'S',
        //     color: '蓝色',
        //     price: 10,
        //     num: 200,
        //     totalPrice: 2000,
        //     thumbnail: {
        //       url: '/resource/hf5/h95/8821490221086.jpg'
        //     }
        //   }
        // }, {
        //   product: {
        //     skuID: 'ASAS11',
        //     name: '夏季2011裙装阿萨的窘境阿斯顿',
        //     size: 'S',
        //     color: '蓝色',
        //     price: 10,
        //     num: 200,
        //     totalPrice: 2000,
        //     thumbnail: {
        //       url: '/resource/hf5/h95/8821490221086.jpg'
        //     }
        //   }
        // }]
      };
    },
    created () {
    },
    mounted () {
    }
  };
</script>
<style>
</style>
