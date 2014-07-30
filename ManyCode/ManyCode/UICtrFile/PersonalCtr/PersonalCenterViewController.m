//
//  PersonalCenterViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCell.h"
#import "LoginViewController.h"
#import "SettingMainViewController.h"
#import "ConsumptionHistoryViewController.h"
#import "PayMoneyViewController.h"
#import "Common.h"
#import "MyPurseViewController.h"
#import "UINavigationItem+Items.h"
#import "BlockUI.h"
#import "JSONKit.h"
#import "CustomButon.h"
#import "UIImageView+WebCache.h"

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITableView *mainTableView_;
    NSArray *nameArray_;
    CustomButon *photoBtn_;
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
    if (IOS7) {
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.view.backgroundColor = COLOR(220, 220, 220);
    self.title = @"个人中心";
    
    //返回按钮
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0.f, 50, 28.f);
    [btnHome setBackgroundColor:[UIColor clearColor]];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"返回按钮常态.png"] forState:UIControlStateNormal];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"返回按钮效果.png"] forState:UIControlStateHighlighted];
    [btnHome addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnHome setTitle:@"返回" forState:UIControlStateNormal];
    btnHome.titleLabel.font = FONT(12);
    if (IOS7) {
        [self.navigationItem setLeftBarButtonItemInIOS7:[[UIBarButtonItem alloc] initWithCustomView:btnHome]];
    }
    else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
    }
    
    nameArray_ = @[@"我的钱包",@"停车扣费记录",@"快捷支付",@"设置",@"版本更新"];
    mainTableView_ = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kCurrentWindowHeight- kTopImageHeight- kStatueHeight)];
    mainTableView_.delegate = self;
    mainTableView_.dataSource = self;
    mainTableView_.backgroundColor = [UIColor clearColor];
    mainTableView_.backgroundView = nil;
    [mainTableView_ setTableHeaderView:[self creatHeadView:[NetworkCenter instanceManager].isLogin]];
    [mainTableView_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:mainTableView_];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut:) name:@"loginOutNotify" object:nil];

}

#pragma mark - 返回按钮
- (void)backClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma makr - 自定义view
- (UIView *)creatHeadView:(BOOL )isLogin
{
    if (isLogin) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
        backImage.image = [UIImage  imageNamed:@"头像背景.png"];
        [headView addSubview:backImage];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,75,90, 90)];
        titleImage.image = [UIImage  imageNamed:@"示意头像 描边.png"];
        titleImage.userInteractionEnabled = YES;
        [headView addSubview:titleImage];
        
        photoBtn_ = [[CustomButon alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        photoBtn_.backgroundColor = [UIColor clearColor];
//        [photoBtn_ setBackgroundImage:[UIImage imageNamed:@"示意头像 图片.png"] forState:UIControlStateNormal];
         [photoBtn_.titleImageView setImageWithURL:HEADIMG placeholderImage:[UIImage imageNamed:@"示意头像 图片.png"]];
        [photoBtn_ addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [titleImage addSubview:photoBtn_];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 100, 150, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = FONT(18);
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = ACCOUNTNAME;
        [headView addSubview:nameLabel];
        
        UIButton  *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, 125, 150, 20)];
        priceBtn.backgroundColor = [UIColor clearColor];
        [priceBtn setTitle:BALANCE forState:UIControlStateNormal];
        priceBtn.titleLabel.font = FONT(18);
        [priceBtn addTarget:self action:@selector(chargeMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
        priceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [headView addSubview:priceBtn];
        
        return headView;
    }else
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
        backImage.image = [UIImage  imageNamed:@"头像背景.png"];
        [headView addSubview:backImage];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,75,90, 90)];
        titleImage.image = [UIImage  imageNamed:@"示意头像 描边.png"];
        titleImage.userInteractionEnabled = YES;
        [headView addSubview:titleImage];
        
        photoBtn_ = [[CustomButon alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        photoBtn_.backgroundColor = [UIColor clearColor];
        [photoBtn_.titleImageView setImageWithURL:HEADIMG placeholderImage:[UIImage imageNamed:@"示意头像 图片.png"]];
        [photoBtn_ addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [titleImage addSubview:photoBtn_];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(130, 135, 100, 30)];
        loginButton.backgroundColor = [UIColor clearColor];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"立即登录按钮常态.png"] forState:UIControlStateNormal];
         [loginButton setBackgroundImage:[UIImage imageNamed:@"立即登录按钮效果.png"] forState:UIControlStateNormal];
        [loginButton  addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:loginButton];
        
        return headView;
    }
}

