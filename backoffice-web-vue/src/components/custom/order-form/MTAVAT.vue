<template>
  <!-- 订单表单组件:加工类型-是否发票-税点 -->
  <div class="matvat-container">
      <!-- <el-col :span="layoutScale[0]"> -->
        <el-form-item label="合作方式：" label-width="120" prop="machiningTypes" style="min-width: 300px;">
          <template v-for="(item,key) in machiningTypesEnum">
            <el-radio class="info-radio" :key="key" v-model="curMachiningTypes" :label="item.code" :disabled="readOnly">
              {{item.name}}
            </el-radio>
          </template>
        </el-form-item>
      <!-- </el-col> -->
      <!-- <el-col :span="layoutScale[1]"> -->
        <el-form-item label="是否开票：" label-width="120" prop="needVoice" style="min-width: 300px;">
          <el-radio v-model="curNeedVoice" :label="false" :disabled="readOnly">不开发票</el-radio>
          <el-radio v-model="curNeedVoice" :label="true" :disabled="readOnly">开发票</el-radio>
        </el-form-item>
      <!-- </el-col> -->
      <!-- <el-col :span="layoutScale[2]" v-if="curNeedVoice"> -->
        <el-form-item label="税点" label-width="60px" prop="tax" v-if="curNeedVoice" style="min-width: 160px;">
          <el-input v-model="curTax" 
                    placeholder="填写税点" 
                    :disabled="readOnly" 
                    size="mini"
                    @change="inputChange"
                    v-number-input.float="{ min: 0, decimal: 2, max: 100 }"
                    style="width:80px" >
            <span slot="suffix">%</span>
          </el-input>
          <!-- <el-select v-model="curTax" placeholder="选择税点" :disabled="readOnly" size="mini" style="width:80px">
            <el-option label="3%" :value="0.03" />
            <el-option label="6%" :value="0.06" />
            <el-option label="13%" :value="0.13" />
          </el-select> -->
        </el-form-item>
      <!-- </el-col> -->
  </div>
</template>

<script>
  export default {
    name: 'MTAVAT',
    props: {
      machiningTypes: {
        type: String,
        default: 'LABOR_AND_MATERIAL'
      },
      needVoice: {
        type: Boolean,
        default: false
      },
      tax: {
        type: Number,
        default: 0.03
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      //布局比例
      layoutScale: {
        type: Array,
        default: () => {
          return [9, 9, 5];
        }
      }
    },
    data() {
      return {
        machiningTypesEnum: this.$store.state.EnumsModule.machiningTypes,
        curMachiningTypes: this.machiningTypes,
        curNeedVoice: this.needVoice,
        curTax: this.tax
      };
    },
    methods: {
      inputChange () {
        const regexp = /^.*\.$/;
        if (regexp.test(this.curTax)) {
          this.curTax = Number.parseFloat(this.curTax);
        }
      }
    },
    watch: {
      machiningTypes: function (newVal, oldVal) {
        this.curMachiningTypes = newVal;
      },
      curMachiningTypes: function (newVal, oldVal) {
        this.$emit("update:machiningTypes", newVal);
      },
      needVoice: function (newVal, oldVal) {
        this.curNeedVoice = newVal;
      },
      curNeedVoice: function (newVal, oldVal) {
        this.$emit("update:needVoice", newVal);
      },
      tax: function (newVal, oldVal) {
        if(this.curTax!=newVal*100){
          this.curTax = newVal*100;
        }        
      },
      curTax: function (newVal, oldVal) {        
        this.$emit("update:tax", newVal*0.01);
      },
    },
    created () {
      this.curTax = this.tax * 100;
    }
  }

</script>

<style scoped>

.matvat-container {
  display: flex;
  justify-content: start;
  flex-wrap: wrap;
}

.matvat-container >>> .el-input__suffix {
    right: 5px;
}
</style>
