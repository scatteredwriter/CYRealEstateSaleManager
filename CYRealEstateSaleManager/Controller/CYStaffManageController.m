//
//  CYStaffManageController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/5/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYStaffManageController.h"

// 员工管理列表Cell声明及实现
@interface StaffTableViewCell : UITableViewCell
@property (nonatomic, strong) UserItem *staff;
@end

@interface StaffTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, assign) CGFloat leftMargin;
@end

@implementation StaffTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftMargin = 50;
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.nameLabel];
        
        self.departmentLabel = [[UILabel alloc] init];
        self.departmentLabel.font = [UIFont systemFontOfSize:14];
        self.departmentLabel.textColor = [UIColor grayColor];
        [self addSubview:self.departmentLabel];
        
        self.idLabel = [[UILabel alloc] init];
        self.idLabel.font = [UIFont systemFontOfSize:14];
        self.idLabel.textColor = [UIColor grayColor];
        [self addSubview:self.idLabel];
        
        self.phoneLabel = [[UILabel alloc] init];
        self.phoneLabel.font = [UIFont systemFontOfSize:14];
        self.phoneLabel.textColor = [UIColor grayColor];
        [self addSubview:self.phoneLabel];
        
        self.jobLabel = [[UILabel alloc] init];
        self.jobLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.jobLabel];
        
        self.separatorView = [[UIView alloc] init];
        self.separatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)setStaff:(UserItem *)staff {
    if (!staff)
        return;
    _staff = staff;
    self.nameLabel.text = _staff.name;
    self.idLabel.text = [NSString stringWithFormat:@"工号: %lld", _staff.Id];
    if (_staff.department == UserDepartmentSale) {
        self.departmentLabel.text = USER_DEPR_SALE;
    } else if (_staff.department == UserDepartmentAccount) {
        self.departmentLabel.text = USER_DEPR_ACCOUNT;
    } else if (_staff.department == UserDepartmentHr) {
        self.departmentLabel.text = USER_DEPR_HR;
    }
    if (_staff.job == UserJobSaler) {
        self.jobLabel.text = USER_JOB_SALER;
    } else if (_staff.job == UserJobAccountant) {
        self.jobLabel.text = USER_JOB_ACCOUNTANT;
    } else if (_staff.job == UserJobHr) {
        self.jobLabel.text = USER_JOB_HR;
    }
    self.phoneLabel.text = [NSString stringWithFormat:@"联系方式: %lld", _staff.phone];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(self.leftMargin, 15, CGRectGetWidth(self.nameLabel.frame), CGRectGetHeight(self.nameLabel.frame));
    
    [self.jobLabel sizeToFit];
    self.jobLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 10, CGRectGetMaxY(self.nameLabel.frame) - CGRectGetHeight(self.jobLabel.frame), CGRectGetWidth(self.jobLabel.frame), CGRectGetHeight(self.jobLabel.frame));
    
    [self.idLabel sizeToFit];
    self.idLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 10, CGRectGetWidth(self.idLabel.frame), CGRectGetHeight(self.idLabel.frame));
    
    [self.phoneLabel sizeToFit];
    self.phoneLabel.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.idLabel.frame) + 10, CGRectGetWidth(self.phoneLabel.frame), CGRectGetHeight(self.phoneLabel.frame));
    
    [self.departmentLabel sizeToFit];
    self.departmentLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.departmentLabel.frame) - 15, CGRectGetMinY(self.nameLabel.frame), CGRectGetWidth(self.departmentLabel.frame), CGRectGetHeight(self.departmentLabel.frame));
    
    self.separatorView.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.phoneLabel.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMinX(self.nameLabel.frame), 0.5);
}

@end

@interface CYStaffManageController ()
@property (nonatomic, strong) UITableView *staffTableView;
@property (nonatomic, strong) NSMutableArray *staffArray;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation CYStaffManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"员工";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeButtonClickHandler)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClickHandler)];
    
    self.staffTableView = [[UITableView alloc] init];
    [self.staffTableView registerClass:StaffTableViewCell.class forCellReuseIdentifier:@"StaffTableViewCell"];
    self.staffTableView.delegate = self;
    self.staffTableView.dataSource = self;
    self.staffTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.staffTableView];
    
    [self p_initData];
}

// 初始化数据
- (void)p_initData {
    self.staffArray = [[UserManager sharedUserManager] getAllStaffs];
    if (self.staffArray && self.staffArray.count) {
        [self.staffTableView reloadData];
    }
}

// 删除按钮的点击处理
- (void)removeButtonClickHandler {
    self.isEdit = !self.isEdit;
    [self.staffTableView setEditing:self.isEdit animated:YES];
}

// 添加按钮的点击处理
- (void)addButtonClickHandler {
    CYEditStaffViewController *editController = [[CYEditStaffViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    editController.editStaffBlock = ^(UserItem * _Nonnull staff) {
        if (staff) {
            [[UserManager sharedUserManager] insertUser:staff];
        }
        [weakSelf p_initData];
    };
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)viewWillLayoutSubviews {
    self.staffTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.staffArray)
        return self.staffArray.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int idx = (int)indexPath.row;
    if (idx >= self.staffArray.count || idx < 0)
        return nil;
    StaffTableViewCell *cell = [self.staffTableView dequeueReusableCellWithIdentifier:@"StaffTableViewCell"];
    cell.staff = ((UserItem *)self.staffArray[idx]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    int idx = (int)indexPath.row;
    if (idx >= self.staffArray.count || idx < 0)
        return;
    if ([[UserManager sharedUserManager] deleteStaffById:((UserItem *)self.staffArray[idx]).Id] == UserManagerStatusCodeOK) {
        [self.staffArray removeObjectAtIndex:indexPath.row];
        [self.staffTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.staffTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.staffTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int idx = (int)indexPath.row;
    if (self.staffArray) {
        if (idx >= self.staffArray.count || idx < 0)
            return;
    }
    CYEditStaffViewController *editController = [[CYEditStaffViewController alloc] init];
    editController.editStaff = ((UserItem *)self.staffArray[idx]);
    __weak typeof(self) weakSelf = self;
    editController.editStaffBlock = ^(UserItem * _Nonnull staff) {
        if (staff) {
            [[UserManager sharedUserManager] updateStaff:staff];
        }
        [weakSelf p_initData];
    };
    [self.navigationController pushViewController:editController animated:YES];
}

@end
