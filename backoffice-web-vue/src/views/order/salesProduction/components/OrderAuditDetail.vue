<template>
  <div class="order-audit-detail">
    <div class="basic-row">
      <div>
        <h6>审批人：</h6>
      </div>
      <div style="margin-left: 20px">
        <template v-for="(auditUser, index) in processes">
          <el-row type="flex" justify="start" align="middle" :key="index">
            <h6 style="margin-bottom: 15px">{{auditUser.auditUser.name}}</h6>
          </el-row>
        </template>
      </div>
      <div style="margin-left: 20px">
        <template v-for="(auditUser, index) in processes">
          <el-row type="flex" justify="start" align="middle" :key="index">
            <h6 style="margin: 0px 20px 15px 0px;">{{auditState[auditUser.state]}}</h6>
            <h6 style="margin-bottom: 15px">{{auditUser.auditTIme | formatDate}}</h6>
          </el-row>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OrderAuditDetail',
  props: {
   processes: {
     type: Array,
     default: () => []
   }
  },
  components: {},
  computed: {},
  data () {
    return {
      auditState: {
        AUDITING: '未审',
        PASSED: '通过',
        AUDITED_FAILED: '审批驳回'
      }
    }
  },
  methods: {

  },
  created () {

  }
}
</script>

<style scoped>
  .order-audit-detail {
    margin-top: 20px;
  }

  .basic-row {
    display: flex;
    justify-content: flex-start;
  }

  .basic-text {
    margin-left: 10px;
  }
</style>