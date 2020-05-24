<template>
  <div class="table-body">
    <el-row type="flex" justify="end" align="middle" style="margin-bottom:20px;">
      <el-button size="mini" class="form-btn" @click="onOrder" v-if="!readonly">上报数量</el-button>
    </el-row>
    <table cellspacing="2" width="100%" class="order-table">
      <tr class="order-table-th_row">
        <template v-for="item in titleRow">
          <th :key="item">{{item}}</th>
        </template>
      </tr>
      <template v-for="(item, materialindex) in entries">
        <tr :key="materialindex">
          <td :rowspan="item.materialsColorEntries.length + 1">{{item.materialsName}}</td>
          <td :rowspan="item.materialsColorEntries.length + 1">{{item.spec.name}}</td>
          <td :rowspan="item.materialsColorEntries.length + 1">{{getEnum('MaterialsUnit', item.materialsUnit)}}</td>
          <td :rowspan="item.materialsColorEntries.length + 1">{{getEnum('MaterialsType', item.materialsType)}}</td>
        </tr>
        <template v-for="(val, index) in item.materialsColorEntries">
          <tr>
            <td>{{val.materialsColor.name}}</td>
            <!-- 实际需求数量 -->
            <td>{{val.materialsColor.name}}</td>
            <!-- 实际收货数量 -->
            <td>{{val.materialsColor.name}}</td>
            <td v-if="index === 0" :rowspan="item.materialsColorEntries.length + 1" style="width:120px">
              <!-- 物料状态 -->
              {{getEnum('MaterialsType', item.materialsType)}}
            </td>
          </tr>
        </template>
      </template>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'ProgressReportMaterial',
    props: {
      orderEntries: {
        type: Array,
        default: []
      },
      noteEntries: {
        type: Array,
        default: []
      },
      orderEntriesTotal: {
        type: Number,
        default: 0
      },
      readonly: {
        type: Boolean,
        default: false
      },
      isRead: {
        type: Boolean,
        default: true
      }
    },
    computed: {
    },
    methods: {
      onOrder () {
        this.$emit('onOrder')
      }
    },
    data () {
      return {
        tableData: [],
        titleRow: ['物料名称', '物料规格', '物料单位', '物料属性', '物料颜色', '实际需求数量', '实际收货数量', '状态'],
        entries: [
          {
            'id': 8796093085086,
            'creationtime': 1589355713000,
            'modifiedtime': 1589355713000,
            'title': '主料',
            'position': '领子',
            'materialsId': 8800057982977,
            'materialsCode': 'MTRL00019002',
            'materialsName': '尼龙布',
            'unitQuantity': 10,
            'lossRate': 0.1,
            'materialsType': 'PLUS_MATERIAL',
            'materialsUnit': 'SHEET',
            'materialsColorEntries': [
              {
                'id': 8796093085087,
                'creationtime': 1589355713000,
                'modifiedtime': 1589355713000,
                'sampleColor': {
                  'id': 8796879582515,
                  'code': '9cfdf2b39bfe42d08c95e6de16005021',
                  'name': '卡其',
                  'sequence': 10000,
                  'active': true,
                  'customize': true
                },
                'materialsColor': {
                  'id': 8796093445427,
                  'code': 'C13',
                  'name': '卡其',
                  'sequence': 13,
                  'active': true,
                  'colorCode': '#CC9933',
                  'customize': false
                }
              },
              {
                'id': 8796093117855,
                'creationtime': 1589355713000,
                'modifiedtime': 1589355713000,
                'sampleColor': {
                  'id': 8796879615283,
                  'code': 'bd25ea983b074e9c8c8ff58e2808a795',
                  'name': '橙色',
                  'sequence': 10000,
                  'active': true,
                  'customize': true
                },
                'materialsColor': {
                  'id': 8796094362931,
                  'code': 'C41',
                  'name': '橄榄绿',
                  'sequence': 41,
                  'active': true,
                  'colorCode': '#999900',
                  'customize': false
                }
              },
              {
                'id': 8796093150623,
                'creationtime': 1589355713000,
                'modifiedtime': 1589355713000,
                'sampleColor': {
                  'id': 8796879648051,
                  'code': 'b968dd87d9bb43eeb26638e9f65216f5',
                  'name': '自定义颜色1',
                  'sequence': 10000,
                  'active': true,
                  'customize': true
                },
                'materialsColor': {
                  'id': 8796093445427,
                  'code': 'C13',
                  'name': '卡其',
                  'sequence': 13,
                  'active': true,
                  'colorCode': '#CC9933',
                  'customize': false
                }
              }
            ],
            'spec': {
              'code': 'efab0c2c46d6433dbc9c033732ac3264',
              'name': '50x50',
              'customize': true
            }
          },
          {
            'id': 8796093117854,
            'creationtime': 1589355713000,
            'modifiedtime': 1589355713000,
            'title': '辅料',
            'position': '下摆',
            'materialsId': 8800057982977,
            'materialsCode': 'MTRL00019002',
            'materialsName': '尼龙布',
            'unitQuantity': 20,
            'lossRate': 0.2,
            'materialsType': 'PLUS_MATERIAL',
            'materialsUnit': 'SHEET',
            'materialsColorEntries': [
              {
                'id': 8796093183391,
                'creationtime': 1589355713000,
                'modifiedtime': 1589355713000,
                'sampleColor': {
                  'id': 8796879680819,
                  'code': '094f963fd9d74b38b6b0236a33246c03',
                  'name': '卡其',
                  'sequence': 10000,
                  'active': true,
                  'customize': true
                },
                'materialsColor': {
                  'id': 8796093183283,
                  'code': 'C03',
                  'name': '黑色',
                  'sequence': 3,
                  'active': true,
                  'colorCode': '#000000',
                  'customize': false
                }
              },
              {
                'id': 8796093216159,
                'creationtime': 1589355713000,
                'modifiedtime': 1589355713000,
                'sampleColor': {
                  'id': 8796879713587,
                  'code': 'd9e377a6b89b447cb96a0b51c8a5b8ab',
                  'name': '橙色',
                  'sequence': 10000,
                  'active': true,
                  'customize': true
                },
                'materialsColor': {
                  'id': 8796094362931,
                  'code': 'C41',
                  'name': '橄榄绿',
                  'sequence': 41,
                  'active': true,
                  'colorCode': '#999900',
                  'customize': false
                }
              }
            ],
            'spec': {
              'code': '9574903ecd9649c98d3f975d94f3a44c',
              'name': '30x30',
              'customize': true
            }
          }
        ]
      }
    },
    created () {
      // this.initTable();
    }
  }
</script>

<style scoped>
  .table-body {
    width: 100%;
  }

  .form-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  }

  .table-body {
    width: 100%;
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
  }

  /* .order-table-th_row {
    height: 80px;
  } */

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }

  .order-table-btn_add {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
  }

  .form-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  }
</style>

