<template>
  <div class="animated fadeIn">
    <el-steps align-center
              finish-status="success"
              :active="active">
      <el-step title="待处理"></el-step>
      <el-step title="已确认"></el-step>
    </el-steps>
  </div>
</template>

<script>
  import {PickOrderMixin} from '../../../../mixins';

  export default {
    name: 'PickOrderStatusBar',
    props: ['status'],
    mixins: [PickOrderMixin],
    methods: {},
    computed: {
      active: function () {
        return this.pickOrderStatusProcessFlow[this.status];
      }
    }
  }
</script>
