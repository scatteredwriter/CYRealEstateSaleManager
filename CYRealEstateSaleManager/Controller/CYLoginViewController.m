//
//  CYLoginViewController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 4/27/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYLoginViewController.h"
#import "UserManager.h"

@interface CYLoginViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *button;
@end

@implementation CYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账号登录";
    
    // 初始化titleLable
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"房地产销售销售管理系统";
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:self.titleLabel];
    
    // 初始化accountTextField
    self.accountTextField = [[UITextField alloc] init];
    self.accountTextField.delegate = self;
    self.accountTextField.placeholder = @"请输入工号";
    [self.accountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    self.accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.accountTextField.font = [UIFont systemFontOfSize:17]; // 设置字体大小
    [self.view addSubview:self.accountTextField];
    
    // 初始化passwordTextField
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.delegate = self;
    self.passwordTextField.placeholder = @"请输入密码";
    [self.passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES; // 设置为安全输入
    self.passwordTextField.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:self.passwordTextField];
    
    // 初始化button
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.enabled = YES;
    self.button.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.button setTitle:@"登录" forState:UIControlStateNormal];
    [self.button setTitle:@"登录" forState:UIControlStateHighlighted];
    [self.button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
    [self.view addSubview:self.button];
}

// 设置控件布局
- (void)viewWillLayoutSubviews {
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.titleLabel.frame)) / 2, 130, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    self.accountTextField.frame = CGRectMake(15, 250, (CGRectGetWidth(self.view.frame) - 15 * 2), 40);
    self.passwordTextField.frame = CGRectMake(15, CGRectGetMaxY(self.accountTextField.frame) + 15, (CGRectGetWidth(self.view.frame) - 15 * 2), 40);
    self.button.frame = CGRectMake(15, CGRectGetMaxY(self.passwordTextField.frame) + 30, (CGRectGetWidth(self.view.frame) - 15 * 2), 60);
}

// button被点击
- (void)buttonClicked {
    if ([self.accountTextField canResignFirstResponder])
        [self.accountTextField resignFirstResponder];
    if ([self.passwordTextField canResignFirstResponder])
        [self.passwordTextField resignFirstResponder];
    int ret;
    int Id = [self.accountTextField.text intValue];
    NSString *password = self.passwordTextField.text;
    
    UserItem *item = [[UserManager sharedUserManager] selectUserId:Id withPassword:password withRet:&ret];
    if (ret == UserManagerStatusCodePasswordError) {
        // 密码输入错误
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"密码输入错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:retryAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (ret == UserManagerStatusCodeUserNotExist) {
        // 用户不存在
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"该用户不存在" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:retryAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (ret == UserManagerStatusCodeOK) {
        // 登录成功
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.loginBlock) {
                self.loginBlock(item);
            }
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField && self.button.enabled) {
        [self buttonClicked];
    }
    return YES;
}

@end
