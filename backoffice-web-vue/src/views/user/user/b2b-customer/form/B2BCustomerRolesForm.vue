<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly">
      <el-row :gutter="10">
        <el-form-item label="角色" prop="roles">
          <el-checkbox-group v-model="slotData.roles">
            <el-checkbox v-for="item in roles" :label="item.uid" :key="item.uid">
              {{item.name}}
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'B2BCustomerRolesForm',
    props: ['slotData', 'readOnly'],
    methods: {
      async getRoles() {
        const results = await this.$http.get('/djbackoffice/role?text=');
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }

        this.roles = results.content;
      }
    },
    data() {
      return {
        roles: []
      };
    },
    created() {
    }
  };
</script>
