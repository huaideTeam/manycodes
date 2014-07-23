//
//  PersonalCenterViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCell.h"

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTableView_;
    NSArray *nameArray_;
}

@end

@implementation PersonalCenterViewController


#pragma mark - system Function

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadFunctionView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - use define

- (void)loadFunctionView
{
    nameArray_ = @[@"我的钱包",@"停车扣费记录",@"快捷支付",@"设置",@"版本更新"];
    mainTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, kCurrentWindowHeight - 80)];
    mainTableView_.delegate = self;
    mainTableView_.dataSource = self;
    mainTableView_.backgroundColor = [UIColor clearColor];
    mainTableView_.backgroundView = nil;
    [mainTableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:mainTableView_];

}

- (UIView *)creatHeadView:(NSDictionary *)dic
{
    if (dic) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:headView.bounds];
        backImage.image = [UIImage  imageNamed:@""];
        [headView addSubview:backImage];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,90,90, 90)];
        titleImage.image = [UIImage  imageNamed:@""];
        [headView addSubview:titleImage];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 115, 150, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"18913394805";
        [headView addSubview:nameLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 115, 150, 20)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.text = @"当前余额：34元";
        [headView addSubview:priceLabel];
        
        return headView;
    }else
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:headView.bounds];
        backImage.image = [UIImage  imageNamed:@""];
        [headView addSubview:backImage];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,90,90, 90)];
        titleImage.image = [UIImage  imageNamed:@""];
        [headView addSubview:titleImage];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 150, 100, 30)];
        [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor redColor];
        [loginButton  addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:loginButton];
        
        return headView;
    }
}

- (void)loginClick:(UIButton *)button
{
    
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *personId = @"personID";
    PersonalCell *cell= [tableView dequeueReusableCellWithIdentifier:personId];
    if (cell == nil) {
        cell = [[PersonalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personId];
    }
    cell.titleLabel.text = nameArray_[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
@end
