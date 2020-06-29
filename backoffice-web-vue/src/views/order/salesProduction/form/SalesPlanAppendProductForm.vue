<template>
  <div class="animated fadeIn">
    <el-dialog :visible.sync="materialDialogVisible" width="95%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="materialDialogVisible" @onSelectSample="onSelectSample" />
    </el-dialog>
    <el-dialog :visible.sync="dialogVisible" width="95%" class="purchase-dialog" :close-on-click-modal="false"
      append-to-body>
      <sample-accounting-sheet-form v-if="dialogVisible" :slot-data="openAccountingSheet"
        @onSave="onAccountingSheetSave" :sampleSpecEntries="openSampleSpecEntries"
        :needMaterialsSpec="needMaterialsSpec" :unitPrice="openAccountingSheetUnitPrice"
        :needMaterialAccounting="needMaterialsSpec" />
    </el-dialog>
    <el-dialog :visible.sync="viewDialogVisible" width="95%" class="purchase-dialog" :close-on-click-modal="false"
      append-to-body>
      <sample-accounting-sheet :slot-data="openAccountingSheet" :sampleSpecEntries="openSampleSpecEntries"
        :unitPrice="openAccountingSheetUnitPrice" v-if="viewDialogVisible" :readOnly="readOnly"
        :needMaterialAccounting="needMaterialsSpec" />
    </el-dialog>
    <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="setProgressPlan"/>
    </el-dialog>
    <el-form :model="appendProductForm" ref="appendProductForm" label-position="left" :disabled="readOnly">
      <template v-for="(entry, productIndex) in appendProductForm.sampleList">
        <div :key="productIndex">
          <el-row class="info-sales-row" type="flex" justify="space-between" align="middle" :gutter="20">
            <el-col :span="16">
              <el-row type="flex" align="middle">
                <el-col :span="14" style="padding-top:25px">
                  <el-form-item :prop="'sampleList.' + productIndex + '.product.name'" label="产品名" label-width="100px"
                    :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                    <el-input placeholder="名称" v-model="entry.product.name" size="mini" :disabled="true"></el-input>
                  </el-form-item>
                </el-col>
                <el-col :span="2">
                  <el-button style="margin-left: 10px" @click="appendSample(productIndex)" size="mini"
                    :disabled="isUpdate">点击选择</el-button>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="2">
              <el-row type="flex" align="middle">
                <el-button class="remove-btn" v-if="productIndex!=0" @click="removeRow(productIndex)">删除</el-button>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" v-if="entry.product.code != null" class="info-order-row">
            <img class="purchase-product-img"
              :src="entry.product.thumbnail!=null&&entry.product.thumbnail.length!=0?entry.product.thumbnail.url:'static/img/nopicture.png'">
            <table cellspacing="2" width="100%" :height="(appendProductForm.sampleList.length+1)*50"
              class="order-table">
              <tr class="order-table-th_row">
                <td style="width: 40px">颜色</td>
                <template v-for="size in entry.sizes">
                  <th :key="size.name">{{size.name}}</th>
                </template>
                <th>小计</th>
              </tr>
              <template v-for="color in entry.colors">
                <tr :key="'tr'+color.code">
                  <td>{{color.name}}</td>
                  <template v-for="size in entry.sizes">
                    <td style="width:80px" :key="'td'+size.name">
                      <el-input class="order-table-input" type="number" @mousewheel.native.prevent :min="1"
                        :disabled="fromOrigin"
                        v-model="getEntryByColorSize(color, size, entry.colorSizeEntries).quantity">
                      </el-input>
                    </td>
                  </template>
                  <td style="width:100px">{{countColorsAmount(color, entry.colorSizeEntries)}}</td>
                </tr>
              </template>
              <tr>
                <td :colspan="getColspanLength(entry.sizes.length)">合计</td>
                <td>{{countTotalAmount(entry.colorSizeEntries)}}</td>
              </tr>
            </table>
          </el-row>
          <el-row class="info-sales-row" type="flex" justify="space-between" align="middle" :gutter="20">
            <el-col :span="16">
              <el-row type="flex" align="middle">
                <el-col :span="14" style="padding-top:25px">
                  <el-form-item :prop="'sampleList.' + productIndex + '.progressPlan.name'" label="节点方案" label-width="100px"
                    :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                    <el-input placeholder="名称" v-model="entry.progressPlan.name" size="mini" :disabled="true"></el-input>
                  </el-form-item>
                </el-col>
                <el-col :span="2">
                  <el-button style="margin-left: 10px" @click="appendProgressPlan(productIndex)" size="mini"
                    :disabled="isUpdate">点击选择</el-button>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" :gutter="10">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <el-form-item :prop="'sampleList.' + productIndex + '.unitPrice'" label="订单报价" label-width="100px"
                  :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                  <el-input placeholder="订单报价" v-model="entry.unitPrice" :disabled="fromOrigin"
                    v-number-input.float="{ min: 0 ,decimal:2}" size="mini">
                  </el-input>
                </el-form-item>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <el-form-item :prop="'sampleList.' + productIndex + '.deliveryDate'" label="交货日期" label-width="100px"
                  :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                  <el-date-picker v-model="entry.deliveryDate" type="date" placeholder="选择日期" :disabled="fromOrigin">
                  </el-date-picker>
                </el-form-item>
              </el-row>
            </el-col>
          </el-row>
          <el-row style="padding-left: 6px">
            <my-address-form :vAddress.sync="entry.shippingAddress" ref="addressComp"
              :readOnly="readOnly||fromOrigin" />
          </el-row>
          <!-- <el-row style="margin-top:20px;">
            <sample-attach-orders-form :entries.sync="entry.materialsSpecEntries" :medias.sync="entry.medias"
              :productionProcessContent.sync="entry.productionProcessContent"
              @onSpecEntryUpdate="(ids)=>onSpecEntryUpdate(entry,ids)"
              :productsColors="getColorsByEntries(entry.colorSizeEntries)" />
          </el-row>
          <el-row style="margin-top:20px;" type="flex" align="center" :gutter="10">
            <el-col :span="4">
              <el-button class="product-form-btn" @click="onCreateAccountingSheet(productIndex)"
                :disabled="!canCreateCostOrder(entry)">创建成本核算单</el-button>
            </el-col>
            <el-col :span="4">
              <el-button class="product-form-btn" @click="onImportAccountingSheet(productIndex)" type="text"
                v-if="canCreateCostOrder(entry)&&entry.sampleCostOrder!=null">导入样衣成本核算单</el-button>
            </el-col>
            <el-col :span="2">
              <h6 style="padding-top:8px">核算单：</h6>
            </el-col>
            <el-col :span="18">
              <h6 class="account_sheet-btn" @click="onUpdateAccountingSheet(productIndex)"
                v-if="!canCreateCostOrder(entry)">
                {{entry.costOrder.id!=null?entry.costOrder.id:'成本核算单'}}
              </h6>
            </el-col>
          </el-row> -->
          <production-task :slotData="entry.productionTask" ref="taskComp" :productionLeader="productionLeader"
            :readOnly="readOnly" />
        </div>
      </template>
      <el-row type="flex" justify="center" class="info-order-row" align="middle" style="margin-top: 20px"
        v-if="!isUpdate">
        <el-col :span="24">
          <div class="order-purchase-table-btn_add" @click="addRow">
            +添加另一款产品
          </div>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 20px" v-if="!readOnly">
      <el-button class="material-btn" @click="onSubmit">{{isUpdate?'保存':'添加产品'}}</el-button>
    </el-row>
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
  } = createNamespacedHelpers('SampleProductsModule');

  import SampleProductsSelectDialog from '@/views/product/sample/components/SampleProductsSelectDialog';
  import SampleAttachOrdersForm from '@/views/product/sample/form/SampleAttachOrdersForm';
  import SampleAccountingSheetForm from '@/views/product/sample/form/SampleAccountingSheetForm';
  import SampleAccountingSheet from '@/views/product/sample/components/SampleAccountingSheet';
  import ProductionTask from '../components/ProductionTask';
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';
  import ProgressPlanSelectDialog from '@/views/user/progress-plan/components/ProgressPlanSelectDialog'

  export default {
    name: 'SalesPlanAppendProductForm',
    components: {
      SampleAccountingSheetForm,
      SampleAccountingSheet,
      SampleAttachOrdersForm,
      SampleProductsSelectDialog,
      ProductionTask,
      MyAddressForm,
      ProgressPlanSelectDialog
    },
    props: {
      productionLeader: {
        type: Object,
      },
      isUpdate: {
        type: Boolean,
        default: false
      },
      updataEntry: {
        type: Object,
      },
      defaultAddress: {
        type: Object,
        default: null
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      //是否需要物料清单
      needMaterialsSpec: {
        type: Boolean,
        default: true
      },
      //是否来源外发，是则禁止修改产品
      fromOrigin: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      ...mapGetters({
        slotData: 'newFormData'
      }),
    },
    data() {
      return {
        materialDialogVisible: false,
        openAccountingSheet: {},
        openAccountingSheetUnitPrice: null,
        openSampleSpecEntries: [],
        appendProductForm: {
          sampleList: [{
            product: {

            },
            progressPlan: {
            },
            colorSizeEntries: [],
            unitPrice: '',
            deliveryDate: '',
            materialsSpecEntries: [],
            productionProcessContent: '',
            medias: [],
            costOrder: null,
            shippingAddress: {},
            productionTask: {
              price: '',
              deliveryTime: '',
              populationScale: '',
              cooperationMode: "LABOR_AND_MATERIAL",
              invoiceTaxPoint: 0.03,
              invoiceNeeded: false,
              remarks: "",
              appointFactory: null,
            }
          }],
        },
        currentProductIndex: 0,
        dialogVisible: false,
        viewDialogVisible: false,
        progressPlanVisible: false
      }
    },
    methods: {
      appendSample(index) {
        this.currentProductIndex = index;
        this.materialDialogVisible = true;
      },
      appendProgressPlan(index) {
        this.currentProductIndex = index;
        this.progressPlanVisible = true;
      },
      setProgressPlan (val) {
        let row = {
          name: val.name,
          remarks: val.remarks,
          productionProgresses: []
        }
        val.productionProgresses.forEach(item => {
          row.productionProgresses.push({
            progressPhase: item.progressPhase,
            warningDays: item.warningDays,
            medias: item.medias,
            completeAmount: item.completeAmount,
            productionProgressOrders: item.productionProgressOrders,
            quantity: item.quantity,
            sequence: item.sequence
          })
        })
        this.appendProductForm.sampleList[this.currentProductIndex].progressPlan = row;
        this.progressPlanVisible = false; 
      },
      onSelectSample(data) {
        //构建颜色尺码行
        var colorSizeEntries = [];
        data.colorSizes.forEach(color => {
          color.sizes.forEach(size => {
            colorSizeEntries.push({
              color: {
                code: color.colorCode,
                name: color.colorName,
                id: color.colorId
              },
              size: {
                code: size.code,
                name: size.name,
                id: size.id
              },
              quantity: ''
            })
          });
        });

        //设置对应颜色，尺码数组                    
        var entry = {
          product: data,
          colorSizeEntries: colorSizeEntries,
          unitPrice: '',
          deliveryDate: '',
          // materialsSpecEntries: data.entries,
          productionProcessContent: '',
          medias: [],
          costOrder: null,
          colors: this.getColorsByEntries(colorSizeEntries),
          sizes: this.getSizesByEntries(colorSizeEntries),
        }

        //若需要物料清单
        if (this.needMaterialsSpec) {
          entry['materialsSpecEntries'] = data.entries;
          //若有成本核算单                  
          if (data.costingSheets != null && data.costingSheets[0] != null) {
            entry['sampleCostOrder'] = data.costingSheets[0];
          }
        }

        var newEntry = Object.assign(this.appendProductForm.sampleList[this.currentProductIndex], entry);

        //通过set 赋值刷新渲染视图
        this.$set(this.appendProductForm.sampleList, this.currentProductIndex, newEntry);

        this.materialDialogVisible = false;
      },
      //获取样衣颜色
      getColorsByEntries(colorSizeEntries) {
        var colors = [];
        colorSizeEntries.forEach(entry => {
          let index = colors.findIndex(element => element.code == entry.color.code);
          if (index == -1) {
            colors.push(entry.color);
          }
        });
        return colors;
      },
      //获取样衣尺码
      getSizesByEntries(colorSizeEntries) {
        var sizes = [];
        colorSizeEntries.forEach(entry => {
          let index = sizes.findIndex(element => element.code == entry.size.code);
          if (index == -1) {
            sizes.push(entry.size);
          }
        });
        return sizes;
      },
      getEntryByColorSize(color, size, colorSizeEntries) {
        let index = colorSizeEntries.findIndex(entry => entry.color.code == color.code && entry.size.code == size.code);
        if (index != -1) {
          return colorSizeEntries[index];
        } else {
          //没找到，则创建对应对象
          var newObj = {
            color: color,
            size: size,
            quantity: '',
          };
          colorSizeEntries.push(newObj);
          return newObj;
        }
      },
      removeRow(index) {
        this.appendProductForm.sampleList.splice(index, 1);
      },
      countColorsAmount(color, colorSizeEntries) {
        var amount = 0;
        colorSizeEntries.filter(entry => entry.color.code == color.code).forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      countTotalAmount(colorSizeEntries) {
        var amount = 0;
        colorSizeEntries.forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      getColspanLength(size) {
        return size + 1;
      },
      getColorSize(color, size, colorSizes) {
        var result = colorSizes.filter(item => {
          if (item.colorName == color.colorName) {
            const index = item.sizes.findIndex(val => val.name == size.name);
            return index > -1;
          }
        })
        if (result.length != 0) {
          for (let i = 0; i < result[0].sizes.length; i++) {
            if (result[0].sizes[i].name == size.name) {
              return result[0].sizes[i];
            }
          }
        } else {
          return null;
        }
      },
      onCreateAccountingSheet(productIndex) {
        //是否校验物料清单
        if (this.needMaterialsSpec) {
          if (this.appendProductForm.sampleList[productIndex].materialsSpecEntries == null || this.appendProductForm
            .sampleList[productIndex].materialsSpecEntries.length < 1) {
            this.$message.error('请先添加物料清单');
            return;
          }
        }
        this.$refs.appendProductForm.validateField('sampleList.' + productIndex + '.unitPrice', errMsg => {
          if (errMsg) {
            this.$message.error('请先填写订单报价');
          } else {
            this.currentProductIndex = productIndex;
            this.openAccountingSheetUnitPrice = this.appendProductForm.sampleList[productIndex].unitPrice;
            this.$set(this, 'openSampleSpecEntries', this.appendProductForm.sampleList[productIndex]
              .materialsSpecEntries);
            this.openSampleSpecEntries = this.appendProductForm.sampleList[productIndex].materialsSpecEntries;
            this.openAccountingSheet = {
              'isIncludeTax': true,
              'remarks': '',
              'totalPrice': 0,
              'materialsEntries': [],
              'specialProcessEntries': [],
              'laborCostEntries': []
            };
            this.$nextTick(() => {
              this.dialogVisible = true;
            });
          }
        });

      },
      onImportAccountingSheet(productIndex) {
        this.$set(this, 'openSampleSpecEntries', this.appendProductForm.sampleList[productIndex].materialsSpecEntries);
        let order = Object.assign({}, this.appendProductForm.sampleList[productIndex].sampleCostOrder);
        //移除id
        this.$delete(order, 'id');
        if (order.laborCostEntries != null) {
          order.laborCostEntries.forEach(entry => {
            this.$delete(entry, 'id');
          });
        }
        if (order.materialsEntries) {
          order.materialsEntries.forEach(entry => {
            this.$delete(entry, 'id');
          });
        }
        if (order.specialProcessEntries) {
          order.specialProcessEntries.forEach(entry => {
            this.$delete(entry, 'id');
          });
        }
        this.$set(this.appendProductForm.sampleList[productIndex], 'costOrder', order);
      },
      onUpdateAccountingSheet(index) {
        this.currentProductIndex = index;
        this.openAccountingSheetUnitPrice = this.appendProductForm.sampleList[index].unitPrice;
        this.$set(this, 'openSampleSpecEntries', this.appendProductForm.sampleList[index].materialsSpecEntries);
        this.openAccountingSheet = this.appendProductForm.sampleList[index].costOrder;
        this.viewDialogVisible = true;
      },
      onAccountingSheetSave(sheet) {
        this.$set(this.appendProductForm.sampleList[this.currentProductIndex], 'costOrder', sheet);
        this.dialogVisible = false;
      },
      addRow() {
        var newEntry = {
          product: {

          },
          progressPlan: {},
          colorSizeEntries: [],
          unitPrice: '',
          deliveryDate: '',
          materialsSpecEntrie: [],
          productionProcessContent: '',
          medias: [],
          costOrder: null,
          shippingAddress: {},
          productionTask: {
            price: '',
            deliveryTime: '',
            populationScale: '',
            cooperationMode: "LABOR_AND_MATERIAL",
            invoiceTaxPoint: 0.03,
            invoiceNeeded: false,
            remarks: "",
            appointFactory: null,
          }
        };
        this.appendProductForm.sampleList.push(newEntry);
      },
      onSubmit() {
        let amountValidate = true;
        let costingValidate = true;
        let materialsSpecEntriesValiadte = true;

        //校验数量行
        this.appendProductForm.sampleList.forEach(entry => {
          if (this.countTotalAmount(entry.colorSizeEntries) < 1) {
            amountValidate = false;
          }
        });
        if (!amountValidate) {
          this.$message.error('产品数量不能为空');
        }

        // //校验是否有核算单
        // this.appendProductForm.sampleList.forEach(element => {
        //   if (element.costOrder.isIncludeTax == null) {
        //     costingValidate = false;
        //   }
        // });

        // //校验物料清单
        // if (this.needMaterialsSpec) {
        //   this.appendProductForm.sampleList.forEach(element => {
        //     if (element.materialsSpecEntries == null || element.materialsSpecEntries.length < 1) {
        //       materialsSpecEntriesValiadte = false;
        //     }
        //   });
        // }

        //获取各层级form
        var forms = [];
        forms.push(this.$refs.appendProductForm);
        // taskForm数组
        this.$refs.taskComp.forEach(item => {
          forms.push(item.$refs.taskForm);
        });
        //addressForm数组
        this.$refs.addressComp.forEach(item => {
          forms.push(item.$refs.address);
        });
        // 使用Promise.all 并行去校验结果
        Promise.all(forms.map(this.getFormPromise)).then(res => {
          const validateResult = res.every(item => !!item);
          if (validateResult && amountValidate && costingValidate && materialsSpecEntriesValiadte) {
            this.$emit('onSave', this.appendProductForm.sampleList);
          } else {
            if (!costingValidate || !materialsSpecEntriesValiadte) {
              let str = '请创建 ';
              if (!materialsSpecEntriesValiadte) {
                str += '物料清单';
              }
              if (!costingValidate) {
                str += '\n成本核算单';
              }
              this.$message.error(str);
            } else {
              this.$message.error('请完善信息');
            }
          }
        });
      },
      //封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      //删除物料清单行
      onSpecEntryUpdate(entry, ids) {
        if (entry.costOrder != null && entry.costOrder.materialsEntries != null) {
          var newEntries = entry.costOrder.materialsEntries.filter(element => ids.indexOf(element.materialsSpecEntry
            .id) > -1);
          this.$set(entry.costOrder, 'materialsEntries', newEntries);
        }
      },
      //是否可以创建成本核算单
      canCreateCostOrder(entry) {
        if (entry.costOrder == null || entry.costOrder.isIncludeTax == null) {
          return true;
        } else {
          return false;
        }

      }
    },
    created() {
      if (this.isUpdate && this.updataEntry != null) {
        var entryJson = JSON.stringify(this.updataEntry);
        var entry = JSON.parse(entryJson);
        var newEntry = Object.assign(this.appendProductForm.sampleList[0], entry);
        //通过set 赋值刷新渲染视图
        this.$set(newEntry, 'colors', this.getColorsByEntries(newEntry.colorSizeEntries));
        this.$set(newEntry, 'sizes', this.getSizesByEntries(newEntry.colorSizeEntries));
        this.$set(this.appendProductForm.sampleList, 0, newEntry);
      }
    }
  }

</script>
<style src="../css/sales-plan-append-product.css"></style>
