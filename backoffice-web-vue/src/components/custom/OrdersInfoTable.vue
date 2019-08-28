<template>
  <div>
    <el-row>
      <el-table :data="tableData" border style="width: 100%">
        <el-table-column label="颜色" >
          <template slot-scope="scope">
            <span>{{scope.row.name}}</span>
          </template>
        </el-table-column>
        <template v-for="(item,index) in tableHead">
          <el-table-column :label="item">
            <template slot-scope="scope">
              <span>{{sizeFilter(item,scope.row.size)}}</span>
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
    computed: {},
    methods: {
      onClickShowTable() {
        this.showTable = !this.showTable;
        if(this.tableData.length==1){
          this.tableData=this.mockData;
        }else{
          this.tableData=[this.mockData[0]];
        }
      },
      //尺码筛选
      sizeFilter(name, sizes) {
        var result = '';
        sizes.forEach(element => {
          if (element.name == name) {
            result = element.num;
            return element.num;
          }
        });
        return result;
      }
    },
    data() {
      return {
        showTable: false,
        tableData:[],
        previewTableData:[],
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
      //生成表格信息
      this.mockData[0].size.forEach(element => {
        this.tableHead.push(element.name);
      });
      //表格预览数据（取一行数据）
      this.previewTableData.push(this.mockData[0]);
      this.tableData=this.previewTableData;
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
  .orders-info-table-btn{
    margin-top: 20px;
  }

</style>
