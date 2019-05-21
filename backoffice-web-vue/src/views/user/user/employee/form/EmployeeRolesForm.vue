<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="!readOnly">
      <el-row :gutter="10">
        <el-form-item label="角色" prop="roles">
          <el-select class="w-100" v-model="slotData.roles" multiple placeholder="请选择"
                     value-key="id">
            <el-option
              v-for="item in roles"
              :key="item.id"
              :label="item.name"
              :value="item">
            </el-option>
          </el-select>
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
