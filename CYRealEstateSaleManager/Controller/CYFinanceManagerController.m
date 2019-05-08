//
//  CYFinanceManagerController.m
//  CYRealEstateSaleManager
//
//  Created by rod on 5/6/19.
//  Copyright © 2019 ChenYing. All rights reserved.
//

#import "CYFinanceManagerController.h"

// 收入列表Cell声明及实现
@interface FinanceIncomeTableViewCell : UITableViewCell
@property (nonatomic, strong) IncomeItem *income;
@end

@interface FinanceIncomeTableViewCell ()
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *houseAddressLabel;
@property (nonatomic, strong) UILabel *customerNameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, assign) CGFloat leftMargin;
@end

@implementation FinanceIncomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftMargin = 50;
        
        self.amountLabel = [[UILabel alloc] init];
        self.amountLabel.textColor = [UIColor greenColor];
        self.amountLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.amountLabel];
        
        self.houseAddressLabel = [[UILabel alloc] init];
        self.houseAddressLabel.font = [UIFont systemFontOfSize:14];
        self.houseAddressLabel.textColor = [UIColor grayColor];
        [self addSubview:self.houseAddressLabel];
        
        self.customerNameLabel = [[UILabel alloc] init];
        self.customerNameLabel.font = [UIFont systemFontOfSize:14];
        self.customerNameLabel.textColor = [UIColor grayColor];
        [self addSubview:self.customerNameLabel];
        
        self.typeLabel = [[UILabel alloc] init];
        self.typeLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.typeLabel];
        
        self.separatorView = [[UIView alloc] init];
        self.separatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.separatorView];
    }
    return self;
}

- (void)setIncome:(IncomeItem *)income {
    if (!income)
        return;
    _income = income;
    self.amountLabel.text = [NSString stringWithFormat:@"+%.2f万", _income.amount];
    if (_income.type == IncomeTypeOrdered) {
        self.typeLabel.text = Income_Type_Ordered;
    } else if (_income.type == IncomeTypeSaled) {
        self.typeLabel.text = Income_Type_Saled;
    }
    self.houseAddressLabel.text = [NSString stringWithFormat:@"房屋地址: %@", _income.houseAddress];
    self.customerNameLabel.text = [NSString stringWithFormat:@"订购客户: %@", _income.customerName];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.amountLabel sizeToFit];
    self.amountLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 15 - CGRectGetWidth(self.amountLabel.frame), 15, CGRectGetWidth(self.amountLabel.frame), CGRectGetHeight(self.amountLabel.frame));
    
    [self.typeLabel sizeToFit];
    self.typeLabel.frame = CGRectMake(self.leftMargin, 15, CGRectGetWidth(self.typeLabel.frame), CGRectGetHeight(self.typeLabel.frame));
    
    [self.houseAddressLabel sizeToFit];
    self.houseAddressLabel.frame = CGRectMake(CGRectGetMinX(self.typeLabel.frame), CGRectGetMaxY(self.typeLabel.frame) + 10, CGRectGetWidth(self.houseAddressLabel.frame), CGRectGetHeight(self.houseAddressLabel.frame));
    
    [self.customerNameLabel sizeToFit];
    self.customerNameLabel.frame = CGRectMake(CGRectGetMinX(self.typeLabel.frame), CGRectGetMaxY(self.houseAddressLabel.frame) + 10, CGRectGetWidth(self.customerNameLabel.frame), CGRectGetHeight(self.customerNameLabel.frame));
    
    self.separatorView.frame = CGRectMake(CGRectGetMinX(self.typeLabel.frame), CGRectGetMaxY(self.customerNameLabel.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMinX(self.typeLabel.frame), 0.5);
}

@end

// 支出列表Cell声明及实现
@interface FinanceExpanseTableViewCell : UITableViewCell
@property (nonatomic, strong) ExpanseItem *expanse;
@end

@interface FinanceExpanseTableViewCell ()
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *staffIdLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation FinanceExpanseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftMargin = 50;
        
        self.amountLabel = [[UILabel alloc] init];
        self.amountLabel.textColor = [UIColor redColor];
        self.amountLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.amountLabel];
        
        self.staffIdLabel = [[UILabel alloc] init];
        self.staffIdLabel.font = [UIFont systemFontOfSize:14];
        self.staffIdLabel.textColor = [UIColor grayColor];
        [self addSubview:self.staffIdLabel];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        self.dateLabel.textColor = [UIColor grayColor];
        [self addSubview:self.dateLabel];
        
        self.typeLabel = [[UILabel alloc] init];
        self.typeLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:self.typeLabel];
        
        self.separatorView = [[UIView alloc] init];
        self.separatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.separatorView];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

