//成本核算单核算


//行成本
function getEntryCostPrice(entry) {
  let laborPrice = 0;
  let materialsPrice = 0;
  let specialPrice = 0;
  //工费
  if (entry.costOrder.laborCostEntries != null) {
    entry.costOrder.laborCostEntries.forEach(element => {
      let num;
      //含税
      if (entry.costOrder.isIncludeTax) {
        if (element.unitPriceIncludingTax != null) {
          num = parseFloat(element.unitPriceIncludingTax);
        }
      } else {
        if (element.unitPriceExcludingTax != null) {
          num = parseFloat(element.unitPriceExcludingTax);
        }
      }

      if (num != null && (!Number.isNaN(num))) {
        laborPrice += num;
      }
    });
  }

  //物料
  if (entry.costOrder.materialsEntries != null) {
    entry.costOrder.materialsEntries.forEach(element => {
      let num;
      //含税
      if (entry.costOrder.isIncludeTax) {
        if (element.unitPriceIncludingTax != null) {
          num = parseFloat(element.unitPriceIncludingTax);
        }
      } else {
        if (element.unitPriceExcludingTax != null) {
          num = parseFloat(element.unitPriceExcludingTax);
        }
      }

      if (num != null && (!Number.isNaN(num))) {
        //实际用量价格
        let price = num * (parseFloat(element.materialsSpecEntry.lossRate) + 1.0) * parseFloat(element
          .materialsSpecEntry.unitQuantity);
        materialsPrice += price;
      }
    });
  }

  //工艺
  if (entry.costOrder.specialProcessEntries != null) {
    entry.costOrder.specialProcessEntries.forEach(element => {
      let num;
      //含税
      if (entry.costOrder.isIncludeTax) {
        if (element.unitPriceIncludingTax != null) {
          num = parseFloat(element.unitPriceIncludingTax);
        }
      } else {
        if (element.unitPriceExcludingTax != null) {
          num = parseFloat(element.unitPriceExcludingTax);
        }
      }

      if (num != null && (!Number.isNaN(num))) {
        specialPrice += num;
      }
    });
  }
  return (laborPrice + materialsPrice + specialPrice);
}

//数量
function getEntryTotalAmount(entry) {
  var result = 0;
  entry.colorSizeEntries.forEach(element => {
    let num = parseFloat(element.quantity);
    if (!Number.isNaN(num)) {
      result += num
    }
  });
  return result;
}


//销售总价    
function getEntryTotalPrice(entry) {
  let result = getEntryTotalAmount(entry) * (parseFloat(entry.unitPrice));
  if (!Number.isNaN(result)) {
    return result;
  } else {
    return '';
  }
}


//总成本
function getEntryTotalCost(entry) {
  let result = getEntryTotalAmount(entry) * getEntryCostPrice(entry);
  if (!Number.isNaN(result)) {
    return result.toFixed(2);
  } else {
    return '';
  }
}


//利润
function getEntryProfit(entry) {
  let result = '';
  if (getEntryTotalPrice(entry) != '' && getEntryTotalCost(entry) != '') {
    result = getEntryTotalPrice(entry) - getEntryTotalCost(entry);
  }
  return result;
}

//利润率
function getEntryProfitPercent(entry) {
  let profit = getEntryProfit(entry);
  let totalPrice = getEntryTotalPrice(entry);
  if (profit != '' && totalPrice != '') {
    return (parseFloat(profit / totalPrice) * 100).toFixed(2);
  } else {
    return '';
  }
}

export {
  getEntryCostPrice,
  getEntryTotalAmount,
  getEntryTotalPrice,
  getEntryTotalCost,
  getEntryProfit,
  getEntryProfitPercent
}
