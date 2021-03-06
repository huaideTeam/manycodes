//
//  MainViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-21.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "MainViewController.h"
#import "UINavigationItem+Items.h"
#import "PersonalCenterViewController.h"
#import "ParkDetailViewController.h"
#import "HomeListView.h"
#import "SearchCell.h"
#import "HomeMapView.h"
#import "HomeEventDelegate.h"
#import "AppDelegate.h"
#import "ParkDetailViewController.h"
#import "StartParkViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,HomeEventDelegate>
{
    UITextField *searchText_;
    HomeMapView *mapView_;
    HomeListView *listView_;
    NSMutableArray *dataArray_;
    UITableView *mainTable_;
    NSMutableArray *textArray_;
    UIView *grayView_;
//    UIButton *leftBtn_;
//    UIView *self.leftButton;
    CLLocationCoordinate2D currentSelfPoint_;
    NSInteger currentIndex_;
    BOOL isContinue_;
}

@end

@implementation MainViewController

#pragma mark - system function

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

#pragma mark - usedefine

- (void)loadFunctionView
{
    self.titleLable.text = @"魅力车库";
    
    currentIndex_ = 1;
    
    dataArray_ = [[NSMutableArray alloc] initWithCapacity:12];

    [self.rightButton setImage:[UIImage imageNamed:@"personButton.png"] forState:UIControlStateNormal];
    self.rightButton.hidden = NO;

    self.leftButton.hidden = YES;
    
    //搜索界面
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopImageHeight, 320, 40)];
    headView.backgroundColor = [UIColor clearColor];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:headView.bounds];
    backImage.backgroundColor = COLOR(197.0, 206.0, 195.0);
    backImage.alpha = 0.8;
    [headView addSubview:backImage];
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 262, 30)];
    searchImage.image = [UIImage imageNamed:@"搜索输入框.png"];
    [headView addSubview:searchImage];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 25, 25)];
    searchButton.backgroundColor = [UIColor clearColor];
    [searchButton addTarget:self action:@selector(seachClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:searchButton];
    searchText_ = [[UITextField alloc]  initWithFrame:CGRectMake(40, 5, 200, 30)];
    searchText_.borderStyle = UITextBorderStyleNone;
    searchText_.delegate = self;
    searchText_.returnKeyType = UIReturnKeyDone;
    [searchText_ addTarget:self action:@selector(keyboardHide) forControlEvents:UIControlEventEditingDidEndOnExit];
    [headView addSubview:searchText_];
    
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 5, 37, 30)];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"listButton.png"] forState:UIControlStateNormal];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"listButtonclick.png"] forState:UIControlStateHighlighted];
    [changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.tag = 100;
    [headView addSubview:changeButton];
    
    mapView_ = [[HomeMapView alloc] initWithFrame:CGRectMake(0, kTopImageHeight, 320, kCurrentWindowHeight-kTopImageHeight-kStatueHeight)];
    mapView_.delegate = self;
    [self.view addSubview:mapView_];
    
    listView_ = [[HomeListView alloc] initWithFrame:CGRectMake(0, 40+kTopImageHeight, 320, kCurrentWindowHeight-kTopImageHeight-40- kStatueHeight)];
    listView_.hidden = YES;
    listView_.delegate = self;
    [self.view addSubview:listView_];
    
    [self.view addSubview:headView];
    
    grayView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 40+kTopImageHeight, 320, kCurrentWindowHeight-kTopImageHeight-40-kStatueHeight)];
    grayView_.backgroundColor = COLOR(224, 224, 224);
    mainTable_ = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, 310, kCurrentWindowHeight-kTopImageHeight-40-kStatueHeight)];
    mainTable_.delegate = self;
    mainTable_.dataSource = self;
    mainTable_.backgroundColor = [UIColor whiteColor];
    mainTable_.backgroundView = nil;
    [mainTable_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [grayView_ addSubview:mainTable_];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsLogin] boolValue]) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
        [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountMobile] forKey:@"mobile"];
        
        [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kPassWord] forKey:@"password"];
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"checkLogin" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self saveLoginInfo:resultDic];
            [[NetworkCenter instanceManager] setIsLogin:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotification" object:nil];
            
            NSArray *array = resultDic[@"devroadstatus"];
            if (array.count>0) {
                StartParkViewController *viewCtr = [[StartParkViewController alloc] init];
                viewCtr.parkDic = array[0];
                [self.navigationController pushViewController:viewCtr animated:YES];
            }
        } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChange:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    
}