- (void)setExpanse:(ExpanseItem *)expanse {
    if (!expanse)
        return;
    _expanse = expanse;
    self.amountLabel.text = [NSString stringWithFormat:@"-%.2f万", _expanse.amount];
    if (_expanse.type == ExpanseTypeStaffSalary) {
        self.typeLabel.text = Expanse_Type_StaffSalary;
    } else if (_expanse.type == ExpanseTypeOfficeSupply) {
        self.typeLabel.text = Expanse_Type_OfficeSupply;
    }
    if (_expanse.type == ExpanseTypeStaffSalary) {
        self.staffIdLabel.text = [NSString stringWithFormat:@"目标员工工号: %lld", _expanse.targetStaffId];
    } else if (_expanse.type == ExpanseTypeOfficeSupply) {
        self.staffIdLabel.text = [NSString stringWithFormat:@"创建员工工号: %lld", _expanse.staffId];
    }
    self.dateLabel.text = [NSString stringWithFormat:@"创建日期: %@", [self.dateFormatter stringFromDate:_expanse.date]];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.typeLabel sizeToFit];
    self.typeLabel.frame = CGRectMake(self.leftMargin, 15, CGRectGetWidth(self.typeLabel.frame), CGRectGetHeight(self.typeLabel.frame));
    
    [self.amountLabel sizeToFit];
    self.amountLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 15 - CGRectGetWidth(self.amountLabel.frame), 15, CGRectGetWidth(self.amountLabel.frame), CGRectGetHeight(self.amountLabel.frame));
    
    [self.staffIdLabel sizeToFit];
    self.staffIdLabel.frame = CGRectMake(CGRectGetMinX(self.typeLabel.frame), CGRectGetMaxY(self.typeLabel.frame) + 10, CGRectGetWidth(self.staffIdLabel.frame), CGRectGetHeight(self.staffIdLabel.frame));
    
    [self.dateLabel sizeToFit];
    self.dateLabel.frame = CGRectMake(CGRectGetMinX(self.typeLabel.frame), CGRectGetMaxY(self.staffIdLabel.frame) + 10, CGRectGetWidth(self.dateLabel.frame), CGRectGetHeight(self.dateLabel.frame));
    
    self.separatorView.frame = CGRectMake(CGRectGetMinX(self.typeLabel.frame), CGRectGetMaxY(self.dateLabel.frame) + 15, CGRectGetWidth(self.frame) - CGRectGetMinX(self.typeLabel.frame), 0.5);
}

@end

@interface CYFinanceManagerController ()
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UILabel *totalIncomeLabel;
@property (nonatomic, strong) UILabel *totalExpanseLabel;
@property (nonatomic, strong) UIView *headerView1;
@property (nonatomic, strong) UIView *headerView2;
@property (nonatomic, strong) UITableView *incomeTableView;
@property (nonatomic, strong) UITableView *expanseTableView;
@property (nonatomic, strong) NSMutableArray *incomeArray;
@property (nonatomic, strong) NSMutableArray *expanseArray;
@end

@implementation CYFinanceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClickHandler)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"收入明细", @"支出明细"]];
    [self.segmentControl addTarget:self action:@selector(segmentControlValueChange) forControlEvents:UIControlEventValueChanged];
    self.segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentControl;
    
    self.incomeTableView = [[UITableView alloc] init];
    self.incomeTableView.allowsSelection = NO;
    [self.incomeTableView registerClass:FinanceIncomeTableViewCell.class forCellReuseIdentifier:@"FinanceIncomeTableViewCell"];
    self.incomeTableView.delegate = self;
    self.incomeTableView.dataSource = self;
    self.incomeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.incomeTableView];
    
    self.expanseTableView = [[UITableView alloc] init];
    self.expanseTableView.allowsSelection = NO;
    self.expanseTableView.hidden = YES;
    [self.expanseTableView registerClass:FinanceExpanseTableViewCell.class forCellReuseIdentifier:@"FinanceExpanseTableViewCell"];
    self.expanseTableView.delegate = self;
    self.expanseTableView.dataSource = self;
    self.expanseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.expanseTableView];
    
    self.totalIncomeLabel = [[UILabel alloc] init];
    self.totalIncomeLabel.font = [UIFont systemFontOfSize:20];
    self.headerView1 = [[UIView alloc] init];
    [self.headerView1 addSubview:self.totalIncomeLabel];
    self.incomeTableView.tableHeaderView = self.headerView1;
    
    self.totalExpanseLabel = [[UILabel alloc] init];
    self.totalExpanseLabel.hidden = YES;
    self.totalExpanseLabel.font = [UIFont systemFontOfSize:20];
    self.headerView2 = [[UIView alloc] init];
    [self.headerView2 addSubview:self.totalExpanseLabel];
    self.expanseTableView.tableHeaderView = self.headerView2;
    
    [self p_initData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self p_initData];
}

