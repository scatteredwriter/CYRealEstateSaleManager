//
//  HouseManager.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/4/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "HouseManager.h"

static HouseManager *_sharedHouseManager;

@implementation HouseItem

@end

@implementation CustomerItem

@end

@implementation HouseManager
{
    sqlite3 *db;
}

+ (HouseManager *)sharedHouseManager {
    if (!_sharedHouseManager) {
        _sharedHouseManager = [[HouseManager alloc] init];
    }
    return _sharedHouseManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createHouseTable];
        [self createCustomerTable];
    }
    return self;
}

- (void)createHouseTable {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return;
    }
    const char *create_house_table_sql = "create table if not exists House (\
    Id INTEGER PRIMARY KEY AUTOINCREMENT,\
    Address TEXT,\
    HuXing TEXT,\
    Area REAL,\
    Price REAL,\
    Status INTEGER,\
    OrderIdCard TEXT);";
    if (sqlite3_exec(db, create_house_table_sql, NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"创建数据库表House成功");
    } else {
        NSLog(@"创建数据库表House失败");
    }
    sqlite3_close(db);
}

- (void)createCustomerTable {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return;
    }
    const char *create_customer_table_sql = "create table if not exists Customer (\
    IdCard TEXT PRIMARY KEY,\
    Name TEXT,\
    Phone INTEGER);";
    if (sqlite3_exec(db, create_customer_table_sql, NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"创建数据库表Customer成功");
    } else {
        NSLog(@"创建数据库表Customer失败");
    }
    sqlite3_close(db);
}

- (NSMutableArray *)getAllHouses {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 查询所有房屋
    const char *select_all_houses_sql = "select * from House";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_all_houses_sql, -1, &statement, NULL) == SQLITE_OK) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
        // 执行sql
        while (sqlite3_step(statement) == SQLITE_ROW) {
            HouseItem *item = [[HouseItem alloc] init];
            item.Id = sqlite3_column_int(statement, 0);
            item.address = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            item.huXing = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
            item.area = sqlite3_column_double(statement, 3);
            item.price = sqlite3_column_double(statement, 4);
            item.status = sqlite3_column_int(statement, 5);
            item.orderIdCard = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
            
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

- (HouseManagerStatusCode)insertHouse:(HouseItem *)house {
    if (!house)
        return HouseManagerStatusCodeError;
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return HouseManagerStatusCodeError;
    }
    // 插入房屋数据
    const char *insert_house_sql = "insert into House (Address,HuXing,Area,Price,Status,OrderIdCard) values(?,?,?,?,?,?)";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, insert_house_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [house.address UTF8String], -1, NULL); // 地址
        sqlite3_bind_text(statement, 2, [house.huXing UTF8String], -1, NULL); // 户型
        sqlite3_bind_double(statement, 3, house.area); // 面积
        sqlite3_bind_double(statement, 4, house.price); // 价格
        sqlite3_bind_int(statement, 5, house.status); // 状态
        sqlite3_bind_text(statement, 6, [house.orderIdCard UTF8String], -1, NULL); // 订房用户的身份证号
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"房屋(地址: %@)插入成功", house.address);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeOK;
        } else {
            NSLog(@"房屋(地址: %@)插入失败", house.address);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return HouseManagerStatusCodeError;
}

- (HouseManagerStatusCode)updateHouse:(HouseItem *)house {
    if (!house)
        return HouseManagerStatusCodeError;
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return HouseManagerStatusCodeError;
    }
    // 更新房屋数据
    const char *update_house_sql = "update House set Address=?,HuXing=?,Area=?,Price=?,Status=?,OrderIdCard=? where Id=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, update_house_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [house.address UTF8String], -1, NULL); // 地址
        sqlite3_bind_text(statement, 2, [house.huXing UTF8String], -1, NULL); // 户型
        sqlite3_bind_double(statement, 3, house.area); // 面积
        sqlite3_bind_double(statement, 4, house.price); // 价格
        sqlite3_bind_int(statement, 5, house.status); // 状态
        sqlite3_bind_text(statement, 6, [house.orderIdCard UTF8String], -1, NULL); // 订房用户的身份证号
        sqlite3_bind_int(statement, 7, house.Id); // Id
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"房屋(地址: %@)更新成功", house.address);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeOK;
        } else {
            NSLog(@"房屋(地址: %@)更新失败", house.address);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return HouseManagerStatusCodeError;
}

