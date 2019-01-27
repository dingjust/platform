<template>
  <div class='animated fadeIn content'>
    <el-card>
      <el-form :inline='true'>
        <el-form-item label="">
          <el-input placeholder='请输入产品编码' v-model='text'></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type='primary' icon='el-icon-search' @click='onSearch'></el-button>
        </el-button-group>
      </el-form>
      <el-table ref='resultTable' stripe
                :data='page.content'>
        <el-table-column type='expand'>
          <template slot-scope='props'>
            <el-table stripe :data='props.row.stockLevels' row-key='code'>
              <el-table-column label='颜色' prop='color.name'></el-table-column>
              <el-table-column label='实际库存' prop='available'></el-table-column>
              <el-table-column label='虚拟库存' prop='maxPreOrder'></el-table-column>
              <el-table-column label='操作'>
                <template slot-scope='scope '>
                  <el-button type='text ' icon='el-icon-edit ' @click='onUpdateInventory(scope.row) '>
                    调整
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </template>
        </el-table-column>
        <el-table-column label='编码' prop='code'></el-table-column>
        <el-table-column label='名称' prop='name'></el-table-column>
        <el-table-column label='价格' prop='price' :formatter="numberFormatter"></el-table-column>
      </el-table>
      <div class='pt-2 '></div>
      <div class='float-right '>
        <el-pagination layout='total, sizes, prev, pager, next, jumper'
                       @size-change='onPageSizeChanged'
                       @current-change='onCurrentPageChanged'
                       :current-page='page.number + 1'
                       :page-size='page.size'
                       :page-count='page.totalPages'
                       :total='page.totalElements'>
        </el-pagination>
      </div>
      <div class='clearfix'></div>
    </el-card>
    <el-dialog title='调整库存' width='70%'
               :visible.sync='formDialogVisible'  :close-on-click-modal="false" :modal='false'>
      <inventory-base-form ref='InventoryBaseForm'
                           :slot-data='rowData'
                           :read-only='false'
                           :is-newly-created='false'>
      </inventory-base-form>
      <div slot='footer' class='dialog-footer'>
        <el-button type='primary' @click='onSubmitBaseForm'>确 定</el-button>
        <el-button @click='formDialogVisible = false'>取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import axios from 'axios';
  import InventoryBaseForm from './InventoryBaseForm';

  export default {
    name: 'InventoryPage',
    components: {InventoryBaseForm},
    methods: {
      numberFormatter(val){
        if(val.price !== null && val.price !== '' && val.price !== 'undefined'){
          let prices = parseFloat(val.price).toFixed(2);
          return prices;
        }else{
          return ;
        }
      },
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onPageSizeChanged(val) {
        this.reset();

        this.page.size = val;
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1, this.page.size);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const params = {
          text: this.text,
          page: page,
          size: size
        };

        axios.get('/djfactory/fabric/stockLevel', {
          params: params
        }).then(response => {
          console.log(response.data);
          this.page = response.data;
        }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      onUpdateInventory(item) {
        console.log(item);
        this.rowData = {
          code: item.code,
          color: item.color,
          size: item.size,
          available: '',
          maxPreOrder: '',
          beforeAvailable: item.available,
          beforeMaxPreOrder: item.maxPreOrder
        };
        this.formDialogVisible = true;
      },
      onSubmitBaseForm() {
        const baseForm = this.$refs['InventoryBaseForm'];
        console.log(baseForm.slotData);
        axios.put('/djfactory/fabric/stockLevel', baseForm.slotData)
          .then(() => {
            this.$message({
              type: 'success',
              message: '调整库存成功'
            });
            this.formDialogVisible = false;
            this.onSearch();
          }).catch(error => {
          this.$message.error('调整库存失败');
        });
      }
    },
    watch: {
      '$store.state.sideSliderState': function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    computed: {},
    data() {
      return {
        text: "",
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        formDialogVisible: false,
        rowData: null
      };
    }
  };
</script>
