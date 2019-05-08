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
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:10];
    
    if ([UserManager sharedUserManager].loginUser.department == UserDepartmentSale || [UserManager sharedUserManager].loginUser.department == UserDepartmentAdmin) {
        CYHouseManagerController *saleManagerViewController = [[CYHouseManagerController alloc] init];
        saleManagerViewController.tabBarItem.title = @"销售";
        saleManagerViewController.tabBarItem.image = [UIImage imageNamed:@"home"];
        [viewControllers addObject:[[UINavigationController alloc] initWithRootViewController:saleManagerViewController]];
    }
    
    if ([UserManager sharedUserManager].loginUser.department == UserDepartmentAccount || [UserManager sharedUserManager].loginUser.department == UserDepartmentAdmin) {
        CYFinanceManagerController *financeManagerController = [[CYFinanceManagerController alloc] init];
        financeManagerController.tabBarItem.title = @"财务";
        financeManagerController.tabBarItem.image = [UIImage imageNamed:@"list"];
        [viewControllers addObject:[[UINavigationController alloc] initWithRootViewController:financeManagerController]];
    }
    
    if ([UserManager sharedUserManager].loginUser.department == UserDepartmentHr || [UserManager sharedUserManager].loginUser.department == UserDepartmentAdmin) {
        CYStaffManageController *staffManageController = [[CYStaffManageController alloc] init];
        staffManageController.tabBarItem.title = @"员工";
        staffManageController.tabBarItem.image = [UIImage imageNamed:@"user_group_man_woman"];
        [viewControllers addObject:[[UINavigationController alloc] initWithRootViewController:staffManageController]];
    }
    
    CYMeViewController *meController = [[CYMeViewController alloc] init];
    meController.tabBarItem.title = @"我的";
    meController.tabBarItem.image = [UIImage imageNamed:@"user_male"];
    [viewControllers addObject:[[UINavigationController alloc] initWithRootViewController:meController]];
    
    self.viewControllers = viewControllers;
}

@end
