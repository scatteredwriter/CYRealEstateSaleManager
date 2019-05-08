//
//  CYHouseManagerController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 4/27/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYHouseManagerController.h"

// 房屋销售列表Cell声明及实现
@interface HouseTableViewCell : UITableViewCell
@property (nonatomic, strong) HouseItem *house;
@end

@interface HouseTableViewCell ()
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *huxingLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, assign) CGFloat leftMargin;
@end

@implementation HouseTableViewCell

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
    if (_house.status == HouseStatusWaitForSaled) {
        self.statusLabel.text = HOUSE_STATUS_WAIT_FOR_SALED;
        self.statusLabel.textColor = [UIColor greenColor];
    } else if (_house.status == HouseStatusOrdered) {
        self.statusLabel.text = HOUSE_STATUS_ORDERED;
        self.statusLabel.textColor = [UIColor orangeColor];
    } else if (_house.status == HouseStatusSaled) {
        self.statusLabel.text = HOUSE_STATUS_SALED;
        self.statusLabel.textColor = [UIColor redColor];
    }
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

@interface CYHouseManagerController ()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *houseTableView;
@property (nonatomic, strong) NSMutableArray *houseArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation CYHouseManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isEdit = NO;
    self.searchBar = [[UISearchBar alloc] init];
//    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeButtonClickHandler)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClickHandler)];
    
    self.houseTableView = [[UITableView alloc] init];
    [self.houseTableView registerClass:HouseTableViewCell.class forCellReuseIdentifier:@"HouseTableViewCell"];
    self.houseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.houseTableView.dataSource = self;
    self.houseTableView.delegate = self;
    [self.view addSubview:self.houseTableView];
    
    [self p_initData];
}

// 初始化数据
- (void)p_initData {
    if (self.searchArray && self.searchArray.count) {
        [self.houseTableView reloadData];
        return;
    } else {
        self.houseArray = [[HouseManager sharedHouseManager] getAllHouses];
        if (self.houseArray && self.houseArray.count) {
            [self.houseTableView reloadData];
        }
    }
}

// 删除按钮的点击处理
- (void)removeButtonClickHandler {
    self.isEdit = !self.isEdit;
    [self.houseTableView setEditing:self.isEdit animated:YES];
}

// 添加按钮的点击处理
- (void)addButtonClickHandler {
    CYEditHouseViewController *editController = [[CYEditHouseViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    editController.editHouseBlock = ^(HouseItem * _Nonnull house, CustomerItem * _Nonnull customer) {
        if (house) {
            house.orderIdCard = customer ? customer.idCard : @"";
            [[HouseManager sharedHouseManager] insertHouse:house];
        }
        if (customer) {
            [[HouseManager sharedHouseManager] insertCustomer:customer];
        }
        [weakSelf p_initData];
    };
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)viewWillLayoutSubviews {
    self.houseTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchArray)
        return self.searchArray.count;
    else if (self.houseArray)
        return self.houseArray.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchArray) {
        int idx = (int)indexPath.row;
        if (idx >= self.searchArray.count || idx < 0)
            return nil;
        HouseTableViewCell *cell = [self.houseTableView dequeueReusableCellWithIdentifier:@"HouseTableViewCell"];
        cell.house = ((HouseItem *)self.searchArray[idx]);
        return cell;
    } else {
        int idx = (int)indexPath.row;
        if (idx >= self.houseArray.count || idx < 0)
            return nil;
        HouseTableViewCell *cell = [self.houseTableView dequeueReusableCellWithIdentifier:@"HouseTableViewCell"];
        cell.house = ((HouseItem *)self.houseArray[idx]);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchArray) {
        int idx = (int)indexPath.row;
        if (idx >= self.searchArray.count || idx < 0)
            return;
        if ([[HouseManager sharedHouseManager] deleteHouseById:((HouseItem *)self.searchArray[idx]).Id] == HouseManagerStatusCodeOK) {
            [self.searchArray removeObjectAtIndex:indexPath.row];
            [self.houseTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.houseTableView reloadData];
        }
    } else {
        int idx = (int)indexPath.row;
        if (idx >= self.houseArray.count || idx < 0)
            return;
        if ([[HouseManager sharedHouseManager] deleteHouseById:((HouseItem *)self.houseArray[idx]).Id] == HouseManagerStatusCodeOK) {
            [self.houseArray removeObjectAtIndex:indexPath.row];
            [self.houseTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.houseTableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.houseTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int idx = (int)indexPath.row;
    if (self.searchArray) {
        if (idx >= self.searchArray.count || idx < 0)
            return;
    } else {
        if (idx >= self.houseArray.count || idx < 0)
            return;
    }
    CYEditHouseViewController *editController = [[CYEditHouseViewController alloc] init];
    editController.editHouse = self.searchArray ? ((HouseItem *)self.searchArray[idx]) : ((HouseItem *)self.houseArray[idx]);
    editController.editCustomer = [[HouseManager sharedHouseManager] selectCustomerByIdCard:editController.editHouse.orderIdCard];
    __weak typeof(self) weakSelf = self;
    editController.editHouseBlock = ^(HouseItem * _Nonnull house, CustomerItem * _Nonnull customer) {
        if (house) {
            house.orderIdCard = customer ? customer.idCard : @"";
            [[HouseManager sharedHouseManager] updateHouse:house];
        }
        if (customer) {
            [[HouseManager sharedHouseManager] updateCustomer:customer];
        }
        [weakSelf p_initData];
    };
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (!searchText || !searchText.length) {
        // 退出搜索模式
        self.searchArray = nil;
    } else {
        self.searchArray = [[HouseManager sharedHouseManager] searchHouseByAddress:searchText];
    }
    [self p_initData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if ([self.searchBar canResignFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    self.searchBar.showsCancelButton = NO;
}

@end
