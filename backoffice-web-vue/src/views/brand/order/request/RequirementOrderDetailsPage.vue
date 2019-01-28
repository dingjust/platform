<template>
  <div class="animated fadeIn">
    <requirement-order-status-bar :status="slotData.status"></requirement-order-status-bar>
    <div v-show="isPendingApproval" class="pt-2"></div>
    <el-row v-show="isPendingApproval" :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onConfirmRequirementAudit">
          确认
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onRejectRequirementAudit">
          拒绝
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <requirement-order-base-form :slot-data="slotData"
                                   :read-only="true">
      </requirement-order-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>地址/联系方式</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateAddress">编辑</el-button>
        </span>
      </div>
      <requirement-order-delivery-address-form ref="deliveryAddressForm"
                                               :slot-data="slotData"
                                               :read-only="true">
      </requirement-order-delivery-address-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateRequest">编辑</el-button>
        </span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData"
                                      :read-only="true">
      </requirement-order-request-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>BOM文件</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateBom">编辑</el-button>
        </span>
      </div>
      <requirement-order-bom-form ref="bomForm"
                                      :slot-data="slotData"
                                      :read-only="true">
      </requirement-order-bom-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>订单行</span>
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateEntries">编辑</el-button>
        </span>
      </div>
      <requirement-order-entries-form :slot-data="slotData"
                                      :read-only="true">
      </requirement-order-entries-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>合同</span>
      </div>
      <requirement-order-contracts-form ref="contractsForm"
                                        :slot-data="slotData"
                                        :read-only="true">
      </requirement-order-contracts-form>
    </el-card>
    <div v-show="isPendingApproval" class="pt-2"></div>
    <el-row v-show="isPendingApproval" :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onConfirmRequirementAudit">
          确认
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini"
                   @click="onRejectRequirementAudit">
          拒绝
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>

    <el-dialog title="更新基本信息" :close-on-click-modal="false"
               :visible.sync="baseFormDialogVisible" :modal="false">
      <requirement-order-base-form ref="statusForm"
                                   :slot-data="baseData"
                                   :read-only="false">
      </requirement-order-base-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="baseFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitBaseForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新订单状态" width="240px"
               :visible.sync="statusFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-update-status-form ref="statusForm"
                                            :slot-data="statusData"
                                            :read-only="false">
      </requirement-order-update-status-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="statusFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitStatusForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新地址"
               :visible.sync="addressFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-delivery-address-form ref="addressForm"
                                               :slot-data="addressData"
                                               :read-only="false">
      </requirement-order-delivery-address-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addressFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitAddressForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新订单行" width="80%"
               :visible.sync="entriesFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-entries-form ref="entriesForm"
                                      :slot-data="entriesData"
                                      :read-only="false">
      </requirement-order-entries-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="entriesFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitEntriesForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="更新需求信息" width="60%"
               :visible.sync="requestFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="requestData"
                                      :read-only="false">
      </requirement-order-request-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="requestFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitRequestForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="上传" width="60%"
               :visible.sync="contractsFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-media-upload-form ref="contractsForm"
                                           :slot-data="contractsData"
                                           :read-only="false">
      </requirement-order-media-upload-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="contractsFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitContractsForm">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="BOM文件上传" width="60%"
               :visible.sync="bomFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-bom-upload-form ref="bomForm"
                                           :slot-data="bomData"
                                           :read-only="false">
      </requirement-order-bom-upload-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="bomFormDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="onSubmitContractsForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from "axios";
  import RequirementOrderBaseForm from "./RequirementOrderBaseForm";
  import RequirementOrderDeliveryAddressForm from "./RequirementOrderDeliveryAddressForm";
  import RequirementOrderRequestForm from "./RequirementOrderRequestForm";
  import RequirementOrderEntriesForm from "./RequirementOrderEntriesForm";
  import RequirementOrderUpdateStatusForm from "./RequirementOrderUpdateStatusForm";
  import RequirementOrderContractsForm from "./RequirementOrderContractsForm";
  import RequirementOrderMediaUploadForm from "./RequirementOrderMediaUploadForm";
  import RequirementOrderStatusBar from "./RequirementOrderStatusBar";
  import RequirementOrderBomForm from "./RequirementOrderBomForm";
  import RequirementOrderBomUploadForm from "./RequirementOrderBomUploadForm";

  export default {
    name: "RequirementOrderDetailsPage",
    props: ["slotData", "readOnly", "preview"],
    components: {
      RequirementOrderStatusBar,
      RequirementOrderMediaUploadForm,
      RequirementOrderRequestForm,
      RequirementOrderBaseForm,
      RequirementOrderDeliveryAddressForm,
      RequirementOrderEntriesForm,
      RequirementOrderUpdateStatusForm,
      RequirementOrderContractsForm,
      RequirementOrderBomForm,
      RequirementOrderBomUploadForm
    },
    methods: {
      onConfirmRequirementAudit() {
        this.$confirm('是否确认审核', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put("/djbrand/processes/requirementOrder/confirmRequirementAudit/" + this.slotData.code)
            .then(response => {
              this.$message.success("审核确认成功");

              this.$set(this.slotData, "status", response.data);
            }).catch(error => {
              this.$message.error("审核确认失败，原因：" + error.response.data.message);
            }
          );
        }).catch(() => {
        });


      },
      onRejectRequirementAudit() {
        this.$confirm('是否拒绝审核', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put("/djbrand/processes/requirementOrder/rejectRequirementAudit/" + this.slotData.code, "TODO：拒绝原因")
            .then(response => {
              this.$message.success("审核拒绝成功");

              this.$set(this.slotData, "status", response.data);
            }).catch(error => {
              this.$message.error("审核拒绝失败，原因：" + error.response.data.message);
            }
          );
        }).catch(() => {
        });
      },
      onUpdateBase() {
        Object.assign(this.baseData, {
          code: this.slotData.code,
          type: this.slotData.type,
          description: this.slotData.description,
          depositPaid: this.slotData.depositPaid,
          retainagePaid: this.slotData.retainagePaid,
          depositAmount: this.slotData.depositAmount,
          retainageAmount: this.slotData.retainageAmount
        });

        this.baseFormDialogVisible = true;
      },
      onSubmitBaseForm() {
        axios.put("/djbrand/requirementOrder/base", this.baseData)
          .then(() => {
            this.$message.success("更新基本信息成功");

            this.$set(this.slotData, "description", this.baseData.description);
            this.$set(this.slotData, "depositPaid", this.baseData.depositPaid);
            this.$set(this.slotData, "retainagePaid", this.baseData.retainagePaid);
            this.$set(this.slotData, "depositAmount", this.baseData.depositAmount);
            this.$set(this.slotData, "retainageAmount", this.baseData.retainageAmount);

            this.baseFormDialogVisible = false;
          }).catch(error => {
          console.log(JSON.stringify(error));
          this.$message.error("更新基本信息失败，原因：" + error.response.data.message);
        });
      },
      onSubmitStatusForm() {
        axios.put("/djbrand/requirementOrder/status", {
          code: this.slotData.code,
          status: this.statusData.status
        }).then(() => {
          this.$message.success("更新订单状态成功");

          this.$set(this.slotData, "status", this.statusData.status);

          this.statusFormDialogVisible = false;
        }).catch(error => {
          this.$message.error("更新订单状态失败，原因：" + error.response.data.message);
        });
      },
      onUpdateAddress() {
        Object.assign(this.addressData.deliveryAddress, this.slotData.deliveryAddress);
        this.addressFormDialogVisible = true;
      },
      onSubmitAddressForm() {
        this.$refs["addressForm"].validate((valid) => {
          if (valid) {
            axios.put("/djbrand/requirementOrder/deliveryAddress", {
              code: this.slotData.code,
              deliveryAddress: this.addressData.deliveryAddress
            }).then(() => {
              this.$message.success("更新地址成功");

              this.addressFormDialogVisible = false;
            }).catch(error => {
              console.log(JSON.stringify(error));
              this.$message.error("更新地址失败，原因：" + error.response.data.message);
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
        if (this.$refs["entriesForm"].validate()) {
          axios.put("/djbrand/requirementOrder/entries", {
            code: this.slotData.code,
            entries: this.entriesData.entries
          }).then(() => {
            this.$message.success("更新订单行成功");
            //避免保存后数据出错，重新给slotData赋值
            this.$set(this.slotData, "entries", this.entriesData.entries);
            this.entriesFormDialogVisible = false;
          }).catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error("更新订单行失败，原因：" + error.response.data.message);
          });
        }
      },
      onUpdateBom(){
        this.bomFormDialogVisible = true;
      },
      onUpdateRequest() {
        Object.assign(this.requestData.details, this.slotData.details);
        this.requestFormDialogVisible = true;
      },
      onSubmitRequestForm() {
        this.$refs["requestForm"].validate((valid) => {
          if (valid) {
            axios.put("/djbrand/requirementOrder/request", {
              code: this.slotData.code,
              details: this.requestData.details
            }).then(() => {
              this.$message.success("更新需求信息成功");

              this.$set(this.slotData, "details", this.requestData.details);

              this.requestFormDialogVisible = false;
            }).catch(error => {
              console.log(JSON.stringify(error));
              this.$message.error("更新需求信息失败，原因：" + error.response.data.message);
            });

            return true;
          }

          return false;
        })
      },
      onUpdateContracts() {
        this.contractsFormDialogVisible = true;
      },
      onSubmitContractsForm() {
        this.$refs["contractsForm"].onSubmit();
      }
    },
    computed: {
      isPendingApproval: function () {
        return this.slotData.status === "PENDING_APPROVAL";
      }
    },
    data() {
      return {
        bomFormDialogVisible:false,
        baseFormDialogVisible: false,
        baseData: {
          id: null,
          code: this.slotData.code,
          type: this.slotData.type,
          description: this.slotData.description,
          depositPaid: this.slotData.depositPaid,
          retainagePaid: this.slotData.retainagePaid,
          depositAmount: this.slotData.depositAmount,
          retainageAmount: this.slotData.retainageAmount
        },
        statusFormDialogVisible: false,
        statusData: {
          id: null,
          code: this.slotData.code,
          status: this.slotData.status
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
          entries: []
        },
        requestFormDialogVisible: false,
        requestData: {
          id: null,
          details: {
            category: {
              code: "",
              name: ""
            },
            majorCategory: {
              code: "",
              name: ""
            },
            expectedMachiningQuantity: 0,
            expectedDeliveryDate: null,
            minExpectedPrice: 0,
            maxExpectedPrice: 0,
            machiningType: "",
            samplesNeeded: false,
            contactPerson: "",
            contactPHone: ""
          }
        },
        contractsFormDialogVisible: false,
        contractsData: {
          code: this.slotData.code
        },
        bomData:{
          code: this.slotData.code
        }
      }
    }
  }
</script>