- (NSMutableArray *)searchHouseByAddress:(NSString *)address {
    if (!address)
        return nil;
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 搜索房屋数据
    NSString *search_houses_sql = [[NSString alloc] initWithFormat:@"select * from House where Address like '%%%@%%'", address];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [search_houses_sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [address UTF8String], -1, NULL); // 地址
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
        // 执行SQL
        while (sqlite3_step(statement) == SQLITE_ROW) {
            HouseItem *item = [[HouseItem alloc] init];
            item.Id = sqlite3_column_int(statement, 0);
            item.address = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            item.huXing = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
            item.area = sqlite3_column_double(statement, 3);
            item.price = sqlite3_column_double(statement, 4);
            item.status = sqlite3_column_int(statement, 5);
            item.orderIdCard = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
            
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

- (HouseManagerStatusCode)deleteHouseById:(int)Id {
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return HouseManagerStatusCodeError;
    }
    // 删除房屋数据
    const char *delete_house_sql = "delete from House where Id=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, delete_house_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_int(statement, 1, Id); // Id
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"房屋(Id: %d)删除成功", Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeOK;
        } else {
            NSLog(@"房屋(Id: %d)删除失败", Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return HouseManagerStatusCodeError;
}

- (HouseManagerStatusCode)insertCustomer:(CustomerItem *)customer {
    if (!customer)
        return HouseManagerStatusCodeError;
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return HouseManagerStatusCodeError;
    }
    // 插入订房用户数据
    const char *insert_customer_sql = "insert into Customer values(?,?,?)";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, insert_customer_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [customer.idCard UTF8String], -1, NULL); // 身份证号
        sqlite3_bind_text(statement, 2, [customer.name UTF8String], -1, NULL); // 名字
        sqlite3_bind_int64(statement, 3, customer.phone); // 手机号
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"顾客信息(名称: %@)插入成功", customer.name);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeOK;
        } else {
            NSLog(@"顾客信息(名称: %@)插入失败", customer.name);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return HouseManagerStatusCodeError;
}

- (CustomerItem *)selectCustomerByIdCard:(NSString *)idCard {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 查询订房用户数据
    const char *select_customer_sql = "select * from Customer where IdCard=?";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_customer_sql, -1, &statement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [idCard UTF8String], -1, NULL); // 身份证号
        // 执行sql
        if (sqlite3_step(statement) == SQLITE_ROW) {
            CustomerItem *item = [[CustomerItem alloc] init];
            item.idCard = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            item.name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            item.phone = sqlite3_column_int(statement, 2);
            NSLog(@"查找到订房用户(姓名: %@)", item.name);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return item;
        } else {
            NSLog(@"没有找到订房用户");
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return nil;
}

- (HouseManagerStatusCode)updateCustomer:(CustomerItem *)customer {
    if (!customer)
        return HouseManagerStatusCodeError;
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return HouseManagerStatusCodeError;
    }
    if (![self selectCustomerByIdCard:customer.idCard]) {
        // 没有该订房用户信息，插入该订房用户
        return [self insertCustomer:customer];
    }
    // 插入订房用户数据
    const char *update_house_sql = "update Customer set Name=?,Phone=? where IdCard=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, update_house_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [customer.name UTF8String], -1, NULL); // 姓名
        sqlite3_bind_int64(statement, 2, customer.phone); // 手机号
        sqlite3_bind_text(statement, 3, [customer.idCard UTF8String], -1, NULL); // 身份证号
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"订房用户(姓名: %@)更新成功", customer.name);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeOK;
        } else {
            NSLog(@"订房用户(姓名: %@)更新失败", customer.name);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return HouseManagerStatusCodeError;
}

- (HouseManagerStatusCode)deleteCustomerByIdCard:(NSString *)idCard {
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return HouseManagerStatusCodeError;
    }
    // 删除订房用户数据
    const char *delete_customer_sql = "delete from Customer where IdCard=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, delete_customer_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [idCard UTF8String], -1, NULL); // 身份证号
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"订房用户(idCard: %@)删除成功", idCard);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeOK;
        } else {
            NSLog(@"订房用户(idCard: %@)删除失败", idCard);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return HouseManagerStatusCodeError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return HouseManagerStatusCodeError;
}

@end
