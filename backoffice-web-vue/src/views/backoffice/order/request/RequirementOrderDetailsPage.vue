<template>
  <div class="animated fadeIn">
    <requirement-order-status-bar :status="slotData.status"></requirement-order-status-bar>
    <div v-show="isWaitForProcessing" class="pt-2"></div>
    <el-row v-show="isWaitForProcessing" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onRequirementAudit">
          提交审核
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isApproved" class="pt-2"></div>
    <el-row v-show="isApproved" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onConfirmProduction">
          确认生产
        </el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right" v-show="!readOnly">
          <!-- 基本信息始终放开 -->
           <el-button type="primary" size="mini" @click="onUpdateBase">
             编辑
           </el-button>
          <!--<el-button type="primary" size="mini" @click="onUpdateStatus">更新状态</el-button>-->
        </span>
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
           <el-button type="primary" size="mini" @click="onUpdateAddress" v-show="!disableEdit">
             编辑
           </el-button>
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
           <el-button type="primary" size="mini" @click="onUpdateRequest" v-show="!disableEdit">
             编辑
           </el-button>
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
           <el-button type="primary" size="mini" @click="onUpdateEntries" v-show="!disableEdit">
             编辑
           </el-button>
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
        <span class="float-right" v-show="!readOnly">
           <el-button type="primary" size="mini" @click="onUpdateContracts" v-show="!disableEdit">
             编辑
           </el-button>
        </span>
      </div>
      <requirement-order-contracts-form ref="contractsForm"
                                        :slot-data="slotData"
                                        :read-only="true">
      </requirement-order-contracts-form>
    </el-card>
    <div v-show="isWaitForProcessing" class="pt-2"></div>
    <el-row v-show="isWaitForProcessing" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onRequirementAudit">
          提交审核
        </el-button>
      </el-col>
    </el-row>
    <div v-show="isApproved" class="pt-2"></div>
    <el-row v-show="isApproved" :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" type="primary" size="mini" @click="onConfirmProduction">
          确认生产
        </el-button>
      </el-col>
    </el-row>

    <el-dialog title="更新基本信息"
               :visible.sync="baseFormDialogVisible" :close-on-click-modal="false" :modal="false">
      <requirement-order-base-form ref="statusForm"
                                   :slot-data="baseData"
                                   :belong-to-editable="false"
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
                                           :order-data="slotData"
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
      onRequirementAudit() {
        if (!this.slotData.entries || !this.slotData.entries.length) {
          this.$message.error("订单行为空，不允许提交审核！");
          return;
        }
        this.$confirm('是否确认提交审核', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put("/djbackoffice/processes/requirementOrder/requirementAudit/" + this.slotData.code)
            .then(response => {
              this.$message.success("提交审核成功");

              // 待确认
              this.$set(this.slotData, "status", response.data);
            }).catch(error => {
              this.$message.error("提交审核失败，原因：" + error.response.data.message);
            }
          );
        });
      },
      onConfirmProduction() {
        this.$confirm('是否确认生产', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put("/djbackoffice/processes/requirementOrder/confirmProduction/" + this.slotData.code)
            .then(response => {
              this.$message.success("确认生产成功");

              // 待出库
              this.$set(this.slotData, "status", response.data);
            }).catch(error => {
              this.$message.error("确认生产失败，原因：" + error.response.data.message);
            }
          );
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
          retainageAmount: this.slotData.retainageAmount,
          belongTo: this.slotData.belongTo
        });

        this.baseFormDialogVisible = true;
      },
      onSubmitBaseForm() {
        axios.put("/djbackoffice/requirementOrder/base", this.baseData)
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
      onUpdateStatus() {
        this.statusFormDialogVisible = true;
      },
      onSubmitStatusForm() {
        axios.put("/djbackoffice/requirementOrder/status", {
          code: this.slotData.code,
          status: this.statusData.status
        }).then(() => {
          this.$message.success("更新订单状态成功");

          this.$set(this.slotData, "status", this.statusData.status);

          this.statusFormDialogVisible = false;
        }).catch(error => {
          this.$message.error("更新订单状态失败，原因：" + error.response.data);
        });
      },
      onUpdateAddress() {
        Object.assign(this.addressData.deliveryAddress,
          JSON.parse(JSON.stringify(this.slotData.deliveryAddress)));
        this.addressFormDialogVisible = true;
      },
      onSubmitAddressForm() {
        this.$refs["addressForm"].validate((valid) => {
          if (valid) {
            axios.put("/djbackoffice/requirementOrder/deliveryAddress", {
              code: this.slotData.code,
              deliveryAddress: this.addressData.deliveryAddress
            }).then(() => {
              this.$message.success("更新地址成功");

              this.addressFormDialogVisible = false;
            }).catch(error => {
              this.$message.error("更新地址失败，原因：" + this.getErrorMessage(error));
            });

            return true;
          }

          return false;
        });
      },
      onUpdateEntries() {
        // console.log(JSON.stringify(this.slotData.entries));
        Object.assign(this.entriesData.entries, JSON.parse(JSON.stringify(this.slotData.entries || [])));
        this.entriesFormDialogVisible = true;
      },
      onSubmitEntriesForm() {
        if (this.$refs["entriesForm"].validate()) {
          axios.put("/djbackoffice/requirementOrder/entries", {
            code: this.slotData.code,
            entries: this.entriesData.entries
          }).then(() => {
            this.$message.success("更新订单行成功");

            // 避免保存后数据出错，重新给slotData赋值
            this.$set(this.slotData, "entries", this.entriesData.entries);
            this.entriesFormDialogVisible = false;
          }).catch(error => {
            this.$message.error("更新订单行失败，原因：" + this.getErrorMessage(error));
          });
        }
      },
      onUpdateRequest() {
        Object.assign(this.requestData.details, JSON.parse(JSON.stringify(this.slotData.details)));
        this.requestFormDialogVisible = true;
      },
      onSubmitRequestForm() {
        this.$refs["requestForm"].validate((valid) => {
          if (valid) {
            axios.put("/djbackoffice/requirementOrder/request", {
              code: this.slotData.code,
              details: this.requestData.details
            }).then(() => {
              this.$message.success("更新需求信息成功");

              this.$set(this.slotData, "details", this.requestData.details);

              this.requestFormDialogVisible = false;
            }).catch(error => {
              // console.log(JSON.stringify(error));
              this.$message.error("更新需求信息失败，原因：" + this.getErrorMessage(error));
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
        //this.$refs["contractsForm"].refresh();
        this.contractsFormDialogVisible = false;
      },
      onUpdateBom() {
        this.bomFormDialogVisible = true;
      },
    },
    computed: {
      isWaitForProcessing: function () {
        return this.slotData.status === "WAIT_FOR_PROCESSING";
      },
      isApproved: function () {
        return this.slotData.status === "APPROVED";
      },
      disableEdit: function () {
        // 只有待处理状态下才允许修改信息
        return this.slotData.status !== "WAIT_FOR_PROCESSING";
      }
    },
    data() {
      return {
        bomFormDialogVisible: false,
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
        bomData: {
          code: this.slotData.code
        }
      }
    }
  }
</script>
