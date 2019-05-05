//
//  CYLoginViewController.h
//  CYRealEstateSaleManager
//
//  Created by rod on 4/27/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYLoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) void (^loginBlock)(UserItem *user);
@end

NS_ASSUME_NONNULL_END
