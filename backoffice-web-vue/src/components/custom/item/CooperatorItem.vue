<template>
  <div class="animated fadeIn requirement-cooperator-item">
    <el-row type="flex"  align="middle">
      <el-col :span="22">
        <el-row type="flex" style="width: 100%">
          <el-col :span="8" style="margin-bottom: 10px"><h6>{{slotData.partner != null ? slotData.partner.name : slotData.name}}</h6></el-col>
          <el-col :span="8">
            <el-tag style="padding: 0px 20px;height: 16px;line-height: 12px;">{{slotData.type == 'ONLINE' ? '线上' : '线下'}}</el-tag>
          </el-col>
        </el-row>
        <el-row type="flex" style="width: 100%">
          <el-col :span="8"><h6>{{slotData.partner != null ? slotData.partner.contactPerson : slotData.contactPerson}}</h6></el-col>
          <el-col :span="8"><h6>{{slotData.partner != null ? slotData.partner.contactPhone : slotData.contactPhone}}</h6></el-col>
          <el-col :span="8"><h6>合作{{slotData.partner != null && slotData.partner.historyOrdersCount ? slotData.partner.historyOrdersCount : 0}}单</h6></el-col>
        </el-row>
      </el-col>
      <el-col :span="2">
        <el-row type="flex" v-if="!isSelect">
          <el-tag
            v-if="isSelected"
            :title="selectedTip"
            class="demo2">
            <!--style="border-radius: 50%;background-color: blue;width: 30px;height: 30px;cursor: pointer;cursor: not-allowed">-->
          </el-tag>
          <el-tag
            v-else
            @click="handleCooperatorSelectionChange(slotData)"
            style="border-radius: 50%;width: 30px;background-color: white;height: 30px;cursor: pointer;border: 1px solid #c8c8c8">
          </el-tag>
        </el-row>
        <el-row type="flex" v-else>
          <el-tag
            @click="handleCooperatorSelectionChange(slotData)"
            class="cha"></el-tag>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'CooperatorItem',
    props: {
      slotData: {
        type: Object
      },
      isSelect: {
        type: Boolean,
        default: false
      },
      isSelected: {
        type: Boolean,
        default: false
      },
      selectedTip: {
        type: String,
        default: '该工厂已选择'
      }
    },
    computed: {
    },
    methods: {
      handleCooperatorSelectionChange (data) {
        this.$emit('handleCooperatorSelectionChange', data);
      },
    },
  }
</script>

<style>
  .cha{
    width: 30px;
    height: 30px;
    cursor: pointer;
    border: unset;
    background-color: white;
    position: relative;
  }
  .cha::before,
  .cha::after{
    content: "";
    position: absolute;  /*方便进行定位*/
    height: 20px;
    width: 1.5px;
    top: 2px;
    right: 9px;  /*设置top和right使图像在20*20框中居中*/
    background: #0b0e0f;
  }
  .cha::before{
    transform: rotate(45deg);  /*进行旋转*/
  }
  .cha::after{
    transform: rotate(-45deg);
  }

  .demo2 {
    width:30px;
    height:30px;
    border-radius:50% ;
    background:blue;
    display:block;
    position: relative;
    cursor: not-allowed;
  }
  .demo2:before,
  .demo2::after {
    content:"";
    height:17px;
    width:2px;
    border-radius: 10px;
    display:block;
    background:white;
    position: absolute;
    top:6px;/*40-6=34*/
    left:17px;/*make the two rects in the middle of the cycle */
    transform:rotate(45deg);
    -ms-transform:rotate(45deg);
  }
  .demo2::before {
    height:8px;
    transform: rotate(-45deg);
    -ms-transform:rotate(-45deg);
    position: absolute;
    top:13px;/*40-18=12 */
    left:9px;
  }

  el-tag:before{ content:attr(title); display:none; }
  el-tag:hover::before{
    width:200px;
    display:block;
    background:yellow;
    border:1px solid black;
    padding:8px;
    margin:25px 0 0 10px;
    position:absolute;
  }
  el-tag:hover{ z-index:10; position:relative; }
</style>
