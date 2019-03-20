#供应商管理
##业务定义
和品牌（或工厂）有业务往来的关联方。所谓业务往来，具体是指建立了采购（PurchaseOrder）业务（或交易）的品牌（或工厂)
##业务领域定义
###PurchaseOrder - 采购订单（又名生产订单）
purchaser - 采购方，即品牌Brand；
belongTo - 生产方，即工厂Factory
###Company - 品牌（或工厂）
####Brand - 品牌
####Factory - 工厂
##技术实现
在品牌端，取PurchaseOrder的belongTo字段对应对象的列表显示；
在工厂端，取PurchaseOrder的purchaser字段对应对象的列表显示；
不需要额外实现Service，在BrandService和FactoryService中添加相应的接口方法并实现。方法名称都为getSuppliers(companyUid, Pageable)


