<template>
  <div class="app-container">
    <upload-excel-component :on-success="handleSuccess" :before-upload="beforeUpload" :downLink="downLink"/>
    <el-table :data="tableData" border highlight-current-row style="width: 100%;margin-top:20px;">
      <el-table-column label="物料编号">
        <template slot="header">
          <span>物料编号<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料编号*']">{{scope.row['物料编号*']}}</span>
          <i v-else class="el-icon-error row-icon"></i>
        </template>
      </el-table-column>
      <el-table-column label="物料名称">
        <template slot="header">
          <span>物料名称<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料名称*']">{{scope.row['物料名称*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="物料类别">
        <template slot="header">
          <span>物料类别<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料类别*']">{{scope.row['物料类别*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="幅宽/型号">
        <template slot="header">
          <span>幅宽/型号<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['幅宽/型号*']">{{scope.row['幅宽/型号*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="克重/规格">
        <template slot-scope="scope">
          <span>{{scope.row['克重/规格']}}</span>
        </template>
      </el-table-column>
      <el-table-column label="物料单位">
        <template slot="header">
          <span>物料单位<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料单位*']">{{scope.row['物料单位*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="物料颜色">
        <template slot="header">
          <span>物料颜色<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料颜色*']">{{scope.row['物料颜色*']}}</span>
          <i class="el-icon-error row-icon" v-else></i>
        </template>
      </el-table-column>
      <el-table-column label="单件用量">
        <template slot="header">
          <span>单件用量<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['单件用量*'] || scope.row['单件用量*'] === 0">{{scope.row['单件用量*']}}</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['单件用量*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="损耗">
        <template slot="header">
          <span>损耗<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['损耗*'] || scope.row['损耗*'] === 0">{{scope.row['损耗*'] * 100}}%</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['损耗*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="预计用量">
        <template slot="header">
          <span>预计用量<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['预计用量*'] || scope.row['预计用量*'] === 0">{{scope.row['预计用量*'].toFixed(2)}}</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['预计用量*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="空差">
        <template slot="header">
          <span>空差<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['空差*'] || scope.row['空差*'] === 0">{{scope.row['空差*'] * 100}}%</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['空差*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="订单数">
        <template slot="header">
          <span>订单数<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['订单数*'] || scope.row['订单数*'] === 0">{{scope.row['订单数*']}}</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['订单数*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="需求总量">
        <template slot="header">
          <span>需求总量<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['需求总量*'] || scope.row['需求总量*'] === 0">{{scope.row['需求总量*'].toFixed(2)}}</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['需求总量*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="供应商">
        <template slot-scope="scope">
          <span>{{scope.row['供应商']}}</span>
        </template>
      </el-table-column>
      <el-table-column label="物料单价">
        <template slot="header">
          <span>物料单价<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['物料单价*'] || scope.row['物料单价*'] === 0">{{scope.row['物料单价*']}}</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['物料单价*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="总金额">
        <template slot="header">
          <span>总金额<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['总金额*'] || scope.row['总金额*'] === 0">{{scope.row['总金额*'].toFixed(2)}}</span>
          <i class="el-icon-error row-icon" v-if="isNumberNotNaN(scope.row['总金额*'])"></i>
        </template>
      </el-table-column>
      <el-table-column label="到料时间" min-width="100px">
        <template slot="header">
          <span>到料时间<span style="color: #F56C6C">*</span></span>
        </template>
        <template slot-scope="scope">
          <span v-if="scope.row['到料时间*']">{{formatDate(scope.row['到料时间*'])}}</span>
          <i class="el-icon-error row-icon" v-if="isLegalDate(scope.row['到料时间*'])"></i>
        </template>
      </el-table-column>
      <!-- <el-table-column label="是否批色">
        <template slot-scope="scope">
          <span>{{scope.row['是否批色']}}</span>
        </template>
      </el-table-column> -->
    </el-table>
    <el-row type="flex" justify="center" style="margin-top:20px">
      <el-button @click="onCreate" class="material-btn">导入</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    UploadExcelComponent,
  } from '@/components/'

  export default {
    name: 'MaterialsImport',
    components: {
      UploadExcelComponent,
    },
    data() {
      return {
        numErrorCount: 0,
        tableData: [],
        tableHeader: [],
        MaterialsType: this.$store.state.EnumsModule.MaterialsType,
        cacheData:[],
        cacheHeader:[],
        downLink: 'https://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E9%87%87%E8%B4%AD%E6%B8%85%E5%8D%95%E6%89%B9%E9%87%8F%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xlsx'
      }
    },
    computed: {
      sumbitData: function () {
        return this.tableData.map(row => {
          return {
            name: (row['物料名称*'] + '').replace(/[\r\n]/g,"").trim(),
            code: (row['物料编号*'] + '').replace(/[\r\n]/g,"").trim(),
            materialsType: this.getMaterial(row['物料类别*']),
            modelName: (row['幅宽/型号*'] + '').replace(/[\r\n]/g,"").trim(),
            specName: (row['克重/规格'] + '')!=undefined?(row['克重/规格'] + '').replace(/[\r\n]/g,"").trim():'',
            unit: (row['物料单位*'] + '').replace(/[\r\n]/g,"").trim(),
            colorName: (row['物料颜色*'] + '').replace(/[\r\n]/g,"").trim(),
            unitQuantity: row['单件用量*'] + '',
            estimatedLoss: (row['损耗*'] * 100) + '',
            estimatedUsage: row['预计用量*'] + '',
            emptySent: (row['空差*'] * 100) + '',
            orderCount: row['订单数*'] + '',
            requiredAmount: row['需求总量*'] + '',
            cooperatorName: (row['供应商'] + '').replace(/[\r\n]/g,"").trim(),
            price: row['物料单价*'] + '',
            totalPrice: row['总金额*'] + '',
            estimatedRecTime: new Date(row['到料时间*'].replace(/-|\./g, '/')).getTime()
            // auditColor: row['是否批色'].trim() === '是'
          }
        })
      }
    },
    methods: {
      getMaterial (val) {
        let index = this.MaterialsType.findIndex(item => item.name === val);
        if (index > -1) {
          return this.MaterialsType[index].code;
        }
        return val;
      },
      isLegalDate (val) {
        let flag1 = val === null && val === undefined && val === '';
        if (flag1 || this.isValidDate(new Date(val))) {
          this.numErrorCount++;
          return true;
        }
        return false;
      },
      isValidDate(date) {
        return date instanceof Date && isNaN(date.getTime())
      },
      isNumberNotNaN (val) {
        let flag1 = val === null && val === undefined && val === '';
        let flag2 = Number.isNaN(Number.parseFloat(val));
        if (flag1 || flag2) {
          this.numErrorCount++;
          return true;
        }
        return false;
      },
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
        this.numErrorCount = 0;
        let data = results.filter(row => {  
          for (let key in row) {
            if (row[key]) {
              return true;
            }
          }
          return false;
        });
        let temp = data.shift();
        let item = {};
        let tableD = [];
        // this.cacheData=results;
        // this.cacheHeader=header;
        data.map(row => {
          for (let key in temp) {
            if (temp[key]) {
              if (temp[key] === '到料时间*') {
                item[temp[key]] = this.formatDate(row[key]);
              } else {
                if(row[key]==null||row[key]==undefined){
                  item[temp[key]] = '';
                }else{
                  item[temp[key]] = row[key];
                }
                
              }
            }
          }
          tableD.push(item);
          item = {};
        })
        this.$set(this, 'tableData', tableD);
        this.tableHeader = header;
      },
      onCreate () {
        // if (this.numErrorCount > 0) {
        //   this.$message.error('表格数据有误，请修改表格后再上传');
        //   throw Error('表格数据有误，请修改表格后再上传');
        //   return;
        // }
        // this.tableData.forEach(row => {
        //   for (let key in row) {
        //     // if (!row[key] && key !== '是否批色' && key !== '合作商' && key !== '克重/规格') {
        //     if (!row[key] && key !== '合作商' && key !== '克重/规格') {
        //       this.$message.error('表格数据有误，请修改表格后再上传');
        //       throw Error('表格数据有误，请修改表格后再上传');
        //       return;
        //     }
        //   }
        // })
        this.$emit('onImport', this.sumbitData);
      }
    }
  }

</script>
<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .row-icon {
    font-size: 15px;
    color: #ff1744;
    margin-top: 5px;
  }

</style>
