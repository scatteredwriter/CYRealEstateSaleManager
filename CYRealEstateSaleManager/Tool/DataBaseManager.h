//
//  DataBaseManager.h
//  CYRealEstateSaleManager
//
//  Created by rod on 4/27/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DB_FILENAME @"cy.sqlite3"

NS_ASSUME_NONNULL_BEGIN

@interface DataBaseManager : NSObject
@property (nonatomic, copy) NSString *dbFilePath;
@end

NS_ASSUME_NONNULL_END
