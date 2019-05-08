//
//  FinanceManager.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/6/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "FinanceManager.h"

static FinanceManager *_sharedFinanceManager;

@implementation IncomeItem

@end

@implementation ExpanseItem

@end

@interface FinanceManager ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation FinanceManager
{
    sqlite3 *db;
}

+ (FinanceManager *)sharedFinanceManager {
    if (!_sharedFinanceManager) {
        _sharedFinanceManager = [[FinanceManager alloc] init];
    }
    return _sharedFinanceManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self createExpanseTable];
    }
    return self;
}

- (void)createExpanseTable {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return;
    }
    const char *create_expanse_table_sql = "create table if not exists Expanse (\
    Id INTEGER PRIMARY KEY AUTOINCREMENT,\
    Amount REAL,\
    StaffId INTEGER,\
    TargetStaffId INTEGER,\
    Date TEXT,\
    Type INTEGER);";
    if (sqlite3_exec(db, create_expanse_table_sql, NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"创建数据库表Expanse成功");
    } else {
        NSLog(@"创建数据库表Expanse失败");
    }
    sqlite3_close(db);
}

- (NSMutableArray *)getAllIncomes {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 查询所有收入信息
    const char *select_all_incomes_sql = "select h.Status,h.Price,h.Address,c.Name from House as h inner join Customer as c on h.OrderIdCard=c.IdCard where (h.Status=1 or h.Status=2)";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_all_incomes_sql, -1, &statement, NULL) == SQLITE_OK) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
        // 执行sql
        while (sqlite3_step(statement) == SQLITE_ROW) {
            IncomeItem *item = [[IncomeItem alloc] init];
            HouseStatus houseSatus = (HouseStatus)sqlite3_column_int(statement, 0);
            item.amount = sqlite3_column_double(statement, 1) * (houseSatus == HouseStatusOrdered ? 0.1 : 1.0);
            item.houseAddress = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
            item.customerName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
            item.type = (houseSatus == HouseStatusOrdered ? IncomeTypeOrdered :IncomeTypeSaled);
            
            [array addObject:item];
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        return array;
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return nil;
}

- (Float64)getTotalIncomes {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return 0.0;
    }
    // 查询总收入
    const char *select_total_incomes_sql = "select Status,Price from House where (Status=1 or Status=2)";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_total_incomes_sql, -1, &statement, NULL) == SQLITE_OK) {
        Float64 totalIncomes = 0.0;
        // 执行sql
        while (sqlite3_step(statement) == SQLITE_ROW) {
            HouseStatus houseSatus = (HouseStatus)sqlite3_column_int(statement, 0);
            totalIncomes += sqlite3_column_double(statement, 1) * (houseSatus == HouseStatusOrdered ? 0.1 : 1.0);
        }
        NSLog(@"总收入: %.2f", totalIncomes);
        sqlite3_finalize(statement);
        sqlite3_close(db);
        return totalIncomes;
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return 0.0;
}

- (Float64)getTotalExpanses {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return 0.0;
    }
    // 查询总支出
    const char *select_total_expanses_sql = "select Amount from Expanse";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_total_expanses_sql, -1, &statement, NULL) == SQLITE_OK) {
        Float64 totalExpanses = 0.0;
        // 执行sql
        while (sqlite3_step(statement) == SQLITE_ROW) {
            totalExpanses +=sqlite3_column_double(statement, 0);
        }
        NSLog(@"总收入: %.2f", totalExpanses);
        sqlite3_finalize(statement);
        sqlite3_close(db);
        return totalExpanses;
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return 0.0;
}

- (NSMutableArray *)getAllExpanses {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 查询所有支出
    const char *select_all_expanses_sql = "select Amount,StaffId,TargetStaffId,Date,Type from Expanse";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_all_expanses_sql, -1, &statement, NULL) == SQLITE_OK) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
        // 执行sql
        while (sqlite3_step(statement) == SQLITE_ROW) {
            ExpanseItem *item = [[ExpanseItem alloc] init];
            item.amount = sqlite3_column_double(statement, 0);
            item.staffId = sqlite3_column_int64(statement, 1);
            item.targetStaffId = sqlite3_column_int64(statement, 2);
            item.date = [self.dateFormatter dateFromString:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]];
            item.type = (ExpanseType)sqlite3_column_int(statement, 4);
            
            [array addObject:item];
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
        return array;
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return nil;
}

- (FianaceManagerStatusCode)insertExpanse:(ExpanseItem *)expanse {
    if (!expanse)
        return FianaceManagerStatusCodeError;
    if (expanse.type == ExpanseTypeStaffSalary) {
        if (![[UserManager sharedUserManager] selectUserId:expanse.targetStaffId]) {
            NSLog(@"目标员工不存在，无法创建支出");
            return FianaceManagerStatusCodeTargetStaffNotExist;
        }
    }
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return FianaceManagerStatusCodeError;
    }
    // 插入房屋数据
    const char *insert_house_sql = "insert into Expanse (Amount,StaffId,TargetStaffId,Date,Type) values(?,?,?,?,?)";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, insert_house_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_double(statement, 1, expanse.amount); // 金额
        sqlite3_bind_int64(statement, 2, expanse.staffId); // 创建员工Id
        sqlite3_bind_int64(statement, 3, expanse.targetStaffId); // 目标员工Id
        sqlite3_bind_text(statement, 4, [[self.dateFormatter stringFromDate:expanse.date] UTF8String], -1, NULL); // 日期
        sqlite3_bind_int(statement, 5, expanse.type); // 类型
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"支出(金额: %.2f)插入成功", expanse.amount);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return FianaceManagerStatusCodeOK;
        } else {
            NSLog(@"支出(金额: %.2f)插入失败", expanse.amount);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return FianaceManagerStatusCodeError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return FianaceManagerStatusCodeError;
}

@end
