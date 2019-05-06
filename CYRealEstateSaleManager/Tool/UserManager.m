//
//  UserManager.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/4/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "UserManager.h"

static UserManager *_sharedUserManager;

@implementation UserItem

@end

@implementation UserManager
{
    sqlite3 *db;
}

+ (instancetype)sharedUserManager {
    if (!_sharedUserManager) {
        _sharedUserManager = [[UserManager alloc] init];
    }
    return _sharedUserManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createUserTable];
        [self p_insertAdminUser];
    }
    return self;
}

- (void)createUserTable {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return;
    }
    const char *create_user_table_sql = "create table if not exists User (\
    Id INTEGER PRIMARY KEY,\
    Name TEXT,\
    Department TEXT,\
    Job INTEGER,\
    Phone INTEGER,\
    Password TEXT);";
    if (sqlite3_exec(db, create_user_table_sql, NULL, NULL, NULL) == SQLITE_OK) {
        NSLog(@"创建数据库表User成功");
    } else {
        NSLog(@"创建数据库表User失败");
    }
    sqlite3_close(db);
}

// 查询用户
- (UserItem *)selectUserId:(int64_t)Id {
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 查询用户
    const char *select_user_sql = "select * from User where Id=?";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_user_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_int64(statement, 1, Id);
        // 执行sql
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"查询到用户(Id: %lld)", Id);
            UserItem *item = [[UserItem alloc] init];
            item.Id = sqlite3_column_int64(statement, 0);
            item.name = [[NSString alloc] initWithUTF8String:((const char *)sqlite3_column_text(statement, 1))];
            item.department = (UserDepartment)sqlite3_column_int(statement, 2);
            item.job = (UserJob)sqlite3_column_int(statement, 3);
            item.phone = sqlite3_column_int64(statement, 4);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return item;
        } else {
            NSLog(@"没有查询到用户");
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return nil;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return nil;
}

// 通过密码查询用户
- (UserItem *)selectUserId:(int64_t)Id withPassword:(NSString *)password withRet:(int *)ret {
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        *ret = UserManagerStatusCodeOtherError;
        return nil;
    }
    // 查询用户密码
    const char *select_password_sql = "select * from User where Id=?";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_password_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_int64(statement, 1, Id);
        // 执行sql
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"查询到用户(Id: %lld)", Id);
            // 数据库中查询到的密码
            NSString *_password = [[NSString alloc] initWithUTF8String:((const char *)sqlite3_column_text(statement, 5))];
            // 比较密码是否相同
            if ([password isEqualToString:_password]) {
                NSLog(@"密码输入正确");
                UserItem *item = [[UserItem alloc] init];
                item.Id = sqlite3_column_int64(statement, 0);
                item.name = [[NSString alloc] initWithUTF8String:((const char *)sqlite3_column_text(statement, 1))];
                item.department = (UserDepartment)sqlite3_column_int(statement, 2);
                item.job = (UserJob)sqlite3_column_int(statement, 3);
                item.phone = sqlite3_column_int64(statement, 4);
                sqlite3_finalize(statement);
                sqlite3_close(db);
                _loginUser = item;
                *ret = UserManagerStatusCodeOK;
                return item;
            } else {
                NSLog(@"密码输入错误");
                sqlite3_finalize(statement);
                sqlite3_close(db);
                *ret = UserManagerStatusCodePasswordError;
                return nil;
            }
        } else {
            NSLog(@"没有查询到用户");
            sqlite3_finalize(statement);
            sqlite3_close(db);
            *ret = UserManagerStatusCodeUserNotExist;
            return nil;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    *ret = UserManagerStatusCodeOtherError;
    return nil;
}

// 修改用户密码
- (UserManagerStatusCode)updatePassword:(NSString *)password byId:(int64_t)Id {
    if (!password)
        return UserManagerStatusCodePasswordError;
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return UserManagerStatusCodeOtherError;
    }
    // 更新用户密码
    const char *update_password_sql = "update User set Password=? where Id=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, update_password_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [password UTF8String], -1, NULL); // 名称
        sqlite3_bind_int64(statement, 2, Id); // 工号
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"员工(工号: %lld)密码更新成功", Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOK;
        } else {
            NSLog(@"员工(工号: %lld)密码更新失败", Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOtherError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return UserManagerStatusCodeOtherError;
}

// 插入管理员账号
- (UserManagerStatusCode)p_insertAdminUser {
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return UserManagerStatusCodeOtherError;
    }
    // 查询管理员账号
    const char *select_admin_sql = "select * from User where Job=?";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_admin_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_int(statement, 1, UserJobAdmin);
        // 执行sql
        if (sqlite3_step(statement) != SQLITE_ROW) {
            NSLog(@"数据库中没有管理员账号，现在插入");
            sqlite3_finalize(statement);
            
            const char *insert_admin_sql = "insert into User values(?,?,?,?,?,?)";
            if (sqlite3_prepare_v2(db, insert_admin_sql, -1, &statement, NULL) == SQLITE_OK) {
                // 绑定参数
                sqlite3_bind_int64(statement, 1, USER_ADMIN_ID); // 工号
                sqlite3_bind_text(statement, 2, "Admin", -1, NULL); // 名称
                sqlite3_bind_int(statement, 3, UserDepartmentAdmin); // 部门
                sqlite3_bind_int(statement, 4, UserJobAdmin); // 职位
                sqlite3_bind_int64(statement, 5, 10000000000); // 手机
                sqlite3_bind_text(statement, 6, "111111", -1, NULL); //密码
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    NSLog(@"管理员账号插入成功");
                    sqlite3_finalize(statement);
                    sqlite3_close(db);
                    return UserManagerStatusCodeOK;
                } else {
                    NSLog(@"插入管理员账号失败");
                    sqlite3_finalize(statement);
                    sqlite3_close(db);
                    return UserManagerStatusCodeOtherError;
                }
            }
        } else {
            // 已有管理员账号
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOK;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return UserManagerStatusCodeOtherError;
}

