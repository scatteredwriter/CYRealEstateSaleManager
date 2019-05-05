//
//  CYEditHouseViewController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/4/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYEditHouseViewController.h"

@interface CYEditHouseViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *houseInfoTipLabel;
@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) UITextField *huXingField;
@property (nonatomic, strong) UITextField *areaField;
@property (nonatomic, strong) UITextField *priceField;
@property (nonatomic, strong) UISegmentedControl *statusSegmentControl;
@property (nonatomic, strong) UILabel *orderInfoTipLabel;
@property (nonatomic, strong) UITextField *orderNameField;
@property (nonatomic, strong) UITextField *orderPhoneField;
@property (nonatomic, strong) UITextField *orderIdCardField;
@end

@implementation CYEditHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加房屋信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClickHandler)];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    self.houseInfoTipLabel = [[UILabel alloc] init];
    self.houseInfoTipLabel.text = @"房屋信息(必填)";
    self.houseInfoTipLabel.font = [UIFont systemFontOfSize:20];
    [self.houseInfoTipLabel sizeToFit];
    [self.scrollView addSubview:self.houseInfoTipLabel];
    
    self.addressField = [[UITextField alloc] init];
    self.addressField.placeholder = @"请输入房屋地址";
    self.addressField.font = [UIFont systemFontOfSize:17];
    self.addressField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressField.returnKeyType = UIReturnKeyDone;
    self.addressField.delegate = self;
    [self.scrollView addSubview:self.addressField];
    
    self.huXingField = [[UITextField alloc] init];
    self.huXingField.placeholder = @"请输入房屋户型";
    self.huXingField.font = [UIFont systemFontOfSize:17];
    self.huXingField.borderStyle = UITextBorderStyleRoundedRect;
    self.huXingField.returnKeyType = UIReturnKeyDone;
    self.huXingField.delegate = self;
    [self.scrollView addSubview:self.huXingField];
    
    self.areaField = [[UITextField alloc] init];
    self.areaField.placeholder = @"请输入房屋面积(单位: 平方米)";
    self.areaField.font = [UIFont systemFontOfSize:17];
    [self.areaField setKeyboardType:UIKeyboardTypeDecimalPad];
    self.areaField.borderStyle = UITextBorderStyleRoundedRect;
    self.areaField.returnKeyType = UIReturnKeyDone;
    self.areaField.delegate = self;
    [self.scrollView addSubview:self.areaField];
    
    self.priceField = [[UITextField alloc] init];
    self.priceField.placeholder = @"请输入房屋价格(单位: 万)";
    self.priceField.font = [UIFont systemFontOfSize:17];
    [self.priceField setKeyboardType:UIKeyboardTypeDecimalPad];
    self.priceField.borderStyle = UITextBorderStyleRoundedRect;
    self.priceField.returnKeyType = UIReturnKeyDone;
    self.priceField.delegate = self;
    [self.scrollView addSubview:self.priceField];
    
    NSArray *segmentItems = @[HOUSE_STATUS_WAIT_FOR_SALED, HOUSE_STATUS_ORDERED, HOUSE_STATUS_SALED];
    self.statusSegmentControl = [[UISegmentedControl alloc] initWithItems:segmentItems];
    self.statusSegmentControl.selectedSegmentIndex = 0;
    [self.scrollView addSubview:self.statusSegmentControl];
    
    self.orderInfoTipLabel = [[UILabel alloc] init];
    self.orderInfoTipLabel.text = @"预定用户信息(可选)";
    self.orderInfoTipLabel.font = [UIFont systemFontOfSize:20];
    [self.orderInfoTipLabel sizeToFit];
    [self.scrollView addSubview:self.orderInfoTipLabel];
    
    self.orderNameField = [[UITextField alloc] init];
    self.orderNameField.placeholder = @"请输入预定用户名";
    self.orderNameField.font = [UIFont systemFontOfSize:17];
    self.orderNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.orderNameField.returnKeyType = UIReturnKeyDone;
    self.orderNameField.delegate = self;
    [self.scrollView addSubview:self.orderNameField];
    
    self.orderPhoneField = [[UITextField alloc] init];
    self.orderPhoneField.placeholder = @"请输入预定用户手机号";
    self.orderPhoneField.font = [UIFont systemFontOfSize:17];
    [self.orderPhoneField setKeyboardType:UIKeyboardTypeNumberPad];
    self.orderPhoneField.borderStyle = UITextBorderStyleRoundedRect;
    self.orderPhoneField.returnKeyType = UIReturnKeyDone;
    self.orderPhoneField.delegate = self;
    [self.scrollView addSubview:self.orderPhoneField];
    
    self.orderIdCardField = [[UITextField alloc] init];
    self.orderIdCardField.placeholder = @"请输入预定用户身份证号";
    self.orderIdCardField.font = [UIFont systemFontOfSize:17];
    self.orderIdCardField.borderStyle = UITextBorderStyleRoundedRect;
    self.orderIdCardField.returnKeyType = UIReturnKeyDone;
    self.orderIdCardField.delegate = self;
    [self.scrollView addSubview:self.orderIdCardField];
    
    [self p_initHouseInfo];
}

- (void)setEditHouse:(HouseItem *)editHouse {
    if (!editHouse)
        return;
    _editHouse = editHouse;
    self.title = @"编辑房屋信息";
}

