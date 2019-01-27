<template>
  <div class="animated fadeIn">
    <order-status-bar :status="slotData.status"></order-status-bar>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <!-- <span class="float-right">
            <el-button type="primary" size="mini" @click="onUpdateBase">编辑</el-button>
         </span>-->
      </div>
      <order-base-form :slot-data="slotData" :read-only="true"></order-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>收货地址</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateAddress">编辑</el-button>
        </span>
      </div>
      <order-delivery-address-form ref="orderDeliveryAddressForm"
                                   :slot-data="slotData"
                                   :read-only="true">
      </order-delivery-address-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>订单行</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateEntries">编辑</el-button>
        </span>
      </div>
      <order-entries-form :slot-data="slotData" :read-only="true"></order-entries-form>
    </el-card>

    <!--<el-dialog title="更新基本信息"
               :visible.sync="baseFormDialogVisible"
               :modal="false">
      <order-base-form ref="baseForm"
                       :slot-data="baseData"
                       :read-only="false">
      </order-base-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="baseFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitBaseForm">确 定</el-button>
      </div>
    </el-dialog>-->
    <el-dialog title="更新地址"
               :visible.sync="addressFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <order-delivery-address-form ref="addressForm"
                                   :slot-data="addressData"
                                   :read-only="false">
      </order-delivery-address-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addressFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitAddressForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新订单行" width="80%"
               :visible.sync="entriesFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <order-entries-form ref="entriesForm"
                          :slot-data="entriesData"
                          :read-only="false">
      </order-entries-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="entriesFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitEntriesForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from "axios";
  import OrderBaseForm from "./OrderBaseForm";
  import OrderEntriesForm from "./OrderEntriesForm";
  import OrderDeliveryAddressForm from "./OrderDeliveryAddressForm";
  import OrderStatusBar from "./OrderStatusBar";

  export default {
    name: "OrderDetailsPage",
    props: ["slotData", "readOnly"],
    components: {OrderStatusBar, OrderBaseForm, OrderDeliveryAddressForm, OrderEntriesForm},
    methods: {
      refresh() {
        this.$refs["orderDeliveryAddressForm"].refresh();
      },
      onUpdateBase() {
        Object.assign(this.baseData, this.slotData);
        this.baseFormDialogVisible = true;
      },
      onSubmitBaseForm() {
        this.baseFormDialogVisible = false;

        if (this.$refs["baseForm"].validate()) {
          axios.put("/djbackoffice/salesOrder/base", {
            code: this.slotData.code
          }).then(() => {
            this.$message.success("更新基本信息成功")
          }).catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error("更新基本信息失败，原因：" + error.response.data);
          });
        }
      },
      onUpdateAddress() {
        Object.assign(this.addressData.deliveryAddress, this.slotData.deliveryAddress);
        this.addressFormDialogVisible = true;
      },
      onSubmitAddressForm() {
        this.$refs["addressForm"].validate((valid) => {
          if (valid) {
            axios.put("/djbackoffice/salesOrder/deliveryAddress", {
              code: this.slotData.code,
              deliveryAddress: this.addressData.deliveryAddress
            }).then(() => {
              this.$message.success("更新地址成功");

              this.addressFormDialogVisible = false;
            }).catch(error => {
              console.log(JSON.stringify(error));
              this.$message.error("更新地址失败，原因：" + error.response.data);
            });

            return true;
          }

          return false;
        });
      },
      onUpdateEntries() {
        Object.assign(this.entriesData.entries, this.slotData.entries);
        this.entriesFormDialogVisible = true;
      },
      onSubmitEntriesForm() {
        this.entriesFormDialogVisible = false;

        if (this.$refs["entriesForm"].validate()) {
          axios.put("/djbackoffice/salesOrder/entries", {
            code: this.slotData.code,
            entries: this.entriesData.entries
          }).then(() => {
            this.$message.success("更新订单行成功");

            this.$set(this.slotData, "entries", this.entriesData.entries);
          }).catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error("更新订单行失败，原因：" + error.response.data);
          });
        }
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {
        baseFormDialogVisible: false,
        baseData: {
          id: null,
          code: this.slotData.code
        },
        addressFormDialogVisible: false,
        addressData: {
          id: null,
          code: this.slotData.code,
          deliveryAddress: this.slotData.deliveryAddress
        },
        entriesFormDialogVisible: false,
        entriesData: {
          id: null,
          code: this.slotData.code,
          entries: []
        }
      }
    }
  }
</script>
