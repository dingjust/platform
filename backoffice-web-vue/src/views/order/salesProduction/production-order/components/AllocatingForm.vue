<template>
  <div>
    <el-row type="flex" justify="center" align="middle">
      <el-col :span="6">
        <h6>生产工单分配</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="4">
        <h6 style="margin-bottom: 0px;">生产类型：</h6>
        <i class="el-icon-question" style="margin-left: 20px;font-size: 16px;" v-popover:popover/>
      </el-col>
      <el-col :span="8">
        <el-radio-group v-model="formData.type">
          <el-radio :label="'SELF_PRODUCED'">自产</el-radio>
          <el-radio :label="'FOUNDRY_PRODUCTION'">外发</el-radio>
        </el-radio-group>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 5px;height: 48px">
      <el-col :span="4">
        <h6 style="margin-bottom: 0px;margin-top: 8px;">跟单员：</h6>
      </el-col>
      <el-col :span="8">
        <personnel-selection :vPerson.sync="formData.merchandiser"/>
        <h6 style="color: #F56C6C;margin-bottom: 0px" v-show="validatevisible">{{this.validatevisible ? '请选择跟单员' : '  '}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 10px">
      <el-col :span="4">
        <el-button @click="onCancel">取消</el-button>
      </el-col>
      <el-col :span="4">
        <el-button class="color: #409EFF" @click="onSumbit">确定</el-button>
      </el-col>
    </el-row>
    <el-popover placement="top-start" width="250" trigger="hover" ref="popover">
      <div>
        <h6>自产：该工单自己生产不做外发</h6>
        <h6>外发：该工单需要外发工厂生产</h6>
      </div>
    </el-popover>  
  </div>
</template>

<script>
  import PersonnelSelection from '@/components/custom/PersonnelSelection'
  export default {
    name: 'AllocatingForm',
    props: ['slotData'],
    components: {PersonnelSelection},
    computed: {

    },
    methods: {
      onCancel () {
        this.$emit('onCallback', false);
      },
      async onSumbit () {
        if (this.formData.merchandiser.id === '') {
          this.validatevisible = true;
          return;
        }
        let data = {
          merchandiser: this.formData.merchandiser.id,
          type: this.formData.type
        }
        data.taskOrderIds = this.slotData.map(item => item.id);
        const url = this.apis().allocatingProductionOrder();
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$emit('onCallback', true);
      }
    },
    data () {
      return {
        validatevisible: false,
        formData: {
          type: 'SELF_PRODUCED',
          merchandiser: {
            id: ''
          },
          taskOrderIds: []
        }
      }
    },
    created () {

    }    
  }
</script>

<style scoped>

</style>