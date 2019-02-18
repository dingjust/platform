<template>
  <div class="animated fadeIn">
    <div class="pt-2"></div>
    <el-form ref="form" :model="slotData">
      <el-form-item label="">
        <el-select class="w-100"
                   placeholder="请输入工厂编码/名称查询"
                   filterable
                   remote
                   reserve-keyword
                   clearable
                   v-model="slotData.assignedTo.uid"
                   :remote-method="onFilter"
                   @change="onSelected">
          <el-option
            v-for="item in companies"
            :key="item.uid"
            :label="item.name"
            :value="item.uid">
          </el-option>
        </el-select>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ConsignmentFactorySearchForm',
    props: ['slotData'],
    components: {},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async onFilter(query) {
        this.companies = [];
        if (query !== '') {
          const result = await this.$http.get('/djfactory/b2bFactory', {
            name: query
          });

          if (result["errors"]) {
            this.$message.error(result["errors"][0].message);
            return;
          }

          this.companies = result.content;
        }
      },
      onSelected(current) {
        const slotData = this.slotData;
        this.companies.filter(value => {
          return current === value.uid;
        }).forEach(company => {
          this.showDetails = true;
          this.company = company;
          this.$set(slotData, 'assignedTo', company);
        });
      }
    },
    computed: {},
    data() {
      return {
        text: '',
        showDetails: false,
        company: {},
        companies: [],
      }
    }
  }
</script>
