//
//  CYMainTabBarController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 4/27/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYMainTabBarController.h"

@interface CYMainTabBarController ()
@end

@implementation CYMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CYSaleManagerViewController *saleManagerViewController = [[CYSaleManagerViewController alloc] init];
    saleManagerViewController.tabBarItem.title = @"销售";
    saleManagerViewController.tabBarItem.image = [UIImage imageNamed:@"home"];
    
    CYStaffManageController *staffManageController = [[CYStaffManageController alloc] init];
    staffManageController.tabBarItem.title = @"员工";
    staffManageController.tabBarItem.image = [UIImage imageNamed:@"user_group_man_woman"];
    
    CYMeViewController *meController = [[CYMeViewController alloc] init];
    meController.tabBarItem.title = @"我的";
    meController.tabBarItem.image = [UIImage imageNamed:@"user_male"];
    
    self.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:saleManagerViewController],
                             [[UINavigationController alloc] initWithRootViewController:staffManageController],
                             [[UINavigationController alloc] initWithRootViewController:meController]];
}

@end
