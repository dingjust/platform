<template>
  <div>
    <el-row type="flex" justify="start" v-if="!readOnly">
      <el-col :span="7">
        <el-form-item label="外发生产工单">
          <el-input :disabled="true" v-model="formData.orderCode"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="2">
        <el-button class="sumbit-btn" @click="outboundOrderSelectVisible = !outboundOrderSelectVisible">选择</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" justify="start" v-else>
      <h6>外发生产工单：{{formData.orderCode}}</h6>
    </el-row>
    <el-row type="flex" justify="start" v-if="formData.orderCode != ''">
      <el-col :span="3">
        <img width="100px" height="100px"
            :src="formData.product.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'">
      </el-col>
      <el-col :span="12">
        <el-row type="flex" style="padding: 10px 0px">
          <el-col :span="12">
            <h6>商品名称：{{formData.product.name}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>货号：{{formData.product.skuID}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-bottom: 10px">
          <el-col :span="12">
            <h6>单价：{{formData.price}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>数量：{{formData.quantity}}</h6>
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-bottom: 10px">
          <el-col :span="12">
            <h6>加工方式：{{getEnum('machiningTypes', formData.machiningTypes)}}</h6>
          </el-col>
          <el-col :span="12">
            <h6>交货日期：{{formData.expectedDeliveryDate | timestampToTime}}</h6>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="outboundOrderSelectVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">

    </el-dialog>
  </div>  
</template>

<script>
  export default {
    name: 'ReconciliationOrdersFormHead',
    props: {
      formData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: false
      }
    },
    components: {

    },
    computed: {

    },
    methods: {
    },
    data () {
      return {
        outboundOrderSelectVisible: false
      }
    },
    created () {

    }  
  }
</script>

<style scoped>
  .sumbit-btn {
    width: 70px;
    background-color: #ffd60c;
  }
</style>