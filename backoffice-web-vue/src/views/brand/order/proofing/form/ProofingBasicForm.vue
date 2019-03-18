<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="报价单号" prop="code">
            <el-input placeholder="请输入报价单号"
                      v-model="slotData.code">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ProofingBasicForm',
    props: ['slotData', 'readOnly'],
    mixins: [],
    computed: {},
    methods: {},
    data() {
      return {
        machiningTypes: this.$store.state.EnumsModule.machiningTypes
      }
    },
    created() {
    }
  }
</script>
