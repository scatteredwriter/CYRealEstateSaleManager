//
//  CYEditHouseViewController.h
//  CYRealEstateSaleManager
//
//  Created by rod on 5/4/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYEditHouseViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) void (^editHouseBlock)(HouseItem *house, CustomerItem* customer);
@property (nonatomic, strong) HouseItem *editHouse;
@property (nonatomic, strong) CustomerItem *editCustomer;
@end

NS_ASSUME_NONNULL_END
