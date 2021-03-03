<template>
  <div class="animated fadeIn">
    <el-row class="cooperator-info-title-row">
      <div class="cooperator-info-title">
        <h6 class="cooperator-info-title_text">查看合作商</h6>
      </div>
    </el-row>
    <cooperator-info-page :itemData="itemData"></cooperator-info-page>
    <el-row v-if="itemData.type == 'ONLINE'" class="cooperator-info-title-row">
      <div class="cooperator-info-title">
        <h6 class="cooperator-info-title_text">合作历史</h6>
      </div>
    </el-row>
    <cooperator-order-list v-if="itemData.type == 'ONLINE'" :page="orderPage" @onSearch="onSearch"></cooperator-order-list>
    <el-row type="flex" style="margin-top: 20px">
      <form-label label="附件" />
    </el-row>
    <el-row type="flex" justify="start" v-if="itemData.attachments">
      <files-upload ref="filesUpload" :slotData="itemData.attachments" :limit="20" :readOnly="true" :disabled="true"/>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters} = createNamespacedHelpers('CooperatorModule');

  import CooperatorInfoPage from '@/views/miscs/cooperator/info/CooperatorInfoPage';
  import CooperatorOrderList from '../list/CooperatorOrderList';
  import { FilesUpload, FormLabel } from '@/components';

  export default {
    name: 'CooperatorDetailsPage',
    props: ['itemData'],
    components: {CooperatorOrderList, CooperatorInfoPage, FilesUpload, FormLabel},
    computed: {
      ...mapGetters({
        orderPage: 'orderPage'
      })
    },
    methods: {
      onSearch (page, size) {
        this.$emit('onSearchOrders');
      }
    },
    data () {
      return {

      }
    },
    created () {

    }
  }
</script>

<style scoped>
  .cooperator-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .cooperator-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .cooperator-info-title-row {
    margin-bottom: 20px;
  }
</style>
