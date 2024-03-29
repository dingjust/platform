<template>
  <div class="animated fadeIn content">
    <template v-if="isBrand()">
      <brand-details-page @brandLeaveCount="brandLeaveCount"/>
    </template>
    <template v-else-if="isFactory()">
      <el-card>
        <template v-if="refresh">
          <factory-from ref="factoryFrom" :formData="formData" :isEditing="isEditing" 
          @onSave="onSave" @onSaveProfiles="onSaveProfiles" @onEdit="onEdit" />
        </template>
      </el-card>
    </template>
    <template v-else>
      系统异常，请重新登录
    </template>
<!--    <el-dialog :visible.sync="tipDialogVisible" width="400px" :close-on-press-escape="false" :show-close="false">-->
<!--      <leave-tip-dialog @leavelHandler="leavelHandler">-->
<!--      </leave-tip-dialog>-->
<!--    </el-dialog>-->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('FactoriesModule');

  import BrandDetailsPage from './brand/details/BrandDetailsPage';
  import FactoryDetailsPage from './factory/details/FactoryDetailsPage';
  import FactoryFrom from './factory/form/FactoryForm';
  import LeaveTipDialog from '../../common/LeaveTipDialog';

  export default {
    name: 'MyCompanyPage',
    components: {
      LeaveTipDialog,
      FactoryFrom,
      FactoryDetailsPage,
      BrandDetailsPage
    },
    computed: {
      ...mapGetters({
        formData: 'formData',
        factoryFormVisible: 'factoryFormVisible',
        isCitiesChanged: 'isCitiesChanged',
        isDistrictsChanged: 'isDistrictsChanged',
        cities: 'cities',
        cityDistricts: 'cityDistricts'
      })
    },
    methods: {
      ...mapMutations({
        setFormData: 'setFormData',
        setFactoryFormVisible: 'setFactoryFormVisible',
        setIsCitiesChanged: 'setIsCitiesChanged',
        setIsDistrictsChanged: 'setIsDistrictsChanged'
      }),
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      onEdit () {
        if (this.formData.reviewState !== 'REVIEWING' && this.formData.reviewState !== 'REVIEW_REJECTED') {
          this.$confirm('是否前往编辑页面', '提示', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this.isEditing = true;
          });
        } else {
          this.$confirm('是否前往编辑页面，页面将会展示上次提交保存但尚未通过审阅的数据', '提示', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this._onEdit();
          });
        }
      },
      async _onEdit () {
        this.refresh = false;
        this.isEditing = true;
        const uid = this.$store.getters.currentUser.companyCode;
        const url = this.apis().getFactoryBackups(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          this.refresh = true;
          this.isEditing = false;
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          this.refresh = true;
          this.isEditing = false;
          return;
        }

        this.initData(JSON.parse(result.data));
        this.refresh = true;
      },
      async getFactory () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getFactory(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.initData(result);
      },
      initData (result) {
        if (result.profiles.length <= 0) {
          result.profiles = [{
            medias: [],
            description: ''
          },
          {
            medias: [],
            description: ''
          },
          {
            medias: [],
            description: ''
          }];
        }

        this.setFormData(Object.assign({}, Object.assign(this.formData, result)));

        if (this.formData.contactAddress.region && (this.isCitiesChanged || this.cities.length <= 0)) {
          if (this.formData.contactAddress.region.isocode) {
            this.getCities(this.formData.contactAddress.region);
            this.setIsCitiesChanged(false);
          }
        }
        if (this.formData.contactAddress.city && (this.isDistrictsChanged || this.cities.length <= 0)) {
          if (this.formData.contactAddress.city && this.formData.contactAddress.city.code) {
            this.getCityDistricts(this.formData.contactAddress.city);
            this.setIsDistrictsChanged(false);
          }
        }

        this.setFactoryFormVisible(true);
      },
      async onSave () {
        if (!this.formData.sewingWorkshopPhoto && !this.formData.gatePhoto && !this.formData.cuttingTablePhoto && !this.formData.backEndPhoto) {
          this.$message.warning('工厂门牌 / 裁床照片 / 车缝照片 / 尾部照片 中必须上传任意一张');
          return;
        }

        let data = Object.assign({}, this.formData);
        if (data.productionMode === '' || data.productionMode == null) {
          this.$delete(data, 'productionMode');
        }
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().updateFactory(uid);
        const result = await this.$http.put(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setFactoryFormVisible(false);
        this.$message.success('编辑工厂信息成功');

        location.reload();
      },
      async getRegions () {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.regions = result;
      },
      async getCities (region, index) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.FactoriesModule.cities = result;
      },
      async getCityDistricts (city) {
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$store.state.FactoriesModule.cityDistricts = result;
      },
      onClose () {
        this.setFactoryFormVisible(false);
      },
      async onEditProfiles () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().getFactory(uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.setFormData(Object.assign({}, result));
        this.factoryProfilesFormVisible = !this.factoryProfilesFormVisible;
      },
      async onSaveProfiles () {
        var uid = this.$store.getters.currentUser.companyCode;
        let url = this.apis().updateFactoryProfiles(uid);
        const result = await this.$http.put(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.factoryProfilesFormVisible = false;
        this.$message.success('编辑图文详情信息成功');

        this.getFactory();
      },
      brandLeaveCount () {
        this.count++;
      }
      // leavelHandler (b) {
      //   const leave = this.leave;
      //   if (b) {
      //     this.status = true;
      //     this.$router.push({ name: leave.name, query: leave.query, params: leave.params });
      //   } else {
      //     this.status = false;
      //   }
      //   this.tipDialogVisible = false;
      // }
    },
    data () {
      return {
        count: 0,
        leave: {},
        status: false,
        tipDialogVisible: false,
        refresh: true,
        isEditing: false
      };
    },
    created () {
      if (this.isFactory()) {
        this.getFactory();
      }
    },
    watch: {
      formData: {
        handler (val) {
          if (val) {
            this.count++
          }
        },
        deep: true
      }
    },
    beforeRouteLeave (to, from, next) {
      next(false);
      const flag = this.count > 1;
      if (flag) {
        this.$confirm('是否离开此页面 , 更改内容将不会被保存', '提示', {
          confirmButtonText: '离开页面',
          cancelButtonText: '留在页面',
          type: 'warning',
          showClose: false,
          closeOnHashChange: false
        }).then(() => {
          next();
        }).catch(() => {
          throw new Error('取消成功！')
        })
      } else {
        next();
      }
      // if (this.count > 1) {
      //   if (this.status) {
      //     next()
      //     return
      //   }
      //   this.leave = to;
      //   next(false);
      //   this.tipDialogVisible = true;
      // } else {
      //   next();
      // }
    }
  };
</script>