- (void)setEditCustomer:(CustomerItem *)editCustomer {
    if (!editCustomer)
        return;
    _editCustomer = editCustomer;
    self.title = @"编辑房屋信息";
}

- (void)p_initHouseInfo {
    if (self.editHouse) {
        self.addressField.text = self.editHouse.address;
        self.huXingField.text = self.editHouse.huXing;
        self.areaField.text = [[NSString alloc] initWithFormat:@"%.2f", self.editHouse.area];
        self.priceField.text = [[NSString alloc] initWithFormat:@"%.2f", self.editHouse.price];
        self.statusSegmentControl.selectedSegmentIndex = self.editHouse.status;
    }
    if (self.editCustomer) {
        self.orderNameField.text = self.editCustomer.name;
        self.orderPhoneField.text = [[NSString alloc] initWithFormat:@"%lld", self.editCustomer.phone];
        self.orderIdCardField.text = self.editCustomer.idCard;
    }
}

- (void)viewWillLayoutSubviews {
    self.scrollView.frame = self.view.bounds;
    self.houseInfoTipLabel.frame = CGRectMake(15, 15, CGRectGetWidth(self.houseInfoTipLabel.frame), CGRectGetHeight(self.houseInfoTipLabel.frame));
    self.addressField.frame = CGRectMake(15, CGRectGetMaxY(self.houseInfoTipLabel.frame) + 20, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.huXingField.frame = CGRectMake(15, CGRectGetMaxY(self.addressField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.areaField.frame = CGRectMake(15, CGRectGetMaxY(self.huXingField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.priceField.frame = CGRectMake(15, CGRectGetMaxY(self.areaField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.statusSegmentControl.frame = CGRectMake(15, CGRectGetMaxY(self.priceField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 30);
    self.orderInfoTipLabel.frame = CGRectMake(15, CGRectGetMaxY(self.statusSegmentControl.frame) + 50, CGRectGetWidth(self.view.frame) - 15 * 2, CGRectGetHeight(self.orderInfoTipLabel.frame));
    self.orderNameField.frame = CGRectMake(15, CGRectGetMaxY(self.orderInfoTipLabel.frame) + 20, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.orderPhoneField.frame = CGRectMake(15, CGRectGetMaxY(self.orderNameField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.orderIdCardField.frame = CGRectMake(15, CGRectGetMaxY(self.orderPhoneField.frame) + 10, CGRectGetWidth(self.view.frame) - 15 * 2, 40);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.orderIdCardField.frame) + 10);
}

- (void)doneButtonClickHandler {
    BOOL isHouseInfoComplete = self.addressField.text.length && self.huXingField.text.length && self.areaField.text.length && self.priceField.text.length;
    BOOL isOrderInfoComplete = ((!self.orderNameField.text.length && !self.orderPhoneField.text.length && !self.orderIdCardField.text.length) || (self.orderNameField.text.length && self.orderPhoneField.text.length && self.orderIdCardField.text.length));
    if (!isHouseInfoComplete || !isOrderInfoComplete) {
        // 信息没有输入完全
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作失败" message:@"请补充完成剩余信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (self.editHouseBlock) {
        HouseItem *item = [[HouseItem alloc] init];
        if (self.editHouse) {
            item.Id = self.editHouse.Id;
        }
        item.address = self.addressField.text;
        item.huXing = self.huXingField.text;
        item.area = 0;
        item.price = 0;
        item.status = (HouseStatus)self.statusSegmentControl.selectedSegmentIndex;
        @try {
            item.area = [self.areaField.text doubleValue];
            item.price = [self.priceField.text doubleValue];
        } @catch (NSException *exception) {
            NSLog(@"面积或价格输入非法!");
        }
        CustomerItem *customer = nil;
        if (isOrderInfoComplete && self.orderNameField.text.length) {
            customer = [[CustomerItem alloc] init];
            customer.name = self.orderNameField.text;
            customer.phone = 0;
            customer.idCard = self.orderIdCardField.text;
            @try {
                customer.phone = [self.orderPhoneField.text intValue];
            } @catch (NSException *exception) {
                NSLog(@"预定用户手机号输入非法!");
            }
        }
        self.editHouseBlock(item, customer);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    if (textField == self.addressField) {
//        [self.addressField resignFirstResponder];
//        [self.huXingField becomeFirstResponder];
//    }
//    else if (textField == self.huXingField) {
//        [self.huXingField resignFirstResponder];
//        [self.areaField becomeFirstResponder];
//    }
//    else if (textField == self.areaField) {
//        [self.areaField resignFirstResponder];
//        [self.priceField becomeFirstResponder];
//    }
//    else if (textField == self.priceField) {
//        [self.priceField resignFirstResponder];
//        [self.orderNameField becomeFirstResponder];
//    }
//    else if (textField == self.orderNameField) {
//        [self.orderNameField resignFirstResponder];
//        [self.orderPhoneField becomeFirstResponder];
//    }
//    else if (textField == self.orderPhoneField) {
//        [self.orderPhoneField resignFirstResponder];
//        [self.orderIdCardField becomeFirstResponder];
//    }
//    else if (textField == self.orderIdCardField) {
//        [self.orderIdCardField resignFirstResponder];
//        [self doneButtonClickHandler];
//    }
    [textField resignFirstResponder];
    return YES;
}

@end
