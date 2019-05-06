//
//  FinanceManager.h
//  CYRealEstateSaleManager
//
//  Created by rod on 5/6/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "DataBaseManager.h"
#import "UserManager.h"
#import "HouseManager.h"

#define Income_Type_Ordered @"房屋预定"
#define Income_Type_Saled @"房屋出售"
#define Expanse_Type_StaffSalary @"发放员工工资"
#define Expanse_Type_OfficeSupply @"购置办公物品"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    IncomeTypeOrdered = 0,
    IncomeTypeSaled
} IncomeType;

typedef enum {
    ExpanseTypeStaffSalary = 0,
    ExpanseTypeOfficeSupply
} ExpanseType;

@interface IncomeItem : NSObject
@property (nonatomic, assign) Float64 amount;
@property (nonatomic, copy) NSString *houseAddress;
@property (nonatomic, copy) NSString *customerName;
@property (nonatomic, assign) IncomeType type;
@end

@interface ExpanseItem : NSObject
@property (nonatomic, assign) Float64 amount;
@property (nonatomic, assign) int64_t staffId;
@property (nonatomic, assign) int64_t targetStaffId;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) ExpanseType type;
@end

typedef enum {
    FianaceManagerStatusCodeOK = 0,
    FianaceManagerStatusCodeTargetStaffNotExist,
    FianaceManagerStatusCodeError
} FianaceManagerStatusCode;

@interface FinanceManager : DataBaseManager
+ (FinanceManager *)sharedFinanceManager;
- (NSMutableArray *)getAllIncomes;
- (NSMutableArray *)getAllExpanses;
- (Float64)getTotalIncomes;
- (Float64)getTotalExpanses;
- (FianaceManagerStatusCode)insertExpanse:(ExpanseItem *)expanse;
@end

NS_ASSUME_NONNULL_END
