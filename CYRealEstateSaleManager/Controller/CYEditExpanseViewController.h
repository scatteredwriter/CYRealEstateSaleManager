//
//  CYEditExpanseViewController.h
//  CYRealEstateSaleManager
//
//  Created by rod on 5/6/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "FinanceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYEditExpanseViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) void (^editExpanseBlock)(ExpanseItem *expanse);
@property (nonatomic, strong) ExpanseItem *editExpanse;
@end

NS_ASSUME_NONNULL_END