// 初始化数据
- (void)p_initData {
    Float64 _totalIncomes = [[FinanceManager sharedFinanceManager] getTotalIncomes];
    self.totalIncomeLabel.text = [[NSString alloc] initWithFormat:@"总收入: %.2f万", _totalIncomes];
    Float64 _totalExpanses = [[FinanceManager sharedFinanceManager] getTotalExpanses];
    self.totalExpanseLabel.text = [[NSString alloc] initWithFormat:@"总支出: %.2f万", _totalExpanses];
    self.incomeArray = [[FinanceManager sharedFinanceManager] getAllIncomes];
    if (self.incomeArray && self.incomeArray.count) {
        [self.incomeTableView reloadData];
    }
    self.expanseArray = [[FinanceManager sharedFinanceManager] getAllExpanses];
    if (self.expanseArray && self.expanseArray.count) {
        [self.expanseTableView reloadData];
    }
}

- (void)segmentControlValueChange {
    switch (self.segmentControl.selectedSegmentIndex)
    {
        case 0:
            self.incomeTableView.hidden = NO;
            self.totalIncomeLabel.hidden = NO;
            self.expanseTableView.hidden = YES;
            self.totalExpanseLabel.hidden = YES;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            break;
        case 1:
            self.expanseTableView.hidden = NO;
            self.totalExpanseLabel.hidden = NO;
            self.totalIncomeLabel.hidden = YES;
            self.incomeTableView.hidden = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            break;
    }
}

// 添加按钮的点击处理
- (void)addButtonClickHandler {
    CYEditExpanseViewController *editController = [[CYEditExpanseViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    editController.editExpanseBlock = ^(ExpanseItem * _Nonnull expanse) {
        if (expanse) {
            [[FinanceManager sharedFinanceManager] insertExpanse:expanse];
        }
        [weakSelf p_initData];
    };
    [self.navigationController pushViewController:editController animated:YES];
}

- (void)viewWillLayoutSubviews {
    [self.totalIncomeLabel sizeToFit];
    self.totalIncomeLabel.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.totalIncomeLabel.frame)) / 2, 15, CGRectGetWidth(self.totalIncomeLabel.frame), CGRectGetHeight(self.totalIncomeLabel.frame));
    self.headerView1.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15 + CGRectGetHeight(self.totalIncomeLabel.frame));
    
    [self.totalExpanseLabel sizeToFit];
    self.totalExpanseLabel.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.totalExpanseLabel.frame)) / 2, 15, CGRectGetWidth(self.totalExpanseLabel.frame), CGRectGetHeight(self.totalExpanseLabel.frame));
    self.headerView2.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15 + CGRectGetHeight(self.totalExpanseLabel.frame));
    
    self.incomeTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.expanseTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.incomeTableView && self.incomeArray)
        return self.incomeArray.count;
    else if (tableView == self.expanseTableView && self.expanseArray)
        return self.expanseArray.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int idx = (int)indexPath.row;
    if (tableView == self.incomeTableView) {
        if (idx >= self.incomeArray.count || idx < 0)
            return nil;
        FinanceIncomeTableViewCell *cell = [self.incomeTableView dequeueReusableCellWithIdentifier:@"FinanceIncomeTableViewCell"];
        cell.income = ((IncomeItem *)self.incomeArray[idx]);
        return cell;
    } else if (tableView == self.expanseTableView) {
        if (idx >= self.expanseArray.count || idx < 0)
            return nil;
        FinanceExpanseTableViewCell *cell = [self.expanseTableView dequeueReusableCellWithIdentifier:@"FinanceExpanseTableViewCell"];
        cell.expanse = ((ExpanseItem *)self.expanseArray[idx]);
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
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
    [self.expanseTableView deselectRowAtIndexPath:indexPath animated:YES];

    int idx = (int)indexPath.row;
    if (self.expanseArray) {
        if (idx >= self.expanseArray.count || idx < 0)
            return;
    }
    CYEditExpanseViewController *editController = [[CYEditExpanseViewController alloc] init];
    editController.editExpanse = ((ExpanseItem *)self.expanseArray[idx]);
    __weak typeof(self) weakSelf = self;
    editController.editExpanseBlock = ^(ExpanseItem * _Nonnull expanse) {
        if (expanse) {
//            [[UserManager sharedUserManager] updateStaff:staff];
        }
        [weakSelf p_initData];
    };
    [self.navigationController pushViewController:editController animated:YES];
}

@end
