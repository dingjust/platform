<template>
  <div class="animated fadeIn proofing-basic">
    <el-row type="flex" style="margin-bottom: 10px">
      <el-col :span="12">
        <h6 style="font-weight: bold">品牌跟单员</h6>
      </el-col>
      <el-col :span="12">
        <h6 style="color: red" v-if="slotData.brandOperator == null">未指定</h6>
        <div v-else>
          <h6 class="contentTextClass" style="margin-bottom: 10px">{{slotData.brandOperator.name}}</h6>
          <h6 class="contentTextClass">{{slotData.brandOperator.mobileNumber}}</h6>
        </div>
      </el-col>
    </el-row>
    <el-row type="flex" style="margin-bottom: 10px">
      <el-col :span="12">
        <h6 style="font-weight: bold">工厂跟单员</h6>
      </el-col>
      <el-col :span="12">
        <h6 style="color: red" v-if="slotData.factoryOperator == null">未指定</h6>
        <div v-else>
          <h6 class="contentTextClass" style="margin-bottom: 10px">{{slotData.factoryOperator.name}}</h6>
          <h6 class="contentTextClass">{{slotData.factoryOperator.mobileNumber}}</h6>
        </div>
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
