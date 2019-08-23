<template>
  <div class="finance-form-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">账务记录</h6>
      </div>
    </el-row>
    <el-row type="flex">
      <el-col :span="8">
        <el-row type="flex">
          <h6 class="finance-form-text1">当前账期</h6>
          <h6 class="finance-form-text2">第一期尾款</h6>
        </el-row>
      </el-col>
      <el-col :span="16">
        <el-row type="flex">
          <h6 class="finance-form-text1">剩余未付/本期总额</h6>
          <h6 class="finance-form-text3">￥0.00/￥2000.00</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle">
      <el-col :span="8">
        <el-row type="flex" align="middle">
          <h6 class="finance-form-text1">类型</h6>
          <div style="margin-left: 20px">
            <el-radio-group v-model="form.type" size="mini" fill="#FFD60C">
              <el-radio-button label="部分收款"></el-radio-button>
              <el-radio-button label="全部收款"></el-radio-button>
            </el-radio-group>
          </div>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-row type="flex" align="middle">
          <el-col :span="8">
            <h6 class="finance-form-text1">本次付款金额</h6>
          </el-col>
          <el-col :span="16">
            <el-input class="finance-form" v-model="form.amount" type="number"></el-input>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-row type="flex" align="middle" justify="space-around" style="margin-bottom:5px;">
          <el-link class="finance-form-link" v-if="form.voucher==''" disabled>本次付款凭证</el-link>
          <el-link class="finance-form-link" v-if="form.voucher!=''" :href="form.voucher.url" target="_blank">
            {{form.voucher.name}}</el-link>
          <el-col :span="8">
            <el-upload name="file" :action="mediaUploadUrl" :data="uploadFormData" :show-file-list="false"
              :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers">
              <el-button type="text" size="mini">点击上传</el-button>
            </el-upload>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle" :gutter="20">
      <el-col :span="16">
        <el-row type="flex" align="middle">
          <el-col :span="2">
            <h6 class="finance-form-text1">备注</h6>
          </el-col>
          <el-col :span="22">
            <el-input class="finance-form" v-model="form.remarks"></el-input>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-button class="finance-form-btn">确认</el-button>
      </el-col>
    </el-row>
    <el-row>
      <el-table :data="mockData" style="width: 100%" class="finance-form-table">
        <el-table-column label="账期" prop="term">
        </el-table-column>
        <el-table-column label="付款金额">
          <template slot-scope="scope">
            <span>￥{{scope.row.payAmount}}</span>
          </template>
        </el-table-column>
        <el-table-column label="类型">
          <template slot-scope="scope">
            <span>{{scope.row.type}}</span>
          </template>
        </el-table-column>
        <el-table-column label="时间">
          <template slot-scope="scope">
            <span>{{scope.row.time}}</span>
          </template>
        </el-table-column>
        <el-table-column label="凭证" min-width="100px">
          <template slot-scope="scope">
            <el-row type="flex" align="middle">
              <el-link class="finance-form-link" v-if="scope.row.voucher!=''" :href="scope.row.voucher.url" target="_blank">
                {{scope.row.voucher.name}}</el-link>
              <el-upload name="file" :action="mediaUploadUrl" :data="uploadFormData" :show-file-list="false"
                :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers">
                <el-button type="text" size="mini" v-if="scope.row.voucher==''">点击上传</el-button>
              </el-upload>
            </el-row>
          </template>
        </el-table-column>
        <el-table-column label="本期剩余未付">
          <template slot-scope="scope">
            <span>￥{{scope.row.balance}}</span>
          </template>
        </el-table-column>
        <el-table-column>
          <template slot-scope="scope">
            <el-button size="mini" type="text">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseOrderFinanceForm',
    components: {

    },
    mixins: [],
    computed: {
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      },
    },
    methods: {
      onBeforeUpload(file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onSuccess(response) {
        this.form.voucher = response;
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      }
    },
    data() {
      return {
        uploadFormData: {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup',
        },
        form: {
          type: '',
          amount: '',
          voucher: '',
          remarks: ''
        },
        mockData: [{
          term: '定金',
          payAmount: 5000,
          type: '全部付款',
          time: '2019-01-01 22:30',
          voucher: {
            url: "/resource/hae/h8c/8807125680158.jpg",
            name: "-20190418113328.jpg"
          },
          balance: 200
        }, {
          term: '一期尾款',
          payAmount: 5000,
          type: '全部付款',
          time: '2019-01-01 22:30',
          voucher: '',
          balance: 200
        }, {
          term: '二期尾款',
          payAmount: 5000,
          type: '全部付款',
          time: '2019-01-01 22:30',
          voucher: '',
          balance: 200
        }]
      }
    },
    created() {

    },
    mounted() {}

  }

</script>
<style>
  .finance-form-body {
    width: 100%;
  }

  .finance-form-row {
    margin-bottom: 20px;
  }

  .finance-form-text1 {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
  }

  .finance-form-text2 {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
    margin-left: 20px;
  }

  .finance-form-text3 {
    font-size: 10px;
    font-weight: 500;
    color: rgba(255, 51, 51, 0.65);
    margin-left: 20px;
  }

  .finance-form .el-input__inner {
    height: 24px;
    line-height: 24px;
    margin-bottom: 5px;
  }

  .finance-form-text2 {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
    /* margin-left: 20px; */
  }

  .finance-form-link {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
    /* margin-left: 20px; */
  }

  .finance-form-btn {
    /* width: 50px; */
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 5px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 16px;
    margin-bottom: 6px;
  }

  .finance-form-table {
    font-size: 10px;
  }

</style>
