//
//  CYEditExpanseViewController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/6/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYEditExpanseViewController.h"

@interface CYEditExpanseViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *expanseInfoLabel;
@property (nonatomic, strong) UITextField *amountField;
@property (nonatomic, strong) UISegmentedControl *typeSegmentControl;
@property (nonatomic, strong) UITextField *targetStaffField;
@end

@implementation CYEditExpanseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.editExpanse ? @"编辑支出信息" : @"添加支出信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClickHandler)];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    self.expanseInfoLabel = [[UILabel alloc] init];
    self.expanseInfoLabel.text = @"支出信息";
    self.expanseInfoLabel.font = [UIFont systemFontOfSize:20];
    [self.expanseInfoLabel sizeToFit];
    [self.scrollView addSubview:self.expanseInfoLabel];
    
    self.amountField = [[UITextField alloc] init];
    self.amountField.placeholder = @"请输入支出金额(单位: 万)";
    self.amountField.font = [UIFont systemFontOfSize:17];
    [self.amountField setKeyboardType:UIKeyboardTypeDecimalPad];
    self.amountField.borderStyle = UITextBorderStyleRoundedRect;
    self.amountField.returnKeyType = UIReturnKeyDone;
    self.amountField.delegate = self;
    [self.scrollView addSubview:self.amountField];
    
    self.typeSegmentControl = [[UISegmentedControl alloc] initWithItems:@[Expanse_Type_StaffSalary, Expanse_Type_OfficeSupply]];
    self.typeSegmentControl.selectedSegmentIndex = 0;
    [self.typeSegmentControl addTarget:self action:@selector(segmentControlValueChange) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.typeSegmentControl];
    
    self.targetStaffField = [[UITextField alloc] init];
    self.targetStaffField.placeholder = @"请输入目标员工工号)";
    self.targetStaffField.font = [UIFont systemFontOfSize:17];
    [self.targetStaffField setKeyboardType:UIKeyboardTypeNumberPad];
    self.targetStaffField.borderStyle = UITextBorderStyleRoundedRect;
    self.targetStaffField.returnKeyType = UIReturnKeyDone;
    self.targetStaffField.delegate = self;
    [self.scrollView addSubview:self.targetStaffField];
    
    [self p_initUserInfo];
}

- (void)p_initUserInfo {
    if (self.editExpanse) {
        self.amountField.text = [[NSString alloc] initWithFormat:@"%.2f", self.editExpanse.amount];
        self.amountField.enabled = NO;
        self.typeSegmentControl.selectedSegmentIndex = self.editExpanse.type;
        self.typeSegmentControl.enabled = NO;
        if (self.editExpanse.type == ExpanseTypeStaffSalary) {
            self.targetStaffField.text = [[NSString alloc] initWithFormat:@"%lld",self.editExpanse.targetStaffId];
        }
    }
}

- (void)viewWillLayoutSubviews {
    self.scrollView.frame = self.view.bounds;
    self.expanseInfoLabel.frame = CGRectMake(15, 15, CGRectGetWidth(self.expanseInfoLabel.frame), CGRectGetHeight(self.expanseInfoLabel.frame));
    self.amountField.frame = CGRectMake(15, CGRectGetMaxY(self.expanseInfoLabel.frame) + 20, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.typeSegmentControl.frame = CGRectMake(15, CGRectGetMaxY(self.amountField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 30);
    if (self.typeSegmentControl.selectedSegmentIndex == ExpanseTypeStaffSalary) {
        self.targetStaffField.frame = CGRectMake(15, CGRectGetMaxY(self.typeSegmentControl.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    } else {
        self.targetStaffField.frame = CGRectZero;
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.targetStaffField.frame) + 10);
}

- (void)segmentControlValueChange {
    [self viewWillLayoutSubviews];
}

- (void)doneButtonClickHandler {
    BOOL isStaffInfoComplete = ((self.amountField.text.length && self.typeSegmentControl.selectedSegmentIndex == ExpanseTypeOfficeSupply) || (self.amountField.text.length && self.targetStaffField.text.length && self.typeSegmentControl.selectedSegmentIndex == ExpanseTypeStaffSalary));
    if (!isStaffInfoComplete) {
        // 信息没有输入完全
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作失败" message:@"请补充完成剩余信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (self.editExpanseBlock) {
        ExpanseItem *item = [[ExpanseItem alloc] init];
        if (self.editExpanse) {
            item.type = self.editExpanse.type;
            if (item.type == ExpanseTypeStaffSalary)
                item.targetStaffId = self.editExpanse.targetStaffId;
        } else {
            item.type = (ExpanseType)self.typeSegmentControl.selectedSegmentIndex;
            if (item.type == ExpanseTypeStaffSalary)
                @try {
                    item.targetStaffId = [self.targetStaffField.text longLongValue];
                } @catch (NSException *exception) {
                    NSLog(@"目标员工工号输入非法!");
                }
        }
        @try {
            item.amount = [self.amountField.text doubleValue];
        } @catch (NSException *exception) {
            NSLog(@"金额输入非法!");
        }
        item.staffId = [UserManager sharedUserManager].loginUser.Id;
        item.date = [NSDate date];
        self.editExpanseBlock(item);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
