//
//  ViewController.m
//  Introduction
//
//  Created by 能登 要 on 2014/04/22.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "ViewController.h"
#import "IDPIntroductionViewController.h"
@import QuartzCore;

UIImage* s_maskImage;

@interface ViewController () <IDPIntroductionViewControllerDelegate>
{
    UIViewController *_introductionViewController;
    UIView *_introductionView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *backgroundImage = nil;
    if( [UIScreen mainScreen].bounds.size.height == 480.0f ){
        backgroundImage = [UIImage imageNamed:@"BackgroundScreen3_5inch.jpg"];
    }else{
        backgroundImage = [UIImage imageWithCGImage:[UIImage imageNamed:@"BackgroundScreen4inch.jpg"].CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationLeft];
    }
    
    IDPIntroductionViewController *introductionViewController = [[IDPIntroductionViewController alloc] init];
    introductionViewController.view.frame = (CGRect){CGPointZero,self.view.frame.size};
    introductionViewController.view.autoresizingMask = self.view.autoresizingMask;
    introductionViewController.delegate = self;
    
    introductionViewController.backgroundImage = [UIImage imageWithCGImage:backgroundImage.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationLeft];
    introductionViewController.pageResources = @[@"InroductionContentPage",@"InroductionContentPage",@"InroductionContentPage",@"InroductionContentPage",@"InroductionContentPage"];
    
    [self.view addSubview:introductionViewController.view];
    [self addChildViewController:introductionViewController];
    
    _introductionViewController = introductionViewController;
    _introductionView = introductionViewController.view;
    
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) introductionViewControllerDidDone:(IDPIntroductionViewController *)introductionViewController
{
    [UIView animateWithDuration:.25f delay:.0f options:0 animations:^{
        _introductionView.alpha = .0f;
    } completion:^(BOOL finished) {
        [_introductionView removeFromSuperview];
        [_introductionViewController removeFromParentViewController];
    }];
    
}

- (void) introductionViewController:(IDPIntroductionViewController *)introductionViewController updateContentView:(UIView *)contentView index:(NSUInteger)index
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(contentView.frame.size, NO, [UIScreen mainScreen].scale);
        
        //// Color Declarations
        UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
        
        //// Rounded Rectangle Drawing
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: (CGRect){CGPointZero,contentView.frame.size} cornerRadius: 4];
        [color setFill];
        [roundedRectanglePath fill];
        
        s_maskImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    });

    // マスクの設定
    CALayer *layerMask = [[CALayer alloc] init];
    layerMask.bounds = (CGRect){CGPointZero,contentView.frame.size};
    layerMask.position = CGPointMake(CGRectGetWidth(contentView.frame) * .5f ,CGRectGetHeight(contentView.frame) * .5f );
    layerMask.contents = (__bridge id)s_maskImage.CGImage;
    contentView.layer.mask = layerMask;
 
    
    NSArray* imageNames = @[@"Clock.jpg",@"fern.jpg",@"fishingvillage.jpg",@"squirrel.jpg",@"Spider.jpg"];
    
    
    // コンテンツの更新
    UIImageView *imageView = (UIImageView *)[contentView viewWithTag:100];
    imageView.image = [UIImage imageNamed:imageNames[index % imageNames.count]];
    
    // タイトルを更新
    UILabel* title = (UILabel *)[contentView viewWithTag:101];
    
    NSArray *titles = @[@"ようこそIDPIntroductionへ！",@"紹介文のカスタマイズ",@"背景画像のカスタマイズ",@"紹介ページ枚数のカスタマイズ。",@"さあ、はじめましょう！"];
    
    
    title.text = titles[index % titles.count];
    
    // 詳細を作成
    NSArray *descriptionTexts = @[@"IDPIntroduction はiPhoneアプリをユーザに紹介するために。アプリを最初に開始したときに表示される紹介機能を提供します。\n\nアプリの概要を最初に紹介することによってユーザにアプリのアピールすることができます。"
                                  ,@"紹介ページには紹介文章の他、画像を追加することも可能です。\n\n紹介ページは1)ページ毎にリソースを用意する、2)ページ表示毎に紹介文と画像をアップロードすることも可能です。"
                                  ,@"背景画像はページの移動に連動してスクロールします。またiOS7から導入された視差効果にも対応しています。\n\n背景画像には3.5インチ向けに1576x1000。4インチ向けに1576x1176程度のサイズの画像を奨励します。最小サイズは3インチ向けは680x1000px,4インチ版は680x1176pxです。"
                                  ,@"紹介ページは増減することができます。紹介ページはスワイプと次へボタンで移動できます。\n\n紹介ページの末尾に来ると完了ボタンが表示されます。ユーザが完了をタップすると紹介画面を閉じます。"
                                  ,@"ユーザにアプリケーションの特色を知ってもらう事でユーザがアプリを使いだすために。IDPIntroductionをご活用ください。"
                                  ];
    
    
    
    
    NSString * descriptionText = descriptionTexts[index % descriptionTexts.count];
    
    UILabel* description = (UILabel *)[contentView viewWithTag:102];

    CGFloat fontSize = description.font.pointSize;
    float  labelWidth  = description.bounds.size.width;
    float  labelHeight = description.bounds.size.height;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(labelWidth, labelHeight);
    
    CGRect totalRect = [descriptionText boundingRectWithSize:size
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                               context:nil];
    CGFloat adjustHeight = totalRect.size.height;
        // thanks Scramblish. http://scramblish.com/開発/iphone-開発/955/
    
    description.frame = (CGRect){description.frame.origin,CGSizeMake(description.frame.size.width, adjustHeight)};
    
    description.numberOfLines = adjustHeight / fontSize;
    description.text = descriptionText;
    
}

- (void) introductionViewController:(IDPIntroductionViewController *)introductionViewController unuseContentView:(UIView *)contentView
{
    
}


@end
