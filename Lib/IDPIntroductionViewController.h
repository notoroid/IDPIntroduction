//
//  IDPIntroductionViewController.h
//  Introduction
//
//  Created by 能登 要 on 2014/04/23.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IDP_INTRODUCTION_LOCALIZED_NEXT_TITLE   NSLocalizedStringFromTable(@"Next", @"IntroductionLocalizable", nil)
#define IDP_INTRODUCTION_LOCALIZED_DONE_TITLE   NSLocalizedStringFromTable(@"Done", @"IntroductionLocalizable", nil)

@protocol IDPIntroductionViewControllerDelegate;

@interface IDPIntroductionViewController : UIViewController

- (id) initWithBackgroundImage:(UIImage *)backgroundImage resources:(NSArray *)resources;

@property (strong,nonatomic) UIImage* backgroundImage; // 背景画像の指定
@property (strong,nonatomic) NSArray *resources; // nibリソース名をページ分NArrayへ格納
@property (weak,nonatomic) id<IDPIntroductionViewControllerDelegate> delegate;

@property (nonatomic,strong) IBOutlet UIView *pageContentView; // for content page loading.

@end


@protocol IDPIntroductionViewControllerDelegate <NSObject>

- (void) introductionViewControllerDidDone:(IDPIntroductionViewController *)introductionViewController;

- (void) introductionViewController:(IDPIntroductionViewController *)introductionViewController updateContentView:(UIView *)contentView index:(NSUInteger)index;

- (void) introductionViewController:(IDPIntroductionViewController *)introductionViewController unuseContentView:(UIView *)contentView;

@end
