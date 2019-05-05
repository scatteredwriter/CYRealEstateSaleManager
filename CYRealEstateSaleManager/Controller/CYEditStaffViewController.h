//
//  CYEditStaffViewController.h
//  CYRealEstateSaleManager
//
//  Created by rod on 5/5/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYEditStaffViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) void (^editStaffBlock)(UserItem *staff);
@property (nonatomic, strong) UserItem *editStaff;
@end

NS_ASSUME_NONNULL_END
