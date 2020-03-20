<template>
  <div>
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">价格设置<span class="info-title_text-sub">(上架必备)</span></h6>
      </div>
    </el-row>
    <!--<el-row :gutter="10" type="flex" align="center">-->
      <!--<el-col :span="9" class="product-form-row">-->
        <!--<el-form-item class="product-form-item" :rules="[-->
                <!--{ required: true, message: '请输入打样费', trigger: 'blur'}]"-->
          <!--:prop="currentUser.type=='FACTORY'?'proofingFee':''">-->
          <!--<el-row type="flex" align="middle" justify="start">-->
            <!--<div style="width:80px">-->
              <!--<h6 class="info-input-prepend">打样费：</h6>-->
            <!--</div>-->
            <!--<el-input placeholder="请输入打样费" v-model="slotData.proofingFee" type="number" size="mini"-->
              <!--@mousewheel.native.prevent :min="0" :disabled="isRead">-->
            <!--</el-input>-->
            <!--<div style="width:230px">-->
              <!--<h6 class="info-title_text-sub_warning" v-if="!isRead">（卖家承担运费）</h6>-->
            <!--</div>-->
          <!--</el-row>-->
        <!--</el-form-item>-->
      <!--</el-col>-->
    <!--</el-row>-->
    <!--<el-divider></el-divider>-->
    <el-row>
      <h6 class="info-title_text">大货价格</h6>
    </el-row>
    <template v-for="(row,index) in slotData.steppedPrices">
      <el-row :gutter="20" type="flex" align="center">
        <el-col :span="6" class="product-form-row">
            <el-row type="flex" align="middle">
              <div style="width:85px">
                <h6 class="info-input-prepend">{{index+1}}. 起订量:</h6>
              </div>
              <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请输入报价', trigger: 'blur' ,type: 'number'}]" :key="row.key"
                            :prop="'steppedPrices.' + index+'.minimumQuantity'">
                  <el-input placeholder="输入起订量" v-model.number="row.minimumQuantity" size="mini" :disabled="isRead"></el-input>
              </el-form-item>
            </el-row>
        </el-col>
        <el-col :span="5" class="product-form-row">
            <el-row type="flex" align="middle">
              <div style="width:60px">
                <h6 class="info-input-prepend">价格：</h6>
              </div>
              <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请输入价格', trigger: 'blur'}]" :key="row.key"
                            :prop="'steppedPrices.' + index+'.price'">
                  <el-input placeholder="输入价格" v-model="row.price" size="mini" type="number" :disabled="isRead"></el-input>
              </el-form-item>
            </el-row>
        </el-col>
        <el-button type="text" @click="onRemove(index)" v-if="!isRead">删除</el-button>
      </el-row>
    </template>
    <el-row type="flex" v-if="slotData.steppedPrices.length<3">
      <el-col :span="11">
        <div @click="onAddRow" class="product-price-form_btn-row">
          <el-row type="flex" justify="center" align="center">
            <i class="el-icon-circle-plus product-price-form_icon"></i>
            <h6 class="product-price-form_icon-text">添加</h6>
          </el-row>
        </div>
      </el-col>
    </el-row>
    <el-divider></el-divider>
    <el-row>
      <h6 class="info-title_text">生产天数</h6>
    </el-row>
    <el-row :gutter="20" type="flex" align="center">
      <el-col :span="5" class="product-form-row">
          <el-row type="flex" align="middle">
            <div style="width:100px">
              <h6 class="info-input-prepend" style="width:100px">基础生产量:</h6>
            </div>
            <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请输入产量', trigger: 'blur'}]"
                          :prop="currentUser.type=='FACTORY'?'basicProduction':''">
                <el-input placeholder="输入起订量" v-model="slotData.basicProduction" size="mini" :disabled="isRead"></el-input>
            </el-form-item>
          </el-row>
      </el-col>
      <el-col :span="5" class="product-form-row">
          <el-row type="flex" align="middle">
            <div style="width:85px">
              <h6 class="info-input-prepend">生产天数：</h6>
            </div>
            <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请输入价格', trigger: 'blur' ,type: 'number'}]"
                          :prop="currentUser.type=='FACTORY'?'productionDays':''">
                <el-input placeholder="输入天数" v-model.number="slotData.productionDays" size="mini" :disabled="isRead"></el-input>
            </el-form-item>
          </el-row>
      </el-col>
      <el-col :span="7" class="product-form-row">
          <el-row type="flex" align="middle">
            <div style="width:150px">
              <h6 class="info-input-prepend" style="width:150px">生产增量（数量/天）：</h6>
            </div>
            <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请输入生产增量', trigger: 'blur'}]"
                          :prop="currentUser.type=='FACTORY'?'productionIncrement':''">
                <el-input placeholder="输入增量" v-model.number="slotData.productionIncrement" size="mini" :disabled="isRead"></el-input>
            </el-form-item>
          </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductPriceForm',
    props: ['slotData', 'readOnly', 'isRead'],
    components: {},
    computed: {

    },
    methods: {
      onAddRow () {
        this.slotData.steppedPrices.push({
          minimumQuantity: '',
          price: ''
        });
      },
      onRemove (index) {
        this.slotData.steppedPrices.splice(index, 1);
      }
    },
    data () {
      return {
        activeName: 'images',
        currentUser: this.$store.getters.currentUser
      };
    },
    created () {
    }
  };
</script>
<style scoped>
  .info-title_text-sub {
    font-weight: 500;
    color: #CCCCCC;
    font-size: 12px;
  }

  .info-title_text-sub_warning {
    font-weight: 500;
    color: #FF3333;
    font-size: 12px;
    margin: 0 5px;
    display: inline-block;
  }

  .product-price-form_icon {
    color: #FFD60C;
    font-size: 25px;
    cursor: pointer;
  }

  .product-price-form_icon-text {
    color: #FFD60C;
    font-size: 13px;
    margin-left: 10px;
    text-align: center;
    margin-top: 5px;
  }

  .product-price-form_btn-row {
    cursor: pointer;

  }
  /deep/ .product-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .product-form-row {
    margin-bottom: 15px;
  }
</style>
