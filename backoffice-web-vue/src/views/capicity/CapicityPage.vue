<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="capacity-list-title">
            <h6>空闲产能</h6>
          </div>
        </el-col>
      </el-row>
      <capacity-search-result-list class="capacity-list" :page="page" @onDetails="onDetails" @onSearch="onSearch" />
    </el-card>
  </div>
</template>

<script>
import { createNamespacedHelpers } from "vuex";

import CapacitySearchResultList from "./list/CapacitySearchResultList";

const { mapGetters, mapActions, mapMutations } = createNamespacedHelpers(
  "CapacityModule"
);

import http from "@/common/js/http";

export default {
  name: "CapacityPage",
  components: {
    CapacitySearchResultList
  },
  computed: {
    ...mapGetters({
      page: "page"
    })
  },
  methods: {
    ...mapActions({
      search: "search"
    }),
    onSearch(page, size) {
      const url = this.apis().getCapacityList();
      this.search({
        url,
        page,
        size
      });
    },
    onNew(formData) {
      // this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
    },
    // handleClick(tab, event) {
    //   // console.log(tab.name);
    //   this.queryFormData.statuses = [tab.name];
    //   if (tab.name == 'ALL') {
    //     this.onSearch("");
    //   } else {
    //     this.onAdvancedSearch();
    //   }
    // },
    async onDetails(row) {
      // const url = this.apis().getPurchaseOrder(row.code);
      // const result = await this.$http.get(url);
      // if (result["errors"]) {
      //   this.$message.error(result["errors"][0].message);
      //   return;
      // }
      // // this.fn.openSlider('生产订单：' + result.code, PurchaseOrderDetailsPage, result);
      // this.contentData = result;
      // this.dialogDetailVisible = true;
    }
  },
  data() {
    return {
      // formData: this.$store.state.PurchaseOrdersModule.formData,
    };
  },
  created() {
    this.onSearch();
  },
  mounted() {}
};
</script>
<style scoped>
.capacity-list-title {
  border-left: 2px solid #ffd60c;
  padding-left: 10px;
}
.capacity-list{
  margin-top: 50px;
  margin-left: 50px;
  margin-right: 50px;
}
</style>
