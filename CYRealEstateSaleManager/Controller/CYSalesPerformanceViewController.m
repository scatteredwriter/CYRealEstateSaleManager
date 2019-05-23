//
//  CYSalesPerformanceViewController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/23/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYSalesPerformanceViewController.h"

// 销售房屋列表Cell声明及实现
@interface SalesHouseTableViewCell : UITableViewCell
@property (nonatomic, strong) HouseItem *house;
@end

@interface SalesHouseTableViewCell ()
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *huxingLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, assign) CGFloat leftMargin;
@end

@implementation SalesHouseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftMargin = 50;
        
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.addressLabel];
        
        self.huxingLabel = [[UILabel alloc] init];
        self.huxingLabel.font = [UIFont systemFontOfSize:14];
        self.huxingLabel.textColor = [UIColor grayColor];
        [self addSubview:self.huxingLabel];
        
        self.areaLabel = [[UILabel alloc] init];
        self.areaLabel.font = [UIFont systemFontOfSize:14];
        self.areaLabel.textColor = [UIColor grayColor];
        [self addSubview:self.areaLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.priceLabel.textColor = [UIColor grayColor];
        [self addSubview:self.priceLabel];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.text = HOUSE_STATUS_SALED;
        self.statusLabel.textColor = [UIColor redColor];
        [self addSubview:self.statusLabel];
        
        self.separatorView = [[UIView alloc] init];
        self.separatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)setHouse:(HouseItem *)house {
    if (!house)
        return;
    _house = house;
    self.addressLabel.text = _house.address;
    self.huxingLabel.text = _house.huXing;
    self.areaLabel.text = [NSString stringWithFormat:@"面积: %.2f平方米", _house.area];
    self.priceLabel.text = [NSString stringWithFormat:@"售价: %.2f万", _house.price];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.addressLabel sizeToFit];
    self.addressLabel.frame = CGRectMake(self.leftMargin, 15, CGRectGetWidth(self.addressLabel.frame), CGRectGetHeight(self.addressLabel.frame));
    
    [self.huxingLabel sizeToFit];
    self.huxingLabel.frame = CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 10, CGRectGetMaxY(self.addressLabel.frame) - CGRectGetHeight(self.huxingLabel.frame), CGRectGetWidth(self.huxingLabel.frame), CGRectGetHeight(self.huxingLabel.frame));
    
    [self.areaLabel sizeToFit];
    self.areaLabel.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.addressLabel.frame) + 10, CGRectGetWidth(self.areaLabel.frame), CGRectGetHeight(self.areaLabel.frame));
    
    [self.priceLabel sizeToFit];
    self.priceLabel.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.areaLabel.frame) + 10, CGRectGetWidth(self.priceLabel.frame), CGRectGetHeight(self.priceLabel.frame));
    
    [self.statusLabel sizeToFit];
    self.statusLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.statusLabel.frame) - 15, CGRectGetMinY(self.addressLabel.frame), CGRectGetWidth(self.statusLabel.frame), CGRectGetHeight(self.statusLabel.frame));
    
    self.separatorView.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.priceLabel.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMinX(self.addressLabel.frame), 0.5);
}

@end

// 个人业绩列表Cell声明及实现
@interface SalesCommissionTableViewCell : UITableViewCell
@property (nonatomic, strong) HouseItem *house;
@end

@interface SalesCommissionTableViewCell ()
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *huxingLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *salesPerformanceLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, assign) CGFloat leftMargin;
@end

