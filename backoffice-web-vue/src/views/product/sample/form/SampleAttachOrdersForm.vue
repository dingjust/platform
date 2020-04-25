<template>
  <div>
    <el-tabs v-model="activeName" type="border-card">
      <el-tab-pane label="物料清单" name="material">
        <el-table :data="slotData.entries" style="width: 100%">
          <el-table-column prop="name" label="品名">
          </el-table-column>
          <el-table-column prop="spec" label="规格">
            <template slot-scope="scope">
              <el-select v-model="scope.row.spec" placeholder="请选择">
                <el-option v-for="item in scope.row.sizes" :key="item.value" :label="item" :value="item">
                </el-option>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column prop="color" label="颜色">
            <template slot-scope="scope">
              <el-select v-model="scope.row.color" placeholder="请选择">
                <el-option v-for="item in scope.row.colors" :key="item.value" :label="item" :value="item">
                </el-option>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column prop="materialsUnit" label="单位">
          </el-table-column>
          <el-table-column prop="materialsType" label="属性">
          </el-table-column>
          <el-table-column prop="applicableColors" label="适用颜色">
            <template slot-scope="scope">
              <el-select v-model="scope.row.applicableColors" placeholder="请选择" value-key="color" multiple
                :collapse-tags="false" @change="(val)=>onApplicableColorChange(val,scope.row)">
                <el-option v-for="(item,index) in clothesColors" :key="index" :label="item.color" :value="item">
                </el-option>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column prop="unitQuantity" label="单位用量">
            <template slot-scope="scope">
              <el-input v-model="scope.row.unitQuantity" placeholder="单位用量"></el-input>
            </template>
          </el-table-column>
          <el-table-column prop="lossRate" label="损耗">
            <template slot-scope="scope">
              <el-input @input="(val)=>onLossRateInput(val,scope.row)" :value="showFloatPercentNum(scope.row.lossRate)"
                v-number-input.float="{ min: 0,max:100 ,decimal:0}">
                <h6 slot="suffix" style="padding-top:10px">%</h6>
              </el-input>
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template slot-scope="scope">
              <el-button @click="onRemove(scope.row)" type="text" size="small">删除</el-button>
              <!-- <el-button type="text" size="small">编辑</el-button> -->
            </template>
          </el-table-column>
        </el-table>
        <el-row type="flex" style="margin-top:10px;">
          <el-col :span="4">
            <el-button icon="el-icon-plus" @click="onAdd">添加物料</el-button>
          </el-col>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="生产工艺单" name="craft">
        <el-input type="textarea" placeholder="输入工艺要求" v-model="slotData.productionProcessContent" :rows="10">
        </el-input>
        <images-upload class="product-images-form-upload" style="margin-top:20px" :slot-data="slotData.medias"
          :read-only="isRead" :disabled="isRead" :limit="8">
          <template slot="picBtn" slot-scope="props">
            <h6>上传工艺单文件</h6>
          </template>
        </images-upload>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  import ImagesUpload from "@/components/custom/ImagesUpload";


  export default {
    name: "SampleAttachOrdersForm",
    props: ["slotData", "readOnly", "isRead"],
    components: {
      ImagesUpload,
      
    },
    computed: {
      clothesColors: function () {
        var result = [{
          'color': '全部'
        }];
        this.slotData.colorSizes.forEach(element => {
          result.push(element[0]);
        });

        return result;
      }
    },
    methods: {
      onAdd() {
        this.slotData.entries.push({
          'code': '',
          'materialsName': '物料1',
          'spec': '',
          'color': '',
          'materialsUnit': '米',
          'materialsType': '面料',
          'applicableColors': [],
          'unitQuantity': '',
          'lossRate': '',
          'colors': ['红色', '白色'],
          'sizes': ['S', 'X', 'M'],
          'entries': [{
            'color': '白色',

          },{},{}]
        })
      },
      onRemove(row) {
        this.slotData.entries.splice(this.slotData.entries.indexOf(row), 1);
      },
      showFloatPercentNum(val) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      onLossRateInput(val, row) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          row.lossRate = (val / 100.0).toFixed(2);
        } else {
          row.lossRate = val;
        }
      },
      //适用颜色变化
      onApplicableColorChange(val, row) {
        //选中全部则适用颜色值置为空
        if (val != '' && val.findIndex((item) => item.color == '全部') != -1) {
          row.applicableColors = null;
        }
      }
    },
    data() {
      return {
        activeName: "material",
        textarea1: '',
      };
    },
    created() {}
  };

</script>
<style scoped>

</style>
