<template>
  <div>
    <el-row>
      <el-table :data="showTable?colors:colors.slice(0,1)" border style="width: 100%">
        <el-table-column label="颜色">
          <template slot-scope="scope">
            <span>{{scope.row}}</span>
          </template>
        </el-table-column>
        <template v-for="(item,index) in sizes">
          <el-table-column :label="item">
            <template slot-scope="scope">
              <span>{{colorSizeFilter(scope.row,item)}}</span>
            </template>
          </el-table-column>
        </template>
      </el-table>
    </el-row>
    <el-row type="flex" justify="center" align="center" class="orders-info-table-btn">
      <i class="iconfont icon_arrow" v-if="!showTable" @click="onClickShowTable">&#xe714;&nbsp;展开列表</i>
      <i class="iconfont icon_arrow" v-if="showTable" @click="onClickShowTable">&#xe713;&nbsp;收回列表</i>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "OrdersInfoTable",
    props: ['slotData'],
    components: {},
    computed: {
      sizes: function () {
        var sizes = new Set([]);
        this.slotData.forEach(element => {
          sizes.add(element.product.size.name);
        });
        return  Array.from(sizes);
      },
      colors: function () {
        var colors = new Set([]);
        this.slotData.forEach(element => {
          colors.add(element.product.color.name);
        });
        return Array.from(colors);
      },
    },
    methods: {
      onClickShowTable() {
        this.showTable = !this.showTable;
        if (this.tableData.length == 1) {
          this.tableData = this.mockData;
        } else {
          this.tableData = [this.mockData[0]];
        }
      },
      //颜色尺码筛选
      colorSizeFilter(color, size) {
        var result=this.slotData.find(element => element.product.color.name == color && element.product.size.name == size);
        if(result!=null){
        return result.quantity;
        }else{
          return '';
        }
      }
    },
    data() {
      return {
        showTable: false,
        tableData: [],
        previewTableData: [],
        mockData: [{
            'name': '白色',
            size: [{
                'name': 'S',
                'num': 1
              },
              {
                'name': 'M',
                'num': 2
              },
              {
                'name': 'L',
                'num': 3
              },
              {
                'name': 'XL',
                'num': 2
              },
              {
                'name': 'XLL',
                'num': 4
              }
            ]
          },
          {
            'name': '黑色',
            size: [{
                'name': 'S',
                'num': 1
              },
              {
                'name': 'M',
                'num': 2
              },
              {
                'name': 'L',
                'num': 3
              },
              {
                'name': 'XL',
                'num': 2
              },
              {
                'name': 'XLL',
                'num': 4
              }
            ]
          },
          {
            'name': '红色',
            size: [{
                'name': 'S',
                'num': 1
              },
              {
                'name': 'M',
                'num': 2
              },
              {
                'name': 'L',
                'num': 3
              },
              {
                'name': 'XL',
                'num': 2
              },
              {
                'name': 'XLL',
                'num': 4
              }
            ]
          },
          {
            'name': '绿色',
            size: [{
                'name': 'S',
                'num': 1
              },
              {
                'name': 'M',
                'num': 2
              },
              {
                'name': 'L',
                'num': 3
              },
              {
                'name': 'XL',
                'num': 2
              },
              {
                'name': 'XLL',
                'num': 4
              }
            ]
          },
          {
            'name': '白色',
            size: [{
                'name': 'S',
                'num': 1
              },
              {
                'name': 'M',
                'num': 2
              },
              {
                'name': 'L',
                'num': 3
              },
              {
                'name': 'XL',
                'num': 2
              },
              {
                'name': 'XLL',
                'num': 4
              }
            ]
          }
        ],
        tableHead: [],
      };
    },
    created() {
      //表格预览数据（取一行数据）
      // this.previewTableData.push(this.mockData[0]);
      // this.tableData = this.previewTableData;
    }
  };

</script>
<style>
  .icon_arrow {
    font-family: "iconfont" !important;
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

  .orders-info-table-btn {
    margin-top: 20px;
  }

</style>
