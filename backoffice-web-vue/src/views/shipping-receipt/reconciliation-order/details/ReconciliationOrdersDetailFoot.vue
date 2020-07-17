<template>
  <div class="form-foot">
    <el-form :model="formData" ref="footForm">
      <template v-for="(item, index) in formData.deductions">
        <el-row type="flex" align="middle" :key="'ar'+index" style="margin-top:5px">
          <el-col :span="1" v-if="index == 0 && !readOnly">
            <el-button icon="el-icon-plus" class="circle-btn" circle @click="addReduceRow">
            </el-button>
          </el-col>
          <el-col :span="1" v-if="index != 0 && !readOnly">
            <el-button icon="el-icon-minus" class="circle-btn" circle @click="removeDeductionsRow(index)">
            </el-button>
          </el-col>
          <el-col :span="8">
            <el-form-item label="扣款金额" :prop="'deductions.'+index+'.amount'"
              :rules="{ required: true, message: '请输入金额', trigger: 'blur' }">
              <el-input v-model="item.amount" :disabled="readOnly" v-number-input.float="{ min: 0 ,decimal:2}">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="14">
            <el-form-item label="扣款原因">
              <el-input v-model="item.remarks" :disabled="readOnly"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </template>
      <div class="pt-4"></div>
      <template v-for="(item, index) in formData.increases">
        <el-row type="flex" align="middle" :key="'ad'+index">
          <el-col :span="1" v-if="index == 0 && !readOnly">
            <el-button icon="el-icon-plus" class="circle-btn" circle @click="addIncreaseRow"></el-button>
          </el-col>
          <el-col :span="1" v-if="index != 0 && !readOnly">
            <el-button icon="el-icon-minus" class="circle-btn" circle @click="removeIncreaseRow(index)">
            </el-button>
          </el-col>
          <el-col :span="8">
            <el-form-item label="增款金额" :prop="'increases.'+index+'.amount'"
              :rules="{ required: true, message: '请输入金额', trigger: 'blur' }">
              <el-input v-model="item.amount" :disabled="readOnly" v-number-input.float="{ min: 0 ,decimal:2}">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="14">
            <el-form-item label="增款原因">
              <el-input v-model="item.remarks" :disabled="readOnly"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </template>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ReconciliationOrdersFormFoot',
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
      addReduceRow() {
        this.formData.deductions.push({
          amount: null,
          remarks: null
        })
      },
      addIncreaseRow() {
        this.formData.increases.push({
          amount: null,
          remarks: null
        })
      },
      removeDeductionsRow(index) {
        this.formData.deductions.splice(index, 1);
      },
      removeIncreaseRow(index) {
        this.formData.increases.splice(index, 1);
      }
    },
    data() {
      return {

      }
    },
    created() {

    }
  }

</script>

<style scoped>
  .form-foot>>>.el-form-item {
    margin-bottom: 0px;
  }

  .circle-btn {
    outline: none;
    background-color: #333;
    color: white;
    margin-bottom: 0.5rem;
    transform: scale(0.8, 0.8);
  }

</style>
