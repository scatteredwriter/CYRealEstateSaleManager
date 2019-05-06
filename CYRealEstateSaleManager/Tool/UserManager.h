//
//  UserManager.h
//  CYRealEstateSaleManager
//
//  Created by rod on 5/4/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "DataBaseManager.h"

#define USER_DEPR_SALE @"销售部"
#define USER_DEPR_ACCOUNT @"财务部"
#define USER_DEPR_HR @"人力资源部"
#define USER_DEPR_ADMIN @"管理部"

#define USER_JOB_SALER @"销售"
#define USER_JOB_ACCOUNTANT @"会计"
#define USER_JOB_HR @"HR"
#define USER_JOB_ADMIN @"管理员"
#define USER_ADMIN_ID 4001

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    UserDepartmentSale = 0,
    UserDepartmentAccount,
    UserDepartmentHr,
    UserDepartmentAdmin
} UserDepartment;

typedef enum {
    UserJobSaler = 0,
    UserJobAccountant,
    UserJobHr,
    UserJobAdmin
} UserJob;

@interface UserItem : NSObject
@property (nonatomic, assign) int64_t Id;
@property (nonatomic, assign) UserDepartment department;
@property (nonatomic, assign) UserJob job;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int64_t phone;
@end

typedef enum {
    UserManagerStatusCodeOK = 0,
    UserManagerStatusCodePasswordError,
    UserManagerStatusCodeUserNotExist,
    UserManagerStatusCodeOtherError
} UserManagerStatusCode;

@interface UserManager : DataBaseManager
@property (nonatomic, strong, readonly) UserItem *loginUser;
+ (UserManager *)sharedUserManager;
- (UserItem *)selectUserId:(int64_t)Id;
- (UserItem *)selectUserId:(int64_t)Id withPassword:(NSString *)password withRet:(int *)ret;
- (UserManagerStatusCode)updatePassword:(NSString *)password byId:(int64_t)Id;
- (UserManagerStatusCode)insertUser:(UserItem *)user;
- (NSMutableArray *)getAllStaffs;
- (UserManagerStatusCode)updateStaff:(UserItem *)staff;
- (UserManagerStatusCode)deleteStaffById:(int64_t)Id;
@end

NS_ASSUME_NONNULL_END
