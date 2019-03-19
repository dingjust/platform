<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="样衣编码" prop="code">
            <el-input placeholder="请输入样衣编码"
                      v-model="slotData.code">
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="样衣名称" prop="name">
            <el-input placeholder="请输入样衣名称"
                      v-model="slotData.name">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'SampleProductBasicForm',
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
