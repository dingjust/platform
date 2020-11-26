<template>
  <el-row class="reconciliation-import">
    <upload-excel-component :on-success="handleSuccess" :before-upload="beforeUpload" :downLink="downLink" />
    <el-table :data="tableData" border style="width: 100%;margin-top:20px;">
      <el-table-column label="产品图片" min-width="80px">
        <template slot-scope="scope">
          <div v-if="scope.row.product && scope.row.product.id && scope.row.product.id !== ''"> 
            <img :src="scope.row.product.thumbnail.url" style="width: 50px; height: 50px"/>
          </div>
          <el-button type="text" @click="onSelectProduct(scope.$index)" v-else>
            <div class="product-select-icon">
              <i class="el-icon-plus select-icon"></i>
            </div>
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" prop="product.name">
        <template slot-scope="scope">
          <div title="此款号产品不在数据库中，请点击左侧按钮添加产品">
            <span v-if="scope.row.product.id">{{scope.row.product.name}}</span>
            <span v-else class="noth-product">
              {{scope.row.product.name}}
              <i class="el-icon-warning" style="color: #F56C6C"/>
            </span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="波段" prop="波段"></el-table-column>
      <el-table-column label="产品款号">
        <template slot-scope="scope">
          <div title="此款号产品不在数据库中，请点击左侧按钮添加产品">
            <span v-if="scope.row.product.id">{{scope.row.product.skuID}}</span>
            <span v-else class="noth-product">
              {{scope.row.product.skuID}}
              <i class="el-icon-warning" style="color: #F56C6C" />
            </span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="订单款号" prop="订单款号"></el-table-column>
      <el-table-column label="交货时间" prop="交货时间" min-width="85"></el-table-column>
      <el-table-column label="合同时间" prop="合同时间" min-width="85"></el-table-column>
      <el-table-column label="定作方式" prop="定作方式"></el-table-column>
      <el-table-column label="下单数" prop="下单数"></el-table-column>
      <el-table-column label="裁数" prop="裁数"></el-table-column>
      <el-table-column label="装箱单数" prop="装箱单数"></el-table-column>
      <el-table-column label="正品入库数" prop="正品入库数" min-width="85"></el-table-column>
      <el-table-column label="合同单价(不含税）" prop="合同单价(不含税）" min-width="80"></el-table-column>
      <el-table-column label="货款金额" prop="货款金额"></el-table-column>
      <el-table-column label="快递费" prop="快递费"></el-table-column>
      <el-table-column label="扣款" prop="扣款"></el-table-column>
      <el-table-column label="退货" prop="退货"></el-table-column>
      <el-table-column label="结算金额" prop="结算金额"></el-table-column>
      <el-table-column label="备注" prop="备注">
        <template slot-scope="scope">
          <span :title="scope.row['备注']" class="remark-title">{{scope.row['备注']}}</span>
        </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" justify="center" style="margin-top:20px">
      <el-button @click="onImport" class="import-btn">导入</el-button>
    </el-row>
    <el-dialog :visible.sync="productDialog" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="productDialog" @onSelectSample="onSelectSample" :isSingleSelect="true"/>
    </el-dialog>
  </el-row>
</template>

<script>
import { UploadExcelComponent } from '@/components/'
import SampleProductsSelectDialog from '@/views/product/sample/components/SampleProductsSelectDialog'