// 插入账号
- (UserManagerStatusCode)insertUser:(UserItem *)user {
    if (!user) {
        return UserManagerStatusCodeOtherError;
    }
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return UserManagerStatusCodeOtherError;
    }
    // 插入账号
    const char *insert_user_sql = "insert into User values(?,?,?,?,?,?)";
    sqlite3_stmt *statement;
    // SQL预处理
    if (sqlite3_prepare_v2(db, insert_user_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_int64(statement, 1, user.Id); // 工号
        sqlite3_bind_text(statement, 2, [user.name UTF8String], -1, NULL); // 名称
        sqlite3_bind_int(statement, 3, user.department); // 部门
        sqlite3_bind_int(statement, 4, user.job); // 职位
        sqlite3_bind_int64(statement, 5, user.phone); // 手机
        sqlite3_bind_text(statement, 6, "111111", -1, NULL); //密码
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"账号(工号: %lld)插入成功", user.Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOK;
        } else {
            NSLog(@"账号(工号: %lld)插入失败", user.Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOtherError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return UserManagerStatusCodeOtherError;
}

- (NSMutableArray *)getAllStaffs {
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    // 查询所有员工
    const char *select_all_staffs_sql = "select * from User";
    sqlite3_stmt *statement;
    // 对sql预处理
    if (sqlite3_prepare_v2(db, select_all_staffs_sql, -1, &statement, NULL) == SQLITE_OK) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
        // 执行sql
        while (sqlite3_step(statement) == SQLITE_ROW) {
            if (sqlite3_column_int64(statement, 0) == USER_ADMIN_ID) {
                // 该用户是超级管理员，无需显示
                continue;
            }
            UserItem *item = [[UserItem alloc] init];
            item.Id = sqlite3_column_int64(statement, 0);
            item.name = [[NSString alloc] initWithUTF8String:((const char *)sqlite3_column_text(statement, 1))];
            item.department = (UserDepartment)sqlite3_column_int(statement, 2);
            item.job = (UserJob)sqlite3_column_int(statement, 3);
            item.phone = sqlite3_column_int64(statement, 4);
            
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

- (UserManagerStatusCode)updateStaff:(UserItem *)staff {
    if (!staff)
        return UserManagerStatusCodeOtherError;
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return UserManagerStatusCodeOtherError;
    }
    // 更新员工数据
    const char *update_house_sql = "update User set Name=?,Department=?,Job=?,Phone=? where Id=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, update_house_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_text(statement, 1, [staff.name UTF8String], -1, NULL); // 名称
        sqlite3_bind_int(statement, 2, staff.department); // 部门
        sqlite3_bind_int(statement, 3, staff.job); // 职位
        sqlite3_bind_int64(statement, 4, staff.phone); // 手机
        sqlite3_bind_int64(statement, 5, staff.Id); // 工号
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"员工(工号: %lld)更新成功", staff.Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOK;
        } else {
            NSLog(@"员工(工号: %lld)更新失败", staff.Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOtherError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return UserManagerStatusCodeOtherError;
}

- (UserManagerStatusCode)deleteStaffById:(int64_t)Id {
    // 打开数据库
    if (sqlite3_open([self.dbFilePath UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return UserManagerStatusCodeOtherError;
    }
    // 删除员工数据
    const char *delete_staff_sql = "delete from User where Id=?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, delete_staff_sql, -1, &statement, NULL) == SQLITE_OK) {
        // 绑定参数
        sqlite3_bind_int64(statement, 1, Id); // Id
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"员工(Id: %lld)删除成功", Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOK;
        } else {
            NSLog(@"员工(Id: %lld)删除失败", Id);
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return UserManagerStatusCodeOtherError;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(db);
    return UserManagerStatusCodeOtherError;
}

@end
