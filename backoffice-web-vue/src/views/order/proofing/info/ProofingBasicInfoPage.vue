<template>
  <div class="animated fadeIn proofing-basic">
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <div class="demo-image__preview">
          <el-image
            style="width: 100px; height: 100px;border-radius: 9px"
            :src="slotData.product.images != null && slotData.product.images.length > 0 ? slotData.product.images[0].url : 'static/img/nopicture.png'"
            :preview-src-list="picUrls">
          </el-image>
        </div>
      </el-col>
      <el-col :span="20">
        <el-row type="flex" class="rowClass">
          <el-col :span="12">
            <el-row type="flex" >
              <h6 style="font-weight: bold">生产产品&nbsp;&nbsp;&nbsp;&nbsp;</h6>
              <h6 class="contentTextClass">{{slotData.product.name}}</h6>
            </el-row>
          </el-col>
          <el-col :span="12">
            <el-row type="flex" >
              <h6 style="font-weight: bold">打样费&nbsp;&nbsp;&nbsp;&nbsp;</h6>
              <h6 class="contentTextClass" style="color:red">￥{{slotData.unitPrice ? slotData.unitPrice : '--'}}</h6>
            </el-row>
          </el-col>
        </el-row>
      <el-row type="flex" class="rowClass">
        <h6 style="font-weight: bold">送货地址&nbsp;&nbsp;&nbsp;&nbsp;</h6>
        <h6 class="contentTextClass">{{slotData.deliveryAddress == null ? '' : slotData.deliveryAddress.details + slotData.deliveryAddress.line1}}</h6>
      </el-row>
      <el-row type="flex" class="rowClass">
        <el-col :span="16">
          <el-input :readOnly="true" :value="consignment">
            <el-button slot="append" style="background-color: #FFD60C;color: #0b0e0f">查看物流</el-button>
          </el-input>
        </el-col>
      </el-row>
    </el-col>
   </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="12">
        <el-row type="flex">
          <h6 style="font-weight: bold">打样数量&nbsp;&nbsp;&nbsp;&nbsp;</h6>
          <h6 class="contentTextClass" style="color:red">{{slotData.totalQuantity}}件</h6>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex">
          <h6 style="font-weight: bold">打样总价&nbsp;&nbsp;&nbsp;&nbsp; </h6>
          <h6 class="contentTextClass" style="color:red">￥{{slotData.totalPrice ? slotData.totalPrice : '--'}}</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass2">
      <el-table :data="tableData" width="100%"  border>
        <el-table-column v-for="(item,index) in tableHead" :key="index" :label="item.label" :property="item.property" align="center">
          <template slot-scope="scope">{{scope.row[scope.column.property]}}</template>
        </el-table-column>
      </el-table>
    </el-row>
    <el-row type="flex" class="rowClass">
      <h6 style="font-weight: bold">备注&nbsp;&nbsp;&nbsp;&nbsp; </h6>
      <h6 class="contentTextClass">{{slotData.remarks}}</h6>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('ProofingsModule');

  export default {
    name: 'ProofingBasicInfoPage',
    props: {
      slotData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    components: {
    },
    computed: {
      ...mapGetters({

      }),
      picUrls: function () {
        if (this.slotData.product.images != null && this.slotData.product.images.length > 0) {
          return this.slotData.product.images.map(pic => pic.url);
        } else {
          return [];
        }
      },
      consignment: function () {
        if (this.slotData.consignment == null) {
          return '';
        } else {
          return this.slotData.consignment.carrierDetails.name + '   ' + this.slotData.consignment.trackingID;
        }
      },
      tableHead: function () {
        var heads = [
          {
            label: '',
            property: 'color'
          }
        ];
        aaa:for (let entry of this.slotData.entries) {
          for (let head of heads) {
            if (head.property === entry.product.size.name) {
              continue aaa;
            }
          }
          heads.push({label: entry.product.size.name, property: entry.product.size.name});
        }

        return heads;
      },
      tableData: function () {
        var datas = [];

        aaa:for (let entry of this.slotData.entries) {
          for (let d of datas) {
            if (d.color === entry.product.color.name) {
              d[entry.product.size.name] = entry.quantity;
              continue aaa;
            }
          }
          let data = {};
          data.color = entry.product.color.name;
          data[entry.product.size.name] = entry.quantity;
          datas.push(data);
        }

        return datas;
      }
    },
    methods: {
      ...mapMutations({
      }),
      ...mapActions({
      })

    },
    data () {
      return {
      }
    },
    created () {
    }
  }
</script>

<style scoped>
  .proofing-basic .rowClass{
    margin-bottom:10px;
  }
  .proofing-basic .rowClass2{
    margin-bottom:20px;
  }
  .proofing-basic .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-weight: bold;
  }
  .proofing-basic .contentTextClass{
    color: #A9A9A9;
    font-weight: 400;
  }
</style>
