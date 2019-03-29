<template>
  <div class="animated fadeIn">

    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="生产阶段" prop="phase" >
            <el-input :disabled="true" v-model="slotData.phase"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="数量" prop="quantity">
            <el-input-number v-model="slotData.quantity" :min="0"></el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="预计完成日期" prop="estimatedDate">
            <el-date-picker
              v-model="slotData.estimatedDate"
              type="date"
              value-format="timestamp"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
        </el-col>

      </el-row>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="备注" prop="remarks">
            <el-input v-model="slotData.remarks"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="附件" prop="attachments">
            <purchase-order-attachments-form :slot-data="slotData" :read-only="readOnly"/>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>

  </div>
</template>

<script>
  import PurchaseOrderAttachmentsForm from "./PurchaseOrderAttachmentsForm";
  export default {
    name: 'PurchaseOrderProgressForm',
    props: ['slotData', 'readOnly'],
    components: {
      PurchaseOrderAttachmentsForm,
    },
    mixins: [],
    computed: {},
    methods: {},
    data() {
      return {
        updateVisible:false,
      }
    },
    created() {
    }
  }
</script>
