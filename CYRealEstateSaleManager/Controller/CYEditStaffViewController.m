//
//  CYEditStaffViewController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/5/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYEditStaffViewController.h"

@interface CYEditStaffViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *staffInfoLabel;
@property (nonatomic, strong) UITextField *idField;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UISegmentedControl *deprSegmentControl;
@property (nonatomic, strong) UISegmentedControl *jobSegmentControl;
@property (nonatomic, strong) UITextField *phoneField;
@end

@implementation CYEditStaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加员工信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClickHandler)];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    self.staffInfoLabel = [[UILabel alloc] init];
    self.staffInfoLabel.text = @"员工信息";
    self.staffInfoLabel.font = [UIFont systemFontOfSize:20];
    [self.staffInfoLabel sizeToFit];
    [self.scrollView addSubview:self.staffInfoLabel];
    
    self.idField = [[UITextField alloc] init];
    self.idField.placeholder = @"请输入员工工号";
    self.idField.font = [UIFont systemFontOfSize:17];
    [self.idField setKeyboardType:UIKeyboardTypeNumberPad];
    self.idField.borderStyle = UITextBorderStyleRoundedRect;
    self.idField.returnKeyType = UIReturnKeyDone;
    self.idField.delegate = self;
    [self.scrollView addSubview:self.idField];
    
    self.nameField = [[UITextField alloc] init];
    self.nameField.placeholder = @"请输入员工姓名";
    self.nameField.font = [UIFont systemFontOfSize:17];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.returnKeyType = UIReturnKeyDone;
    self.nameField.delegate = self;
    [self.scrollView addSubview:self.nameField];
    
    self.deprSegmentControl = [[UISegmentedControl alloc] initWithItems:@[USER_DEPR_SALE, USER_DEPR_ACCOUNT, USER_DEPR_HR]];
    self.deprSegmentControl.selectedSegmentIndex = 0;
    [self.scrollView addSubview:self.deprSegmentControl];
    
    self.jobSegmentControl = [[UISegmentedControl alloc] initWithItems:@[USER_JOB_SALER, USER_JOB_ACCOUNTANT, USER_JOB_HR]];
    self.jobSegmentControl.selectedSegmentIndex = 0;
    [self.scrollView addSubview:self.jobSegmentControl];
    
    self.phoneField = [[UITextField alloc] init];
    self.phoneField.placeholder = @"请输入员工联系方式";
    self.phoneField.font = [UIFont systemFontOfSize:17];
    [self.phoneField setKeyboardType:UIKeyboardTypeNumberPad];
    self.phoneField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneField.returnKeyType = UIReturnKeyDone;
    self.phoneField.delegate = self;
    [self.scrollView addSubview:self.phoneField];
    
    [self p_initUserInfo];
}

- (void)setEditStaff:(UserItem *)editStaff {
    if (!editStaff)
        return;
    _editStaff = editStaff;
    self.title = @"编辑房屋信息";
}

- (void)p_initUserInfo {
    if (self.editStaff) {
        self.idField.text = [[NSString alloc] initWithFormat:@"%lld", self.editStaff.Id];
        self.idField.enabled = NO;
        self.nameField.text = self.editStaff.name;
        self.deprSegmentControl.selectedSegmentIndex = self.editStaff.department;
        self.jobSegmentControl.selectedSegmentIndex = self.editStaff.job;
        self.phoneField.text = [[NSString alloc] initWithFormat:@"%lld", self.editStaff.phone];
    }
}

- (void)viewWillLayoutSubviews {
    self.scrollView.frame = self.view.bounds;
    self.staffInfoLabel.frame = CGRectMake(15, 15, CGRectGetWidth(self.staffInfoLabel.frame), CGRectGetHeight(self.staffInfoLabel.frame));
    self.idField.frame = CGRectMake(15, CGRectGetMaxY(self.staffInfoLabel.frame) + 20, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.nameField.frame = CGRectMake(15, CGRectGetMaxY(self.idField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.deprSegmentControl.frame = CGRectMake(15, CGRectGetMaxY(self.nameField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 30);
    self.jobSegmentControl.frame = CGRectMake(15, CGRectGetMaxY(self.deprSegmentControl.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 30);
    self.phoneField.frame = CGRectMake(15, CGRectGetMaxY(self.jobSegmentControl.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.phoneField.frame) + 10);
}

- (void)doneButtonClickHandler {
    BOOL isStaffInfoComplete = self.idField.text.length && self.nameField.text.length && self.phoneField.text.length;
    if (!isStaffInfoComplete) {
        // 信息没有输入完全
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作失败" message:@"请补充完成剩余信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (self.editStaffBlock) {
        UserItem *item = [[UserItem alloc] init];
        if (self.editStaff) {
            item.Id = self.editStaff.Id;
        } else {
            item.Id = [self.idField.text integerValue];
        }
        item.name = self.nameField.text;
        item.department = (UserDepartment)self.deprSegmentControl.selectedSegmentIndex;
        item.job = (UserJob)self.jobSegmentControl.selectedSegmentIndex;
        item.phone = 0;
        @try {
            item.phone = [self.phoneField.text longLongValue];
        } @catch (NSException *exception) {
            NSLog(@"联系方式输入非法!");
        }
        self.editStaffBlock(item);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
