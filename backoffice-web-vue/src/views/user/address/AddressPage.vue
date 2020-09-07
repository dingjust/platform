<template>
  <div class="animated fadeIn content">
    <el-card>
      <!-- <el-row>
        <el-col :span="2">
          <div class="address-list-title">
            <h6>地址列表</h6>
          </div>
        </el-col>
      </el-row> -->
      <address-toolbar @onNew="visible=true"/>
      <hr/>
      <address-list :results="results" @onSetDefault="onSetDefault" @onRemove="onRemove" @onModify="onModify"/>
    </el-card>
    <el-dialog :visible.sync="visible" width="80%" append-to-body :close-on-click-modal="false">
      <address-form ref="address" v-if="visible" :slotData="slotData" :readOnly="readOnly"/>
      <el-row type="flex" justify="center" align="middle">
        <el-button type="primary" @click="onSubmit">提交</el-button>
        <el-button @click="visible=false">取消</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('AddressesModule');

  import AddressForm from '@/views/shared/user/address/AddressForm'
  import AddressToolbar from './toolbar/AddressToolbar';
  import AddressList from './list/AddressList';
  import AddressDetailsPage from './details/AddressDetailsPage';

  export default {
    name: 'AddressPage',
    components: {
      AddressToolbar,
      AddressList,
      AddressForm
    },
    computed: {
      ...mapGetters({
        results: 'results',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        refresh: 'refresh'
      }),
      onSearch() {
        const url = this.apis().getAddresses();
        this.search({url});
      },
      onSubmit () {
        this.$refs.address.$refs.form.validate((vaild) => {
          if (vaild) {
            if (this.slotData.id) {
              this._onModify();
            } else {
              this._onCreate();
            }
          } else {
            this.$message.error('请完善地址信息');
            return false;
          }
        });
      },
      async _onCreate () {
        let formData = this.slotData;

        const url = this.apis().createAddress();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('地址创建成功');

        this.refresh();
        this.visible = false;
      },
      async _onModify () {
        const url = this.apis().updateAddress(this.slotData.id);
        const result = await this.$http.put(url, this.slotData)
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }

        this.$message.success('修改地址成功');
        this.visible = false;
      },
      onNew(formData) {
        this.fn.openSlider('新建地址', AddressDetailsPage, formData);
      },
      async onSetDefault(item) {
        const formData = Object.assign({}, item);
        formData['defaultAddress'] = true;

        const url = this.apis().updateAddress(item.id);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('设置成功');

        this.refresh();
      },
      async onRemove(item) {
        const url = this.apis().removeAddress(item.id);
        const result = await this.$http.delete(url, item);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('地址删除成功');
        this.refresh();
      },
      onModify (row) {
        this.slotData = row;
        this.visible = true;
      }
    },
    data() {
      return {
        visible: false,
        slotData: {
          fullname: '',
          cellphone: '',
          region: {},
          city: {},
          cityDistrict: {}
        },
        readOnly: false
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>

<style scoped>
  .address-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>
