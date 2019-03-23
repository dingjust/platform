<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="!readOnly">
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
    name: 'EmployeeRolesForm',
    props: ['slotData', 'readOnly'],
    computed: {

    },
    methods: {
      async getRoles() {
        const results = await this.$http.get(this.apis().getAllRoles());
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }

        this.roles = results;
      }
    },
    data() {
      return {
        roles: []
      };
    },
    created() {
      this.getRoles();
    }
  };
</script>