- (void)loginClick:(UIButton *)button
{
    LoginViewController *viewCtr = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
    
}

#pragma mark - 拍照

- (void)takePhoto:(UIButton *)button
{
    if (![NetworkCenter instanceManager].isLogin) {
        LoginViewController *viewCtr = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:viewCtr animated:YES];
    }else
    {
        UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"我的相册", nil];
        [sexSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
            imgPicker.delegate = self;
            if (buttonIndex == 0) {
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            else if (buttonIndex == 1){
                imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }else
            {
                return ;
            }
            imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imgPicker.allowsEditing = NO;
            [self presentViewController:imgPicker animated:YES completion:nil];
            
        }];

    }
}

#pragma mark - image delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originImage;
    originImage = info[@"UIImagePickerControllerOriginalImage"];
    UIImage *avatarImage;
    NSData *imageData;
    if (originImage.size.width/4>320) {
        avatarImage = [Common  scaleToSize:originImage size:CGSizeMake(originImage.size.width/2, originImage.size.height/2)];
        imageData = UIImageJPEGRepresentation(avatarImage, 0.1);
    }else{
        avatarImage = originImage;
        imageData = UIImageJPEGRepresentation(originImage, 0.1);
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithCapacity:12];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountid] forKey:@"userid"];
    [tempDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:kAccountSession] forKey:@"sessionid"];
    NSMutableArray *picArray = [[NSMutableArray alloc] initWithCapacity:12];
    [picArray addObject:imageData];
    
//    [tempDic setObject:imageData forKey:@"headimage"];
//    [self postPersonInfo:tempDic pic:picArray];
    
     [self saveImage:originImage WithName:@"salesImageMid.jpg"];

    [self postPic:tempDic];
}

- (void)postPic:(NSDictionary *)parameters
{
    [[Hud defaultInstance] loading:self.view withText:@"上传图片中。。。"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *path = [self documentFolderPath];
    NSURL *filePath = [NSURL fileURLWithPath:path];
    
    [manager POST:[NSString stringWithFormat:@"%@userHeadImage",EPHttpApiBaseURL] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:filePath name:@"headimage" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        [[Hud defaultInstance] showMessage:@"图片更新成功" withHud:YES];
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSInteger status = [[dic objectForKey:@"statusCode"] integerValue];
        if (status == 200) {
              [photoBtn_.titleImageView setImageWithURL:[dic objectForKey:@"head_img"] placeholderImage:[UIImage imageNamed:@"示意头像 图片.png"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - 保存图片到document

-(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
}

- (NSString *)documentFolderPath
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"salesImageMid.jpg"];
    return fullPathToFile;
    
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
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //@"我的钱包",@"停车扣费记录",@"快捷支付",@"设置",@"版本更新"
    switch (indexPath.row) {
        case 0:     //
        {
            if ([NetworkCenter instanceManager].isLogin) {
                MyPurseViewController *viewCtr = [[MyPurseViewController alloc] init];
                [self.navigationController pushViewController:viewCtr animated:YES];
            }else
            {
                [[Hud defaultInstance] showMessage:@"请登录"];
            }
        }
            break;
        case 1:
        {
            if ([NetworkCenter instanceManager].isLogin) {
                ConsumptionHistoryViewController *viewController = [[ConsumptionHistoryViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                [[Hud defaultInstance] showMessage:@"请登录"];
            }
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            SettingMainViewController *viewController = [[SettingMainViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:
        {
            [Common checkUpdateVersion:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - notify

- (void)loginSuccess:(NSNotification *)notify
{
    if ([[notify name] isEqualToString:@"loginNotification"]) {
        [mainTableView_ setTableHeaderView:[self creatHeadView:YES]];
    }
}

- (void)loginOut:(NSNotification *)notify
{
    if ([[notify name] isEqualToString:@"loginOutNotify"]) {
        [mainTableView_ setTableHeaderView:[self creatHeadView:NO]];
    }
}

- (void)chargeMoneyClick:(UIButton *)button
{
    PayMoneyViewController *viewCtr = [[PayMoneyViewController alloc] init];
    [self.navigationController pushViewController:viewCtr animated:YES];
}

@end
