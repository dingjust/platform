<template>
  <div>
    <el-tabs v-model="activeName" type="border-card">
      <el-tab-pane label="物料清单" name="material">
        <el-table :data="tableData" style="width: 100%">
          <el-table-column prop="name" label="品名">
          </el-table-column>
          <el-table-column prop="size" label="规格">
            <template slot-scope="scope">
              <el-select v-model="scope.row.size" placeholder="请选择">
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
          <el-table-column prop="unit" label="单位">
          </el-table-column>
          <el-table-column prop="attribute" label="属性">
          </el-table-column>
          <el-table-column prop="suitColor" label="适用颜色">
            <template slot-scope="scope">
              <el-select v-model="scope.row.suitColor" placeholder="请选择">
                <el-option v-for="item in scope.row.colors" :key="item.value" :label="item" :value="item">
                </el-option>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column prop="usage" label="单位用量">
            <template slot-scope="scope">
              <el-input v-model="scope.row.usage" placeholder="单位用量"></el-input>
            </template>
          </el-table-column>
          <el-table-column prop="waste" label="损耗">
            <template slot-scope="scope">
              <el-input @input="(val)=>onWasteInput(val,scope.row)" :value="showFloatPercentNum(scope.row.waste)"
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
        <el-input type="textarea" placeholder="输入工艺要求" v-model="textarea1" :rows="10"></el-input>
        <images-upload class="product-images-form-upload" style="margin-top:20px" :slot-data="slotData.details"
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
      ImagesUpload
    },
    computed: {},

    methods: {
      onAdd() {
        this.tableData.push({
          'name': '物料1',
          'size': '',
          'color': '',
          'unit': '米',
          'attribute': '面料',
          'suitColor': '',
          'usage': '',
          'waste': '',
          'colors': ['红色', '白色'],
          'sizes': ['S', 'X', 'M']
        })
      },
      onRemove(row) {
        this.tableData.splice(this.tableData.indexOf(row), 1);
      },
      showFloatPercentNum(val) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      onWasteInput(val, row) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          row.waste = (val / 100.0).toFixed(2);
        } else {
          row.waste = val;
        }
      },
    },
    data() {
      return {
        activeName: "material",
        textarea1: '',
        tableData: []
      };
    },
    created() {}
  };

</script>
<style scoped>

</style>