- (void)saveLoginInfo:(NSDictionary *)dic
{
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"mobile"] forKey:kAccountMobile];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"userid"] forKey:kAccountid];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"sessionid"] forKey:kAccountSession];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"balance"] forKey:kAccountBalance];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"head_img"] forKey:kHead_img];
}


- (void)backClick:(UIButton *)button
{
    self.leftButton.hidden = YES;
    searchText_.text = @"";
    [searchText_ resignFirstResponder];
    [textArray_ removeAllObjects];
    [grayView_ removeFromSuperview];
    [dataArray_ removeAllObjects];
    [self LoadCurrentInfo:[[NetworkCenter instanceManager] currentPoint] isFirst:YES];
}

- (void)rightClick:(UIButton *)button
{
    PersonalCenterViewController *viewCtr = [[PersonalCenterViewController alloc] init];
    //    ParkDetailViewController *viewCtr = [[ParkDetailViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
}


- (void)changeClick:(UIButton *)button
{
    if ([searchText_ isFirstResponder]) {
        return;
    }
    switch (button.tag) {
        case 100:
        {
            button.tag = 101;
            
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationDuration:1.0f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            mapView_.hidden = YES;
            listView_.hidden = NO;
            [UIView commitAnimations];
           
            [button setBackgroundImage:[UIImage imageNamed:@"mapButton.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"mapButtonclick.png"] forState:UIControlStateHighlighted];
            break;
        }
        case 101:
        {
            button.tag = 100;
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationDuration:1.0f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            listView_.hidden = YES;
            mapView_.hidden = NO;
            [UIView commitAnimations];
            [button setBackgroundImage:[UIImage imageNamed:@"listButton.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"listButtonclick.png"] forState:UIControlStateHighlighted];
            break;
        }
        default:
            break;
    }
}


#pragma mark - textfield  delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [grayView_ removeFromSuperview];
    [textArray_ removeAllObjects];
    [mainTable_ reloadData];
    [self.view addSubview:grayView_];
    self.leftButton.hidden = NO;
}

- (void)textFieldChange:(NSNotification *)notify
{
    if ([searchText_.text length]>0) {
        [self refreshCityName:searchText_.text];
    }else
    {
        [textArray_ removeAllObjects];
        [mainTable_ reloadData];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - 下载城市名称

- (void)refreshCityName:(NSString *)text
{
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:text forKey:@"qryname"];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getRetrieveCarparkName" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        NSArray *array = [resultDic objectForKey:@"carparkname"];
        textArray_ = [NSMutableArray arrayWithArray:array];
        [mainTable_ reloadData];
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//下载带有检索的城市名称
- (void)LoadSearchCityList:(NSString *)cityName
{
    [dataArray_ removeAllObjects];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:cityName forKey:@"qryname"];
    [tempDic setObject:[NSNumber numberWithDouble:[[NetworkCenter instanceManager] currentPoint].latitude] forKey:@"user_lat"];
    [tempDic setObject:[NSNumber numberWithDouble:[[NetworkCenter instanceManager] currentPoint].longitude] forKey:@"user_lon"];
    [tempDic setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getRetrieveCarparkList" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
        NSArray *array = [resultDic objectForKey:@"carparklist"];
        [dataArray_ addObjectsFromArray:array];
        [grayView_ removeFromSuperview];
        [mapView_ updateAnimationView:dataArray_];
        [listView_ refreshParkingList:dataArray_];
        
        
    } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)seachClick
{
     [searchText_ resignFirstResponder];
    if ([searchText_.text length]>0) {
        [self LoadSearchCityList:searchText_.text];
    }
}
#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return textArray_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchId = @"searchID";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchId];
    if (cell == nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchId];
    }
    NSDictionary *dic = [textArray_ objectAtIndex:indexPath.row];
    cell.cityNameLable.text = [dic objectForKey:@"carparkname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *dic = [textArray_ objectAtIndex:indexPath.row];
     NSString *name = [dic objectForKey:@"carparkname"];
    [self LoadSearchCityList:name];
    [searchText_ resignFirstResponder];
}

#pragma mark - load data

//定位成功后刷新数据，或者定时刷新数据
- (void)LoadCurrentInfo:(CLLocationCoordinate2D)currentPoint isFirst:(BOOL)isRef
{
    if (isRef) {
        currentIndex_ = 1;
        isContinue_ = NO;
    }
    if (!isContinue_) { //没有新数据时下来部刷新界面
        [[Hud defaultInstance] loading:self.view withText:@"获取停车场列表请稍候。。。"];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
        [tempDic setObject:[NSNumber numberWithDouble:currentPoint.latitude] forKey:@"user_lat"];
        [tempDic setObject:[NSNumber numberWithDouble:currentPoint.longitude] forKey:@"user_lon"];
        [tempDic setObject:[NSNumber numberWithInteger:currentIndex_] forKey:@"page"];
        
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getNearCarparkList" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
            NSLog(@"1233");
            currentIndex_++;
            [[Hud defaultInstance] hide:self.view];
            NSArray *array = [resultDic objectForKey:@"carparklist"];
            [dataArray_ addObjectsFromArray:array];
            [mapView_ updateAnimationView:dataArray_];
            [listView_ refreshParkingList:dataArray_];
            
        } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error.code == 997) {
                isContinue_ = YES;
            }
            [listView_ endFreshLoading];
        }];
    }else
    {
        [listView_ endFreshLoading];
        [[Hud defaultInstance] showMessage:@"没有数据了" withHud:YES];
    }
}

