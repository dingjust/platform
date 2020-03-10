<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between" align="middle">
        <div class="capacity-list-title1">
          <h6>空闲产能</h6>
        </div>
        <Authorized :authority="permission.factoryCapacityPublish">
          <el-button class="capacity-btn" @click="onNew">发布新产能</el-button>
        </Authorized>
      </el-row>
      <capacity-search-result-list class="capacity-list" :page="page" @onDetails="onDetails" @onSearch="onSearch" />
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";

  import CapacitySearchResultList from "./list/CapacitySearchResultList";

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
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
      onNew() {
        this.$router.push({
          name: "发布产能"
        });
      },
      async onDetails(code) {
        const url = this.apis().getCapacityByCode(code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code == 1) {
          let formData = {};
          Object.assign(formData, result.data);
          this.$router.push({
            name: '发布产能',
            params: {
              formData: formData
            }
          });
        }
      }
    },
    data() {
      return {
        // formData: this.$store.state.CapacityModule.formData
      };
    },
    created() {
      this.onSearch();
    },
    mounted() {}
  };

</script>
<style scoped>
  .capacity-list-title1 {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .capacity-list {
    margin-top: 50px;
    margin-left: 50px;
    margin-right: 50px;
  }

  .capacity-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100px;
  }

</style>
