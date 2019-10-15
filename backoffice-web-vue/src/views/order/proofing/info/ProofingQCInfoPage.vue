<template>
  <div class="animated fadeIn proofing-basic">
    <el-row style="margin: 20px 0px">
      <h6 class="titleTextClass2">人员设置</h6>
    </el-row>
    <el-row type="flex">
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="12">
            <h6 class="titleTextClass2">品牌跟单员</h6>
          </el-col>
          <el-col :span="12">
            <h6 class="contentTextClass">{{slotData.brandOperator == null ? '未指定' : slotData.brandOperator.name}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="10">
            <h6 class="titleTextClass">联系电话</h6>
          </el-col>
          <el-col :span="14">
            <h6 class="contentTextClass">{{slotData.brandOperator == null ? '未指定' : slotData.brandOperator.mobileNumber}}</h6>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex">
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="12">
            <h6 class="titleTextClass2">工厂跟单员</h6>
          </el-col>
          <el-col :span="12">
            <h6 class="contentTextClass">{{slotData.factoryOperator == null ? '未指定' : slotData.factoryOperator.name}}</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="10">
            <h6 class="titleTextClass">联系电话</h6>
          </el-col>
          <el-col :span="14">
            <h6 class="contentTextClass">{{slotData.factoryOperator == null ? '未指定' : slotData.factoryOperator.mobileNumber}}</h6>
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
    name: 'ProofingQCInfoPage',
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
    width: 70px;
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
