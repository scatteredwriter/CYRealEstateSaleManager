//
//  CYMeViewController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/5/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYMeViewController.h"

@interface CYMeViewController ()
@property (nonatomic, strong) UserItem *user;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *staffInfoLabel;
@property (nonatomic, strong) UILabel *idField;
@property (nonatomic, strong) UILabel *nameField;
@property (nonatomic, strong) UISegmentedControl *deprSegmentControl;
@property (nonatomic, strong) UISegmentedControl *jobSegmentControl;
@property (nonatomic, strong) UILabel *phoneField;
@property (nonatomic, strong) UILabel *saledHousesCountLabel;
@property (nonatomic, strong) UILabel *salesCommissionLabel;
@property (nonatomic, strong) UILabel *passwordInfoLabel;
@property (nonatomic, strong) UITextField *oldPasswordTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *changePasswordButton;
@property (nonatomic, strong) UILabel *logoutLabel;
@property (nonatomic, strong) UIButton *logoutButton;
@end

@implementation CYMeViewController

- (instancetype)init {
    if (self = [super init]) {
        self.user = [UserManager sharedUserManager].loginUser;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    self.staffInfoLabel = [[UILabel alloc] init];
    self.staffInfoLabel.text = @"个人信息";
    self.staffInfoLabel.font = [UIFont systemFontOfSize:20];
    [self.staffInfoLabel sizeToFit];
    [self.scrollView addSubview:self.staffInfoLabel];
    
    self.idField = [[UILabel alloc] init];
    self.idField.enabled = NO;
    self.idField.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.idField];
    
    self.nameField = [[UILabel alloc] init];
    self.nameField.enabled = NO;
    self.nameField.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.nameField];
    
    self.deprSegmentControl = [[UISegmentedControl alloc] initWithItems:@[USER_DEPR_SALE, USER_DEPR_ACCOUNT, USER_DEPR_HR, USER_DEPR_ADMIN]];
    self.deprSegmentControl.enabled = NO;
    self.deprSegmentControl.selectedSegmentIndex = 0;
    [self.scrollView addSubview:self.deprSegmentControl];
    
    self.jobSegmentControl = [[UISegmentedControl alloc] initWithItems:@[USER_JOB_SALER, USER_JOB_ACCOUNTANT, USER_JOB_HR, USER_JOB_ADMIN]];
    self.jobSegmentControl.enabled = NO;
    self.jobSegmentControl.selectedSegmentIndex = 0;
    [self.scrollView addSubview:self.jobSegmentControl];
    
    self.phoneField = [[UILabel alloc] init];
    self.phoneField.enabled = NO;
    self.phoneField.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.phoneField];
    
    self.saledHousesCountLabel = [[UILabel alloc] init];
    self.saledHousesCountLabel.enabled = NO;
    self.saledHousesCountLabel.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.saledHousesCountLabel];
    
    self.salesCommissionLabel = [[UILabel alloc] init];
    self.salesCommissionLabel.enabled = NO;
    self.salesCommissionLabel.font = [UIFont systemFontOfSize:17];
    [self.scrollView addSubview:self.salesCommissionLabel];
    
    self.passwordInfoLabel = [[UILabel alloc] init];
    self.passwordInfoLabel.text = @"更改密码";
    self.passwordInfoLabel.font = [UIFont systemFontOfSize:20];
    [self.passwordInfoLabel sizeToFit];
    [self.scrollView addSubview:self.passwordInfoLabel];
    
    self.oldPasswordTextField = [[UITextField alloc] init];
    self.oldPasswordTextField.placeholder = @"请输入旧密码";
    self.oldPasswordTextField.font = [UIFont systemFontOfSize:17];
    self.oldPasswordTextField.secureTextEntry = YES;
    self.oldPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.oldPasswordTextField.returnKeyType = UIReturnKeyDone;
    self.oldPasswordTextField.delegate = self;
    [self.scrollView addSubview:self.oldPasswordTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"请输入新密码";
    self.passwordTextField.font = [UIFont systemFontOfSize:17];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    [self.scrollView addSubview:self.passwordTextField];
    
    self.changePasswordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.changePasswordButton.enabled = NO;
    self.changePasswordButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.changePasswordButton setTitle:@"更改密码" forState:UIControlStateNormal];
    [self.changePasswordButton setTitle:@"更改密码" forState:UIControlStateHighlighted];
    [self.changePasswordButton addTarget:self action:@selector(changePasswordButtonClickHandler) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
    [self.scrollView addSubview:self.changePasswordButton];
    
    self.logoutLabel = [[UILabel alloc] init];
    self.logoutLabel.text = @"退出账号";
    self.logoutLabel.font = [UIFont systemFontOfSize:20];
    [self.logoutLabel sizeToFit];
    [self.scrollView addSubview:self.logoutLabel];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.logoutButton setTitle:@"退出" forState:UIControlStateNormal];
    [self.logoutButton setTitle:@"退出" forState:UIControlStateHighlighted];
    [self.logoutButton addTarget:self action:@selector(logoutButtonClickHandler) forControlEvents:UIControlEventTouchUpInside]; // 绑定点击事件
    [self.scrollView addSubview:self.logoutButton];
    
    [self p_initUserInfo];
}

