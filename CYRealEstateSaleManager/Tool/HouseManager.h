//
//  HouseManager.h
//  CYRealEstateSaleManager
//
//  Created by rod on 5/4/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "DataBaseManager.h"

#define HOUSE_STATUS_WAIT_FOR_SALED @"待出售"
#define HOUSE_STATUS_ORDERED @"已预定"
#define HOUSE_STATUS_SALED @"已售出"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    HouseStatusWaitForSaled = 0,
    HouseStatusOrdered,
    HouseStatusSaled
} HouseStatus;

@interface HouseItem : NSObject
@property (nonatomic, assign) Float64 Id;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *huXing;
@property (nonatomic, assign) Float64 area;
@property (nonatomic, assign) Float64 price;
@property (nonatomic, assign) HouseStatus status;
@property (nonatomic, strong) NSString *orderIdCard;
@end

@interface CustomerItem : NSObject
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int64_t phone;
@end

typedef enum {
    HouseManagerStatusCodeOK = 0,
    HouseManagerStatusCodeError
} HouseManagerStatusCode;

@interface HouseManager : DataBaseManager
+ (HouseManager *)sharedHouseManager;
- (NSMutableArray *)getAllHouses;
- (HouseManagerStatusCode)insertHouse:(HouseItem *)house;
- (HouseManagerStatusCode)updateHouse:(HouseItem *)house;
- (NSMutableArray *)searchHouseByAddress:(NSString *)address;
- (HouseManagerStatusCode)deleteHouseById:(int)Id;
- (HouseManagerStatusCode)insertCustomer:(CustomerItem *)customer;
- (CustomerItem *)selectCustomerByIdCard:(NSString *)idCard;
- (HouseManagerStatusCode)updateCustomer:(CustomerItem *)customer;
- (HouseManagerStatusCode)deleteCustomerByIdCard:(NSString *)idCard;
@end

NS_ASSUME_NONNULL_END
