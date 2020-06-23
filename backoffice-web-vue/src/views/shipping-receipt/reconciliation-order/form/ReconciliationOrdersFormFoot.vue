<template>
  <div class="form-foot">
    <template v-for="(item, index) in formData.chargedDetail">
      <el-row type="flex" align="middle">
        <el-col :span="1">
          <el-button v-if="index == 0 && !readOnly" icon="el-icon-plus" class="circle-btn" circle @click="addReduceRow"></el-button>
        </el-col>
        <el-col :span="7">
          <el-form-item label="扣款金额">
            <el-input v-model="item.price" :disabled="readOnly"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="16">
          <el-form-item label="扣款原因">
            <el-col :span="24">
              <el-input v-model="item.remarks" :disabled="readOnly"></el-input>
            </el-col>
          </el-form-item>
        </el-col>
      </el-row>
    </template>
    <div class="pt-4"></div>
    <template v-for="(item, index) in formData.increaseDetail">
      <el-row type="flex" align="middle">
        <el-col :span="1">
          <el-button v-if="index == 0 && !readOnly" icon="el-icon-plus" class="circle-btn" circle @click="addIncreaseRow"></el-button>
        </el-col>
        <el-col :span="7">
          <el-form-item label="增款金额">
            <el-input v-model="item.price" :disabled="readOnly"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="16">
          <el-form-item label="增款原因">
            <el-input v-model="item.remarks" :disabled="readOnly"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </template>
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
      addReduceRow () {
        this.formData.chargedDetail.push({
          price: '',
          remarks: ''
        })
      },
      addIncreaseRow () {
        this.formData.increaseDetail.push({
          price: '',
          remarks: ''
        })
      }
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
  .form-foot >>> .el-form-item {
    margin-bottom: 0px;
  }

  .circle-btn {
    outline:none;
    background-color: #333;
    color: white;
    margin-bottom: 0.5rem;
    transform: scale(0.8, 0.8);
  }
</style>