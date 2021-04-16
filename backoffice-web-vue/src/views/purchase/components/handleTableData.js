// 处理使用到 MaterialAppendTable 组件的相关数据处理
// WORKORDERS 物料明细表单数据
// CUSTOMROWS 附加项数据

function handleSumbitData (arr, type) {
  let result = [];

  if (type === 'WORKORDERS') {
    arr.forEach(item => {
      result.push({
        id: item.materialsId ? item.materialsId : null,
        name: item.name,
        code: item.code,
        unit: item.unit,
        materialsType: item.materialsType,
        factoryName: item.cooperatorName,
        factoryPhone: item.factoryPhone,
        specList: [{
          id: item.specListId ? item.specListId : null,
          unitQuantity: item.unitQuantity,
          specName: item.specName,
          colorName: item.colorName,
          modelName: item.modelName,
          emptySent: item.emptySent,
          requiredAmount: item.requiredAmount,
          estimatedLoss: item.estimatedLoss,
          estimatedUsage: item.estimatedUsage,
          orderCount: item.orderCount,
          price: item.price,
          totalPrice: item.totalPrice,
          estimatedRecTime: item.estimatedRecTime,
          composition: item.composition,
          purpose: item.purpose,
          quoteLossRate: item.quoteLossRate,
          quoteAmount: item.quoteAmount,
          remarks: item.remarks
        }]
      })
    })
  } else if (type === 'CUSTOMROWS') {
    arr.forEach(item => {
      result.push({
        id: item.materialsId ? item.materialsId : '',
        name: item.name,
        code: item.code,
        unit: item.unit,
        customCategoryName: item.customCategoryName,
        specList: [{
          id: item.specListId ? item.specListId : null,
          price: item.price
        }]
      });
    })
  }

  return result;
};

function handleInitData (arr, type) {
  let result = [];

  if (type === 'WORKORDERS') {
    if (arr && arr.length > 0) {
      arr.forEach(row => {
        if (row.specList && row.specList.length > 0) {
          result = result.concat(row.specList.map(item => {
            return {
              materialsId: row.id,
              name: row.name,
              code: row.code,
              unit: row.unit,
              materialsType: row.materialsType,
              cooperatorName: row.cooperatorName ? row.cooperatorName : row.factoryName,
              factoryName: row.factoryName,
              factoryPhone: row.factoryPhone,
              specListId: item.id,
              unitQuantity: item.unitQuantity,
              specName: item.specName,
              colorName: item.colorName,
              modelName: item.modelName,
              emptySent: item.emptySent,
              requiredAmount: item.requiredAmount,
              estimatedLoss: item.estimatedLoss,
              estimatedUsage: item.estimatedUsage,
              orderCount: item.orderCount,
              auditColor: item.auditColor,
              estimatedRecTime: item.estimatedRecTime,
              price: item.price,
              totalPrice: item.totalPrice,
              composition: item.composition,
              purpose: item.purpose,
              quoteLossRate: item.quoteLossRate,
              quoteAmount: item.quoteAmount,
              remarks: item.remarks
            }
          }))
        }
      })
    }
  } else if (type === 'CUSTOMROWS') {
    if (arr && arr.length > 0) {
      arr.forEach(row => {
        if (row.specList && row.specList.length > 0) {
          result = result.concat(row.specList.map(item => {
            return {
              materialsId: row.id,
              specListId: item.id,
              name: row.name,
              unit: row.unit,
              customCategoryName: row.customCategoryName,
              price: item.price
            }
          }))
        }
      })
    }
  }

  return result;
};

export {
  handleSumbitData,
  handleInitData
};