//点击导航数据
- (void)currentNavView:(UIView *)ctView clickIndex:(NSInteger)index
{
    if (dataArray_.count == 0) {
        return;
    }
    NSDictionary *dic = [dataArray_ objectAtIndex:index];
    CLLocationCoordinate2D endPoint;
    endPoint.latitude = [[dic objectForKey:@"gps_lat"] doubleValue];
    endPoint.longitude = [[dic objectForKey:@"gps_lon"] doubleValue];
    AppDelegate *app = [AppDelegate appDelegate];
    [app startNavi:[[NetworkCenter instanceManager] currentPoint] end:endPoint];
}

//点击停车数据
- (void)currentParkView:(UIView *)ctView clickIndex:(NSInteger)index
{
    if (![NetworkCenter instanceManager].isOpen) {
        UIAlertView *arert = [[UIAlertView alloc] initWithTitle:@"请打开蓝牙" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [arert show];
        return;
    }
    if (dataArray_.count == 0) {
        return;
    }
     NSDictionary *currentDic = [dataArray_ objectAtIndex:index];

    if ([NetworkCenter instanceManager].isLogin) {
        [[Hud defaultInstance] loading:self.view];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
        [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
        [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
        [[NetworkCenter instanceManager] requestWebWithParaWithURL:@"getUserDevRoadStatus" Parameter:tempDic Finish:^(NSDictionary *resultDic) {
            NSNumber *logicCode = resultDic[@"statusCode"];
            [[Hud defaultInstance] hide:self.view];
            if (logicCode.intValue==216) {
                if ([resultDic[@"carparkid"] isEqualToString:currentDic[@"carparkid"]]) {
                    //判断是不是和当前的停车场
                    StartParkViewController *viewCtr = [[StartParkViewController alloc] init];
                    viewCtr.parkDic = currentDic;
                    [self.navigationController pushViewController:viewCtr animated:YES];
                }else
                {
                    NSString *msg = [NSString stringWithFormat:@"当前所在停车场：%@",resultDic[@"carparkname"]];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }else
            {
                StartParkViewController *viewCtr = [[StartParkViewController alloc] init];
                viewCtr.parkDic = currentDic;
                viewCtr.isComeIn = YES;
                [self.navigationController pushViewController:viewCtr animated:YES];
            }
        } Error:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[Hud defaultInstance] hide:self.view];
        }];
        
    }else
    {
        LoginViewController *viewCtr = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:viewCtr animated:YES];
    }
    
}

//进入停车场详情界面
- (void)pushToParkDetailView:(UIView *)ctView clickIndex:(NSInteger)index
{
    if (dataArray_.count == 0) {
        return;
    }
    
    NSDictionary *dic = [dataArray_ objectAtIndex:index];
    ParkDetailViewController *viewCtr = [[ParkDetailViewController alloc] init];
    viewCtr.parkInfoDic = dic;
    [self.navigationController pushViewController:viewCtr animated:YES];
}

#pragma mark - keyboard btn
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect viewFrame = CGRectMake(5.f, 0.f, 310, grayView_.frame.size.height);
        viewFrame.size.height -= kbSize.height;
        mainTable_.frame = viewFrame;
    }];
    
    return;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect viewFrame = CGRectMake(5.f, 0.f, 310, grayView_.frame.size.height);
        mainTable_.frame = viewFrame;
    }];
    
    return;
}

- (void)keyboardHide
{
    [searchText_ resignFirstResponder];
}
@end
