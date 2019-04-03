<template>
  <div class="animated fadeIn">
    <el-button v-if="isFactory() && slotData.finishDate == null" type="text" icon="el-icon-edit"
               @click="updateVisible = true">
      修改
    </el-button>
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="生产阶段" prop="phase">
            <el-select v-model="slotData.phase" placeholder="请选择">
              <el-option
                v-for="item in productionProgressPhaseTypes"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="数量" prop="quantity">
            <el-input-number v-model="slotData.quantity" :min="0"></el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="4">
          <el-form-item label="预计完成日期" prop="estimatedDate">
            <el-date-picker
              v-model="slotData.estimatedDate"
              type="date"
              value-format="timestamp"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item label="实际完成日期" prop="finishDate">
            <el-date-picker
              v-model="slotData.finishDate"
              type="date"
              value-format="timestamp"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="延期天数" prop="delayedDays">
            <el-input v-model="slotData.delayedDays"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="备注" prop="remarks">
            <el-input v-model="slotData.remarks"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="附件" prop="attachments">
            <purchase-order-attachments-form :slot-data="slotData" :read-only="readOnly"/>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>

    <el-dialog title="修改" width="600px" :visible.sync="this.updateVisible" :before-close="handleClose"
               append-to-body>
      <purchase-order-update-form :slotData = "slotData"></purchase-order-update-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="submit()">更新</el-button>
        <el-button type="primary" @click="submit(true)">完成</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import PurchaseOrderAttachmentsForm from "./PurchaseOrderAttachmentsForm";
  import PurchaseOrderUpdateForm from "./PurchaseOrderUpdateForm";

  export default {
    name: 'PurchaseOrderProgressForm',
    props: ['slotData', 'readOnly'],
    components: {
      PurchaseOrderAttachmentsForm,
      PurchaseOrderUpdateForm,
    },
    mixins: [],
    computed: {},
    methods: {
      handleClose(done) {
        this.updateVisible = false;
      },
      submit(finish) {
        if (finish) {
          this.slotData.updateOnly = false;
        } else {
          this.slotData.updateOnly = true;
        }
        this.$emit('onSubmit', this.slotData);
        this.updateVisible = false;
      },
    },
    data() {
      return {
        updateVisible:false,
        productionProgressPhaseTypes: this.$store.state.EnumsModule.productionProgressPhaseTypes,
      }
    },
    created() {
    }
  }
</script>