- (void)p_initUserInfo {
    if (self.user) {
        self.idField.text = [[NSString alloc] initWithFormat:@"工号: %lld", self.user.Id];
        self.idField.enabled = NO;
        self.nameField.text = [[NSString alloc] initWithFormat:@"姓名: %@", self.user.name];
        self.deprSegmentControl.selectedSegmentIndex = self.user.department;
        self.jobSegmentControl.selectedSegmentIndex = self.user.job;
        self.phoneField.text = [[NSString alloc] initWithFormat:@"联系方式: %lld", self.user.phone];
        if (self.user.job == UserJobSaler) {
            self.saledHousesCountLabel.text = [[NSString alloc] initWithFormat:@"销售房屋套数: %d套", [[HouseManager sharedHouseManager] getSaledHousesCountByStaffId:self.user.Id]];
            [self.saledHousesCountLabel sizeToFit];
            self.salesCommissionLabel.text = [[NSString alloc] initWithFormat:@"销售房屋提成: %.2lf万", [[HouseManager sharedHouseManager] getSalesCommissionByStaffId:self.user.Id]];
            [self.salesCommissionLabel sizeToFit];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.user.job == UserJobSaler && self.saledHousesCountLabel && self.salesCommissionLabel) {
        self.saledHousesCountLabel.text = [[NSString alloc] initWithFormat:@"销售房屋套数: %d套", [[HouseManager sharedHouseManager] getSaledHousesCountByStaffId:self.user.Id]];
        [self.saledHousesCountLabel sizeToFit];
        self.salesCommissionLabel.text = [[NSString alloc] initWithFormat:@"销售房屋提成: %.2lf万", [[HouseManager sharedHouseManager] getSalesCommissionByStaffId:self.user.Id]];
        [self.salesCommissionLabel sizeToFit];
    }
    [self viewWillLayoutSubviews];
}

- (void)viewWillLayoutSubviews {
    self.scrollView.frame = self.view.bounds;
    self.staffInfoLabel.frame = CGRectMake(15, 15, CGRectGetWidth(self.staffInfoLabel.frame), CGRectGetHeight(self.staffInfoLabel.frame));
    [self.idField sizeToFit];
    self.idField.frame = CGRectMake(15, CGRectGetMaxY(self.staffInfoLabel.frame) + 20, CGRectGetWidth(self.idField.frame), CGRectGetHeight(self.idField.frame));
    [self.nameField sizeToFit];
    self.nameField.frame = CGRectMake(15, CGRectGetMaxY(self.idField.frame) + 10, CGRectGetWidth(self.nameField.frame), CGRectGetHeight(self.nameField.frame));
    self.deprSegmentControl.frame = CGRectMake(15, CGRectGetMaxY(self.nameField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 30);
    self.jobSegmentControl.frame = CGRectMake(15, CGRectGetMaxY(self.deprSegmentControl.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 30);
    [self.phoneField sizeToFit];
    self.phoneField.frame = CGRectMake(15, CGRectGetMaxY(self.jobSegmentControl.frame) + 10, CGRectGetWidth(self.phoneField.frame), CGRectGetHeight(self.phoneField.frame));
    self.saledHousesCountLabel.frame = CGRectMake(15, CGRectGetMaxY(self.phoneField.frame) + 10, CGRectGetWidth(self.saledHousesCountLabel.frame), CGRectGetHeight(self.saledHousesCountLabel.frame));
    self.salesCommissionLabel.frame = CGRectMake(15, CGRectGetMaxY(self.saledHousesCountLabel.frame) + 10, CGRectGetWidth(self.salesCommissionLabel.frame), CGRectGetHeight(self.salesCommissionLabel.frame));
    self.passwordInfoLabel.frame = CGRectMake(15, CGRectGetMaxY(self.salesCommissionLabel.frame) + 50, CGRectGetWidth(self.passwordInfoLabel.frame), CGRectGetHeight(self.passwordInfoLabel.frame));
    self.oldPasswordTextField.frame = CGRectMake(15, CGRectGetMaxY(self.passwordInfoLabel.frame) + 20, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.passwordTextField.frame = CGRectMake(15, CGRectGetMaxY(self.oldPasswordTextField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.changePasswordButton.frame = CGRectMake(15, CGRectGetMaxY(self.passwordTextField.frame) + 30, CGRectGetWidth(self.view.frame) - 15 * 2, 60);
    self.logoutLabel.frame = CGRectMake(15, CGRectGetMaxY(self.changePasswordButton.frame) + 50, CGRectGetWidth(self.logoutLabel.frame), CGRectGetHeight(self.logoutLabel.frame));
    self.logoutButton.frame = CGRectMake(15, CGRectGetMaxY(self.logoutLabel.frame) + 30, CGRectGetWidth(self.view.frame) - 15 * 2, 60);
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.logoutButton.frame) + 10);
}

// 修改账号密码按钮点击处理
- (void)changePasswordButtonClickHandler {
    int ret;
    NSString *oldPassword = self.oldPasswordTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [[UserManager sharedUserManager] selectUserId:self.user.Id withPassword:oldPassword withRet:&ret];
    if (ret == UserManagerStatusCodePasswordError) {
        // 密码输入错误
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改密码失败" message:@"旧密码输入错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:retryAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (ret == UserManagerStatusCodeUserNotExist) {
        // 用户不存在
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改密码失败" message:@"该用户不存在" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:retryAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (ret == UserManagerStatusCodeOK) {
        // 登录成功
        ret = [[UserManager sharedUserManager] updatePassword:password byId:self.user.Id];
        if (ret == UserManagerStatusCodeOK) {
            // 密码修改成功
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码修改成功" message:@"您的密码已修改" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改密码失败" message:@"遭遇未知错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:retryAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

// 退出账号按钮点击处理
- (void)logoutButtonClickHandler {
    NSLog(@"账号退出");
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    keyWindow.rootViewController = [[CYMainViewController alloc] init];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.oldPasswordTextField.text.length && self.passwordTextField.text.length) {
        self.changePasswordButton.enabled = YES;
    } else {
        self.changePasswordButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
