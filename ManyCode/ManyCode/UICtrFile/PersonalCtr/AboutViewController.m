//
//  AboutViewController.m
//  ManyCode
//
//  Created by lichengfei on 14-10-23.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

#pragma mark - systemFunction

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
    self.titleLable.text = @"关于我们";
    
    UIScrollView *mainScrllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kTopImageHeight, 320, kCurrentWindowHeight)];
    mainScrllView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainScrllView];
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(105, 35, 110, 110)];
    titleImage.image = [UIImage imageNamed:@"关于我们切图.png"];
    [mainScrllView addSubview:titleImage];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(95, 160, 85, 20)];
    titleLable.text = @"魅力车库";
    titleLable.font = FONT(18);
    [mainScrllView addSubview:titleLable];
    
    UILabel *lableVersion = [[UILabel alloc] initWithFrame:CGRectMake(185, 162, 60, 20)];
    NSDictionary *appInfoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [appInfoDict objectForKey:@"CFBundleVersion"];
    [lableVersion setText:[NSString stringWithFormat:@"V%@",version]];
    lableVersion.font = FONT(15);
    [mainScrllView addSubview:lableVersion];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 210, 270, 140)];
    [contentLable setNumberOfLines:0];
    contentLable.font = FONT(15);
    contentLable.text = @"  \"魅力车库\"是一款专为开车人准备的最便捷的智能停车收费软件，它不仅可以实现周边停车场位置查询，收费标准查询，停车场导航，还可以实现在线支付停车费。是真正的智能停车收费系统。它是已移动物联网技术为基础的智能APP，让停车场系统从传统走向移动物联网时代。";
    [mainScrllView addSubview:contentLable];
    

}
@end
