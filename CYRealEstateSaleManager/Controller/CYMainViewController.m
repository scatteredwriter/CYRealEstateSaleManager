//
//  CYMainViewController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 4/27/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYMainViewController.h"
#import "CYLoginViewController.h"
#import "CYMainTabBarController.h"

@interface CYMainViewController ()
@property (nonatomic, assign) BOOL loginFinished;
@property (nonatomic, strong) CYLoginViewController *loginViewController;
@end

@implementation CYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.loginViewController) {
        self.loginViewController = [[CYLoginViewController alloc] init];
        self.loginViewController.loginBlock = ^(UserItem * _Nonnull user) {
            if (user && user.name) {
                UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
                keyWindow.rootViewController = [[CYMainTabBarController alloc] init];
            }
        };
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.loginViewController] animated:YES completion:nil];
    }
}

@end
