<template>
  <div class="animated fadeIn">
    <el-steps direction="vertical" :active="active">
      <el-step v-for="item in progresses" :key="item.id">
        <template slot="title">
          {{item.phase | enumTranslate('ProductionProgressPhase')}}
          <div v-show="isShow(item)">
            <span class="demonstration">预计完成日期</span>
            <el-date-picker
              v-model="item.estimatedDate"
              type="date"
              :value-format="defaultDateValueFormat"
              @change="onUpdateEstimatedDate(item)"
              placeholder="选择日期">
            </el-date-picker>
          </div>
        </template>

        <template slot="description">
          数量：
          <el-input-number v-model="item.quantity" @change="quantityChange(item)" :min="0"
                           label="描述文字"></el-input-number>
          <br/>
          <consignment-progress-medias-upload-form ref="consignmentProgressMediasUploadForm"
                                                   :slot-data="item"
                                                   :read-only="false">

          </consignment-progress-medias-upload-form>
          <el-tabs>
            <el-row :gutter="20">
              <el-col :span="6" v-for="media in item.medias" :key="media.url">
                <img style="width:100%;height: 100%" :src="media.url"/>
                <div style="text-align: center;padding-top: 2px;">
                  <el-button @click="onDelete(item,media)">删除</el-button>
                  <a :href="media.url" target="_blank">下载</a>
                </div>
              </el-col>
            </el-row>
          </el-tabs>
        </template>
      </el-step>
    </el-steps>
  </div>
</template>

<script>
  import {ConsignmentMixin} from '@/mixins';

  import ConsignmentProgressMediasUploadForm from './ConsignmentProgressMediasUploadForm';

  export default {
    name: 'ConsignmentProgressForm',
    provide() {
      return {
        //提供给子页面调用的方法
        refresh: this.refresh
      }
    },
    components: {ConsignmentProgressMediasUploadForm},
    props: ['slotData', 'readOnly'],
    component: {ConsignmentProgressMediasUploadForm},
    methods: {
      async onUpdateEstimatedDate(item) {
        const result = await this.$http.put('/djbackoffice/consignment/updateEstimateDate', {
          id: item.id,
          estimatedDate: item.estimatedDate
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('预计日期修改成功');
      },
      isShow(item) {
        return item.phase !== 'SAMPLE_CONFIRM';
      },
      async quantityChange(item) {
        const result = await this.$http.put('/djbackoffice/consignment/updateQuantity', {
          id: item.id,
          quantity: item.quantity
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('数量修改成功');
      },
      onDelete(item, media) {
        this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          center: true
        }).then(() => this._onDelete(item, media))
      },
      async _onDelete(item, media) {
        const result = await this.$http.delete('/djbackoffice/consignment/progress/media?progressId=' + item.id + '&mediaId=' + media.id,);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.$message.success('图片删除成功');
        this.refresh();
      },
      async refresh() {
        const result = await this.$http.get('/djbackoffice/consignment/progresses?code=' + this.slotData.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.progresses = result;
      }
    },
    computed: {
      active: function () {
        let active = 0;
        const status = this.slotData.status;
        switch (status) {
          case 'WAIT_FOR_PURCHASE':
            active = 0;
            break;
          case 'SAMPLE_CONFIRM':
            active = 0;
            break;
        }
        return 0;
      },
      isUpdate: function () {
        // :disabled='isUpdate'
        return this.slotData.status != 'WAIT_FOR_PURCHASE';
      },
    },
    mixins: [ConsignmentMixin],
    data() {
      return {
        num1: 0,
        // slotData.progresses
        progresses: [],
      }
    },
    created() {
      this.progresses = this.slotData.progresses;
      // this.refresh();
    }
  }
</script>