@implementation SalesCommissionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftMargin = 50;
        
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.addressLabel];
        
        self.huxingLabel = [[UILabel alloc] init];
        self.huxingLabel.font = [UIFont systemFontOfSize:14];
        self.huxingLabel.textColor = [UIColor grayColor];
        [self addSubview:self.huxingLabel];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.priceLabel.textColor = [UIColor grayColor];
        [self addSubview:self.priceLabel];
        
        self.salesPerformanceLabel = [[UILabel alloc] init];
        self.salesPerformanceLabel.textColor = [UIColor greenColor];
        self.salesPerformanceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.salesPerformanceLabel];
        
        self.separatorView = [[UIView alloc] init];
        self.separatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)setHouse:(HouseItem *)house {
    if (!house)
        return;
    _house = house;
    self.addressLabel.text = _house.address;
    self.huxingLabel.text = _house.huXing;
    self.priceLabel.text = [NSString stringWithFormat:@"售价: %.2f万", _house.price];
    self.salesPerformanceLabel.text = [NSString stringWithFormat:@"+%.2f万", (_house.price * 5 / 1000)];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.addressLabel sizeToFit];
    self.addressLabel.frame = CGRectMake(self.leftMargin, 15, CGRectGetWidth(self.addressLabel.frame), CGRectGetHeight(self.addressLabel.frame));
    
    [self.huxingLabel sizeToFit];
    self.huxingLabel.frame = CGRectMake(CGRectGetMaxX(self.addressLabel.frame) + 10, CGRectGetMaxY(self.addressLabel.frame) - CGRectGetHeight(self.huxingLabel.frame), CGRectGetWidth(self.huxingLabel.frame), CGRectGetHeight(self.huxingLabel.frame));
    
    [self.priceLabel sizeToFit];
    self.priceLabel.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.addressLabel.frame) + 10, CGRectGetWidth(self.priceLabel.frame), CGRectGetHeight(self.priceLabel.frame));
    
    [self.salesPerformanceLabel sizeToFit];
    self.salesPerformanceLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.salesPerformanceLabel.frame) - 15, CGRectGetMinY(self.addressLabel.frame), CGRectGetWidth(self.salesPerformanceLabel.frame), CGRectGetHeight(self.salesPerformanceLabel.frame));
    
    self.separatorView.frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.priceLabel.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMinX(self.addressLabel.frame), 0.5);
}

@end

@interface CYSalesPerformanceViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UILabel *saledHousesCountLabel;
@property (nonatomic, strong) UILabel *totalSalesCommissionLabel;
@property (nonatomic, strong) UIView *headerView1;
@property (nonatomic, strong) UIView *headerView2;
@property (nonatomic, strong) UITableView *salesHouseTableView;
@property (nonatomic, strong) UITableView *salesCommissionTableView;
@property (nonatomic, strong) NSMutableArray *salesHouseArray;
@end

@implementation CYSalesPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClickHandler)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"房屋销售", @"个人提成"]];
    [self.segmentControl addTarget:self action:@selector(segmentControlValueChange) forControlEvents:UIControlEventValueChanged];
    self.segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentControl;
    
    self.salesHouseTableView = [[UITableView alloc] init];
    self.salesHouseTableView.allowsSelection = NO;
    [self.salesHouseTableView registerClass:SalesHouseTableViewCell.class forCellReuseIdentifier:@"SalesHouseTableViewCell"];
    self.salesHouseTableView.delegate = self;
    self.salesHouseTableView.dataSource = self;
    self.salesHouseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.salesHouseTableView];
    
    self.salesCommissionTableView = [[UITableView alloc] init];
    self.salesCommissionTableView.allowsSelection = NO;
    self.salesCommissionTableView.hidden = YES;
    [self.salesCommissionTableView registerClass:SalesCommissionTableViewCell.class forCellReuseIdentifier:@"SalesCommissionTableViewCell"];
    self.salesCommissionTableView.delegate = self;
    self.salesCommissionTableView.dataSource = self;
    self.salesCommissionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.salesCommissionTableView];
    
    self.saledHousesCountLabel = [[UILabel alloc] init];
    self.saledHousesCountLabel.textAlignment = NSTextAlignmentCenter;
    self.saledHousesCountLabel.font = [UIFont systemFontOfSize:20];
    self.headerView1 = [[UIView alloc] init];
    [self.headerView1 addSubview:self.saledHousesCountLabel];
    self.salesHouseTableView.tableHeaderView = self.headerView1;
    
    self.totalSalesCommissionLabel = [[UILabel alloc] init];
    self.totalSalesCommissionLabel.hidden = YES;
    self.totalSalesCommissionLabel.textAlignment = NSTextAlignmentCenter;
    self.totalSalesCommissionLabel.font = [UIFont systemFontOfSize:20];
    self.headerView2 = [[UIView alloc] init];
    [self.headerView2 addSubview:self.totalSalesCommissionLabel];
    self.salesCommissionTableView.tableHeaderView = self.headerView2;
    
    [self p_initData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self p_initData];
}

// 初始化数据
- (void)p_initData {
    UserItem *loginUser = [UserManager sharedUserManager].loginUser;
    int _saledHousesCount = [[HouseManager sharedHouseManager] getSaledHousesCountByStaffId:loginUser.Id];
    self.saledHousesCountLabel.text = [[NSString alloc] initWithFormat:@"售出房屋数: %d套", _saledHousesCount];
    Float64 _totalSalesCommission = [[HouseManager sharedHouseManager] getTotalSalesCommissionByStaffId:loginUser.Id];
    self.totalSalesCommissionLabel.text = [[NSString alloc] initWithFormat:@"总提成: %.2f万", _totalSalesCommission];
    self.salesHouseArray = [[HouseManager sharedHouseManager] getAllSalesHousesByStaffId:loginUser.Id];
    [self.salesHouseTableView reloadData];
    [self.salesCommissionTableView reloadData];
}

