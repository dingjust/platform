<template>
  <div class="animated fadeIn proofing-basic">
    <el-row style="margin: 20px 0px">
      <h6 class="titleTextClass2">合作商信息</h6>
    </el-row>
    <el-row type="flex">
      <el-col :span="5">
        <h6 class="titleTextClass">合作商</h6>
      </el-col>
      <el-col :span="19">
        <h6 class="contentTextClass">{{isFactory() ? slotData.supplier.name : slotData.belongTo.name}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex">
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="10">
            <h6 class="titleTextClass">联系人</h6>
          </el-col>
          <el-col :span="14">
            <h6 class="contentTextClass">{{isFactory() ? slotData.supplier.contactPerson : slotData.belongTo.contactPerson}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="10">
            <h6 class="titleTextClass">联系方式</h6>
          </el-col>
          <el-col :span="14">
            <h6 class="contentTextClass">{{isFactory() ? slotData.supplier.contactPhone : slotData.belongTo.contactPhone}}</h6>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('ProofingsModule');

  export default {
    name: 'ProofingCooperatorInfoPage',
    props: {
      slotData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    components: {
    },
    computed: {
      ...mapGetters({

      }),
    },
    methods: {
      ...mapMutations({
      }),
      ...mapActions({
      })

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
  .proofing-basic .rowClass{
    margin-bottom:10px;
  }
  .proofing-basic .rowClass2{
    margin-bottom:20px;
  }
  .proofing-basic .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-weight: bold;
  }
  .proofing-basic .titleTextClass2{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    font-weight: bold;
  }
  .proofing-basic .contentTextClass{
    color: #A9A9A9;
    font-weight: 400;
  }
</style>