export default {
  name: 'ReconciliationEntryImport',
  components: {
    UploadExcelComponent,
    SampleProductsSelectDialog
  },
  data () {
    return {
      downLink: 'https://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E9%87%87%E8%B4%AD%E6%B8%85%E5%8D%95%E6%89%B9%E9%87%8F%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xlsx',
      tableData: [],
      productDialog: false,
      operateIndex: ''
    }
  },
  computed: {
    sumbitData: function () {
      return this.tableData.map(row => {
        // 日期字符串转时间戳，其他类型统一转string
        return {
          product: row['product'],
          waveBand: row['波段'],
          orderItemNo: row['订单款号'],
          deliveryDate: new Date(row['交货时间'].replace(/-|\./g, '/')).getTime(),
          contractDate: new Date(row['合同时间'].replace(/-|\./g, '/')).getTime(),
          customizedMode: row['定作方式'],
          orderQuantity: row['下单数'],
          cutQuantity: row['裁数'],
          packageQuantity: row['装箱单数'],
          storageQuantity: row['正品入库数'],
          unitContractPrice: row['合同单价(不含税）'],
          loanAmount: row['货款金额'],
          expressFee: row['快递费'],
          deductionAmount: row['扣款'],
          returnQuantity: row['退货'],
          settlementAmount: row['结算金额'],
          remarks: row['备注']
        };
      });
    }
  },
  methods: {
    onSelectProduct (index) {
      this.productDialog = true;
      this.operateIndex = index;
    },
    onSelectSample (products) {
      this.tableData[this.operateIndex].product.skuID = products[0].skuID;
      this.tableData[this.operateIndex].product.name = products[0].name;
      this.tableData[this.operateIndex].product.id = products[0].id;
      this.tableData[this.operateIndex].product.thumbnail = products[0].thumbnail;
      this.productDialog = false;
    },
    beforeUpload(file) {
      const isLt1M = file.size / 1024 / 1024 < 5

      if (isLt1M) {
        return true
      }
      this.$message({
        message: '文件限制大小5M',
        type: 'warning'
      })
      return false
    },
    handleSuccess({ results, header }) {
      // 过滤空白行
      let data = results.filter(row => {  
        for (let key in row) {
          if (row[key]) {
            return true;
          }
        }
        return false;
      });

      // 获取实际的excel表数据
      const actualData = data.slice(3, data.findIndex(row => Object.values(row).some(item => item === '合计')));

      // 获取表头
      const temp = actualData.shift();
      // 解析数据
      let item = {};
      let product;
      let tableC = [];
      actualData.map(row => {
        for (const key in temp) {
          if (temp.hasOwnProperty(key)) {
            const element = temp[key];
            if (!row[key]) {
              // 处理没值的情况
              item[element] = '';
            } else if (element === '交货时间' || element === '合同时间') {
              // 时间相关的列进行特殊处理
              item[element] = this.formatDate(row[key]);
            } else if (typeof row[key] === 'string') {
              // 字符串类型去除内容中的回车
              item[element] = row[key].replace(/[\r\n]/g,"").trim();
            } else {
              item[element] = row[key] + '';
            }
          }
        }

        product = {
          name: item['产品名称'],
          skuID: item['产品款号']
        }

        item['product'] = product;

        tableC.push(item);
        item = {};
      });

      // 调取接口校验每行的产品skuID是否存在
      this.validateSkuID(tableC);
    },
    async validateSkuID (tableC) {
      let skuIDs = tableC.map(row => row['product'].skuID);  
      // 去重,转换为 ,分隔的字符串
      skuIDs = [...new Set(skuIDs)].join(',');

      const url = this.apis().checkProductBySkuID();
      const result = await this.$http.get(url, {
        skuIds: skuIDs
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      }

      this.handleData(tableC, result);
    },
    handleData (tableC, result) {
      let index;
      tableC.forEach(item => {
        index = result.findIndex(val => val.skuID === item.product.skuID);
        if (index > -1) {
          item.product.id = result[index].id;
          item.product.thumbnail = result[index].thumbnail;
        }
      })

      this.$set(this, 'tableData', tableC);
    },
    onImport () {
      // 判断数据是否合法
      let badData = this.tableData.filter(item => !item.product.id);
      if (badData.length > 0) {
        this.$message.error('存在数据行没有产品，请先处理！');
        return;
      }

      this.$emit('onImport', this.sumbitData);
    },
    // excel日期格式处理
    formatDate (numb) {
      var second = 25569,
              day_timestamp = 24 * 60 * 60 * 1000;
      //把五位数的numb转化为时间戳类型，单位是毫秒
      var cTime = (numb - second) * day_timestamp;
            //如果numb为空或者不为时间类型，则原数据赋值
      if (cTime.toString() == 'NaN'|| cTime <= 0){
          return numb
      }else {
          //转化为时间格式
          return this.timestamptodate('Y-m-d',cTime)
      };
    },
    timestamptodate (format, timestamp){
      var ret;
      var a, jsdate=((timestamp) ? new Date(timestamp) : new Date());
      var pad = function(n, c){
          if((n = n + "").length < c){
              return new Array(++c - n.length).join("0") + n;
          } else {
              return n;
          }
      };
      var txt_weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
      var txt_ordin = {1:"st", 2:"nd", 3:"rd", 21:"st", 22:"nd", 23:"rd", 31:"st"};
      var txt_months = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      var f = {
          // Day
          d: function(){return pad(f.j(), 2)},
          D: function(){return f.l().substr(0,3)},
          j: function(){return jsdate.getDate()},
          l: function(){return txt_weekdays[f.w()]},
          N: function(){return f.w() + 1},
          S: function(){return txt_ordin[f.j()] ? txt_ordin[f.j()] : 'th'},
          w: function(){return jsdate.getDay()},
          z: function(){return (jsdate - new Date(jsdate.getFullYear() + "/1/1")) / 864e5 >> 0},

          // Week
          W: function(){
              var a = f.z(), b = 364 + f.L() - a;
              var nd2, nd = (new Date(jsdate.getFullYear() + "/1/1").getDay() || 7) - 1;
              if(b <= 2 && ((jsdate.getDay() || 7) - 1) <= 2 - b){
                  return 1;
              } else{
                  if(a <= 2 && nd >= 4 && a >= (6 - nd)){
                      nd2 = new Date(jsdate.getFullYear() - 1 + "/12/31");
                      return date("W", Math.round(nd2.getTime()/1000));
                  } else{
                      return (1 + (nd <= 3 ? ((a + nd) / 7) : (a - (7 - nd)) / 7) >> 0);
                  }
              }
          },

          // Month
          F: function(){return txt_months[f.n()]},
          m: function(){return pad(f.n(), 2)},
          M: function(){return f.F().substr(0,3)},
          n: function(){return jsdate.getMonth() + 1},
          t: function(){
              var n;
              if( (n = jsdate.getMonth() + 1) == 2 ){
                  return 28 + f.L();
              } else{
                  if( n & 1 && n < 8 || !(n & 1) && n > 7 ){
                      return 31;
                  } else{
                      return 30;
                  }
              }
          },

          // Year
          L: function(){var y = f.Y();return (!(y & 3) && (y % 1e2 || !(y % 4e2))) ? 1 : 0},
          //o not supported yet
          Y: function(){return jsdate.getFullYear()},
          y: function(){return (jsdate.getFullYear() + "").slice(2)},

          // Time
          a: function(){return jsdate.getHours() > 11 ? "pm" : "am"},
          A: function(){return f.a().toUpperCase()},
          B: function(){
              // peter paul koch:
              var off = (jsdate.getTimezoneOffset() + 60)*60;
              var theSeconds = (jsdate.getHours() * 3600) + (jsdate.getMinutes() * 60) + jsdate.getSeconds() + off;
              var beat = Math.floor(theSeconds/86.4);
              if (beat > 1000) beat -= 1000;
              if (beat < 0) beat += 1000;
              if ((String(beat)).length == 1) beat = "00"+beat;
              if ((String(beat)).length == 2) beat = "0"+beat;
              return beat;
          },
          g: function(){return jsdate.getHours() % 12 || 12},
          G: function(){return jsdate.getHours()},
          h: function(){return pad(f.g(), 2)},
          H: function(){return pad(jsdate.getHours(), 2)},
          i: function(){return pad(jsdate.getMinutes(), 2)},
          s: function(){return pad(jsdate.getSeconds(), 2)},
          //u not supported yet

          // Timezone
          //e not supported yet
          //I not supported yet
          O: function(){
              var t = pad(Math.abs(jsdate.getTimezoneOffset()/60*100), 4);
              if (jsdate.getTimezoneOffset() > 0) t = "-" + t; else t = "+" + t;
              return t;
          },
          P: function(){var O = f.O();return (O.substr(0, 3) + ":" + O.substr(3, 2))},
          //T not supported yet
          //Z not supported yet

          // Full Date/Time
          c: function(){return f.Y() + "-" + f.m() + "-" + f.d() + "T" + f.h() + ":" + f.i() + ":" + f.s() + f.P()},
          //r not supported yet
          U: function(){return Math.round(jsdate.getTime()/1000)}
      };

      return format.replace(/[\ ]?([a-zA-Z])/g, function(t, s){
          if( t!=s ){
              // escaped
              ret = s;
          } else if( f[s] ){
              // a date function exists
              ret = f[s]();
          } else{
              // nothing special
              ret = s;
          }
          return ret;
      });
    },
  }
}
</script>

<style scoped lang="scss">
  .import-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
    width: 80px;
  }

  .remark-title {
    overflow: hidden;
    text-overflow:ellipsis;
    white-space: nowrap;
  }

  .reconciliation-import >>> .circular {
    border: none;
  }

  .product-select-icon {
    width: 50px;
    height: 50px;
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #fff;
    .select-icon {
      font-size: 28px;
      color: #8c939d;
    }
  }

  .product-select-icon:hover{
    border: 1px dashed #409eff;
    color: #409eff !important;
    .select-icon {
      color: #409eff;
    }
  }

  .noth-product {
    color: #C0C4CC;
  }
</style>