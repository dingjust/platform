<!--
* @Description: 银行卡模块
* @Date 2021/09/22 15:35
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>银行卡配置</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <bank-toolbar @onAdvancedSearch="onAdvancedSearch" @onNew="visible=true"/>
      <bank-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onUpdate="onUpdate"/>
    </el-card>
    <el-dialog title="创建银行卡配置" :visible.sync="visible" width="400px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="form" label-width="80px" v-if="visible">
        <el-form-item label="银行名（含支行名称）" prop="bankName" :rules="[{ required: true, message: '请输入', trigger: 'blur' }]">
          <el-input v-model="form.bankName"></el-input>
        </el-form-item>
        <el-form-item label="卡号" prop="cardNumber" :rules="[{ required: true, message: '请输入', trigger: 'blur' }]">
          <el-input v-model="form.cardNumber"></el-input>
        </el-form-item>
        <el-form-item label="户名" prop="accountName" :rules="[{ required: true, message: '请输入', trigger: 'blur' }]">
          <el-input v-model="form.accountName"></el-input>
        </el-form-item>
        <!-- <el-form-item label="银行网点" prop="bankOutlet" :rules="[{ required: true, message: '请输入', trigger: 'blur' }]">
          <el-input v-model="form.bankOutlet" @keyup.enter.native="onConfirm"></el-input>
        </el-form-item> -->
      </el-form>
      <el-row type="flex" justify="end">
        <el-button type="default" @click="onCancel">取消</el-button>
        <el-button type="primary" @click="onConfirm">提交</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
import BankList from './list/BankList'
import BankToolbar from './toolbar/BankToolbar'

export default {
  name: 'BankPage',
  components: { BankList, BankToolbar },
  methods: {
    async onAdvancedSearch() {
      const url = this.apis().getBanks();
      const result = await this.$http.get(url)

      if (result.code === 1) {
        this.$set(this, 'page', result.data)
      }
    },
    onConfirm () {
      if (this.isCreate) return

      this.$refs.form.validate(valid => {
        if (valid) {
          this.$confirm('是否确认提交?', '', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this.isCreate = true
            this._onConfirm()
          });
        } else {
          this.$message.error('请完善表单信息！')
        }
      })
    },
    async _onConfirm () {
      const form = this.form

      const url = this.apis().createBank()
      const result = this.form.id ? await this.$http.put(url, form) : await this.$http.post(url, form)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.visible = false
        this.isCreate = false
        this.onAdvancedSearch();
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else {
        this.$message.error('操作失败！')
      }
    },
    onUpdate (row) {
      Object.assign(this.form, row)
      this.visible = true
    },
    onCancel () {
      this.form = {
        id: null,
        bankName: '',
        cardNumber: '',
        accountName: '',
        // bankOutlet: ''
      }
      this.visible = false
    }
  },
  data () {
    return {
      page: [],
      visible: false,
      isCreate: false,
      form: {
        id: null,
        bankName: '',
        cardNumber: '',
        accountName: '',
        bankOutlet: ''
      }
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>

</style>