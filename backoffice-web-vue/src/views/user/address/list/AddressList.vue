<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="results" :height="autoHeight">
      <el-table-column label="联系人" prop="fullname"></el-table-column>
      <el-table-column label="联系电话" prop="cellphone"></el-table-column>
      <el-table-column label="联系地址">
        <template slot-scope="scope">
          <full-address :slot-data="scope.row"/>
        </template>
      </el-table-column>
      <el-table-column label="是否默认" prop="defaultAddress">
        <template slot-scope="scope">
          <div>{{scope.row.defaultAddress ? '是': '否'}}</div>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onSetDefault(scope.row)">设置为默认</el-button>
          <authorized :authority="permission.companyAddressRemove">
            <el-button type="text" icon="el-icon-delete" @click="onRemove(scope.row)">删除</el-button>
          </authorized>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  import FullAddress from '@/views/shared/user/address/FullAddress';

  export default {
    name: 'AddressList',
    components: {FullAddress},
    props: ['results'],
    computed: {},
    methods: {
      onSetDefault (row) {
        this.$emit('onSetDefault', row);
      },
      onRemove (row) {
        this.$confirm('此操作将永久删除该地址, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$emit('onRemove', row);
        })
      }
    },
    data () {
      return {
      }
    }
  }
</script>