- (void)segmentControlValueChange {
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
            self.salesHouseTableView.hidden = NO;
            self.saledHousesCountLabel.hidden = NO;
            self.salesCommissionTableView.hidden = YES;
            self.totalSalesCommissionLabel.hidden = YES;
//            self.navigationItem.rightBarButtonItem.enabled = NO;
            break;
        case 1:
            self.salesCommissionTableView.hidden = NO;
            self.totalSalesCommissionLabel.hidden = NO;
            self.saledHousesCountLabel.hidden = YES;
            self.salesHouseTableView.hidden = YES;
//            self.navigationItem.rightBarButtonItem.enabled = YES;
            break;
    }
}

// 添加按钮的点击处理
//- (void)addButtonClickHandler {
//    CYEditExpanseViewController *editController = [[CYEditExpanseViewController alloc] init];
//    __weak typeof(self) weakSelf = self;
//    editController.editExpanseBlock = ^(ExpanseItem * _Nonnull expanse) {
//        if (expanse) {
//            [[FinanceManager sharedFinanceManager] insertExpanse:expanse];
//        }
//        [weakSelf p_initData];
//    };
//    [self.navigationController pushViewController:editController animated:YES];
//}

- (void)viewWillLayoutSubviews {
    [self.saledHousesCountLabel sizeToFit];
    self.saledHousesCountLabel.frame = CGRectMake(15, 15, CGRectGetWidth(self.view.frame) - 15 * 2, CGRectGetHeight(self.saledHousesCountLabel.frame));
    self.headerView1.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15 + CGRectGetHeight(self.saledHousesCountLabel.frame));
    
    [self.totalSalesCommissionLabel sizeToFit];
    self.totalSalesCommissionLabel.frame = CGRectMake(15, 15, CGRectGetWidth(self.view.frame) - 15 * 2, CGRectGetHeight(self.totalSalesCommissionLabel.frame));
    self.headerView2.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15 + CGRectGetHeight(self.totalSalesCommissionLabel.frame));
    
    self.salesHouseTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.salesCommissionTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.salesHouseArray)
        return self.salesHouseArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int idx = (int)indexPath.row;
    if (tableView == self.salesHouseTableView) {
        if (idx >= self.salesHouseArray.count || idx < 0)
            return nil;
        SalesHouseTableViewCell *cell = [self.salesHouseTableView dequeueReusableCellWithIdentifier:@"SalesHouseTableViewCell"];
        cell.house = ((HouseItem *)self.salesHouseArray[idx]);
        return cell;
    } else if (tableView == self.salesCommissionTableView) {
        if (idx >= self.salesHouseArray.count || idx < 0)
            return nil;
        SalesCommissionTableViewCell *cell = [self.salesCommissionTableView dequeueReusableCellWithIdentifier:@"SalesCommissionTableViewCell"];
        cell.house = ((HouseItem *)self.salesHouseArray[idx]);
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.salesHouseTableView)
        return 105;
    else if (tableView == self.salesCommissionTableView)
        return 78;
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    int idx = (int)indexPath.row;
    //    if (idx >= self.staffArray.count || idx < 0)
    //        return;
    //    if ([[UserManager sharedUserManager] deleteStaffById:((UserItem *)self.staffArray[idx]).Id] == UserManagerStatusCodeOK) {
    //        [self.staffArray removeObjectAtIndex:indexPath.row];
    //        [self.staffTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //        [self.staffTableView reloadData];
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.salesCommissionTableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    int idx = (int)indexPath.row;
//    if (self.expanseArray) {
//        if (idx >= self.expanseArray.count || idx < 0)
//            return;
//    }
//    CYEditExpanseViewController *editController = [[CYEditExpanseViewController alloc] init];
//    editController.editExpanse = ((ExpanseItem *)self.expanseArray[idx]);
//    __weak typeof(self) weakSelf = self;
//    editController.editExpanseBlock = ^(ExpanseItem * _Nonnull expanse) {
//        if (expanse) {
//            //            [[UserManager sharedUserManager] updateStaff:staff];
//        }
//        [weakSelf p_initData];
//    };
//    [self.navigationController pushViewController:editController animated:YES];
}

@end
