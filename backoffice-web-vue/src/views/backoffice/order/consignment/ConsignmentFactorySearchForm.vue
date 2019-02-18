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
                   v-model="slotData.assignedTo"
                   :remote-method="onFilter">
          <el-option
            v-for="item in companies"
            :key="item.uid"
            :label="item.name"
            :value="item">
          </el-option>
        </el-select>
      </el-form-item>
    </el-form>
    <div class="pt-2"></div>
    <consignment-factory-base-form v-show="showDetails"
                                   :slot-data="slotData.assignedTo"
                                   :read-only="true">
    </consignment-factory-base-form>
  </div>
</template>

<script>
  import ConsignmentFactoryBaseForm from './ConsignmentFactoryBaseForm';

  export default {
    name: 'ConsignmentFactorySearchForm',
    props: ['slotData'],
    components: {ConsignmentFactoryBaseForm},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async onFilter(query) {
        this.companies = [];
        if (query !== '') {
          const result = await this.$http.get('/djfactory/factory', {
            text: query
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
          console.log(company);
          this.showDetails = true;
          this.company = company;
          this.$set(slotData, 'assignedTo', company);
        });
      }
    },
    computed: {
      showDetails: function () {
        return this.slotData.assignedTo && this.slotData.assignedTo.uid;
      }
    },
    data() {
      return {
        text: '',
        company: {},
        companies: [],
        loading: false
      }
    }
  }
</script>
