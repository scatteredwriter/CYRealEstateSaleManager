//
//  DataBaseManager.m
//  CYRealEstateSaleManager
//
//  Created by rod on 4/27/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "DataBaseManager.h"
#import <sqlite3.h>

@interface DataBaseManager ()
@end

@implementation DataBaseManager

- (instancetype)init {
    if (self = [super init]) {
        [self initDataBaseFile];
    }
    return self;
}

- (void)initDataBaseFile {
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    self.dbFilePath = [documentDir stringByAppendingPathComponent:DB_FILENAME];
}

@end
