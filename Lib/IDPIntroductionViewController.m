//
//  IDPIntroductionViewController.m
//  Introduction
//
//  Created by 能登 要 on 2014/04/23.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "IDPIntroductionViewController.h"

static NSAttributedString *s_titleNext = nil;
static NSAttributedString *s_titleNextHighlighted = nil;
static NSAttributedString *s_titleDone = nil;
static NSAttributedString *s_titleDoneHighlighted = nil;

@interface IDPInroductionContentView : UIView
@property(nonatomic,assign) NSUInteger position;
@end

@implementation IDPInroductionContentView
@end

@interface IDPIntroductionViewController () <UIScrollViewDelegate>
{
    NSValue *_forcedContentOffset;
    UIScrollView *_scrollView;
    UIView *_parallaxView;
    UIPageControl *_pageControl;
    UIButton *_buttonNextAndDone;
    
    UIView *_backgroundView;
    UIImageView *_backgroundImageView;
    
    NSMutableArray *_reusableViews;
    BOOL _initializedScrollViewLayout;
    
    CGFloat _backgroundScrollRatio;
}
@property (nonatomic,readonly) NSMutableArray* reusableViews;
@end

@implementation IDPIntroductionViewController

/**
 *  reusable views accessor
 *
 *  @return NSArray instance.
 */
- (NSMutableArray*) reusableViews
{
    if( _reusableViews == nil ){
        
        CGRect frame = (CGRect){CGPointZero,[UIScreen mainScreen].bounds.size};
        
        IDPInroductionContentView* subView = [[IDPInroductionContentView alloc] initWithFrame:frame];
        IDPInroductionContentView* subView2 = [[IDPInroductionContentView alloc] initWithFrame:frame];
        IDPInroductionContentView* subView3 = [[IDPInroductionContentView alloc] initWithFrame:frame];
        IDPInroductionContentView* subView4 = [[IDPInroductionContentView alloc] initWithFrame:frame];
        IDPInroductionContentView* subView5 = [[IDPInroductionContentView alloc] initWithFrame:frame];
        IDPInroductionContentView* subView6 = [[IDPInroductionContentView alloc] initWithFrame:frame];
        
        _reusableViews = [NSMutableArray array];
        NSArray* subViews = @[subView,subView2,subView3,subView4,subView5,subView6];
        for(IDPInroductionContentView *subView in subViews) {
            subView.position = NSUIntegerMax;
            
            subView.backgroundColor = [UIColor clearColor];
            subView.opaque = NO;
            
            [subView removeFromSuperview];
            
            [_reusableViews addObject:subView];
        }
        
    }
    return _reusableViews;
}

/**
 *  initialize method
 *
 *  @param backgroundImage background image instance.
 *  @param pageResources   nib name string collection.
 *
 *  @return instance.
 */
- (id) initWithBackgroundImage:(UIImage *)backgroundImage pageResources:(NSArray *)pageResources
{
    self = [super init];
    if (self) {
        _backgroundImage = backgroundImage;
        _pageResources = pageResources;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

/**
 *  background UI construct method.
 */
- (void) constructBackground
{
    if( _backgroundImage != nil ){
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
#define IDP_INTRODUCTION_BACKGROUND_HORIZONTAL_MARGINE 10.0f
#define IDP_INTRODUCTION_BACKGROUND_VERTICAL_MARGINE 10.0f
        CGSize backgroundSize = CGSizeMake(_backgroundImage.size.width - IDP_INTRODUCTION_BACKGROUND_HORIZONTAL_MARGINE * 2.0f,_backgroundImage.size.height - IDP_INTRODUCTION_BACKGROUND_VERTICAL_MARGINE * 2.0f);
        
        _backgroundView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,backgroundSize}];
        UIView *parentView = self.view;
        [parentView addSubview:_backgroundView];
        // 要素を追加
        
        _backgroundImageView = [[UIImageView alloc] initWithImage:_backgroundImage];
        _backgroundImageView.frame = CGRectMake(-IDP_INTRODUCTION_BACKGROUND_HORIZONTAL_MARGINE, -IDP_INTRODUCTION_BACKGROUND_VERTICAL_MARGINE, _backgroundImage.size.width, _backgroundImage.size.height);
        [_backgroundView addSubview:_backgroundImageView];
            // 画像要素を追加
        [self.view sendSubviewToBack:_backgroundView];
            // 背面に移動
        
        [self registerEffectForView:_backgroundImageView depth:-16];
    }
}

/**
 *  contents construct method.
 */
- (void) constructContents
{
    if( _pageResources != nil ){
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        
        [_parallaxView removeFromSuperview];
        _parallaxView = nil;
        
        [_pageControl removeFromSuperview];
        _pageControl = nil;
        
        [_buttonNextAndDone removeFromSuperview];
        _buttonNextAndDone = nil;
        
        CGRect frame = self.view.frame;
        _scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){CGPointZero , frame.size}];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _scrollView.contentSize = CGSizeMake(screenSize.width * _pageResources.count , screenSize.height );
        _scrollView.contentOffset = CGPointZero;
        
        _parallaxView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero,screenSize}];
        _parallaxView.backgroundColor = [UIColor clearColor];
        _parallaxView.opaque = NO;
        [_scrollView addSubview:_parallaxView];
        
        [self registerEffectForView:_parallaxView depth:8];
        
#define IDP_INTRODUCTION_PAGE_CONTROL_VERTICAL_OFFSET_3_5_INCH 45.0f
#define IDP_INTRODUCTION_PAGE_CONTROL_VERTICAL_OFFSET_4_INCH 55.0f
        const CGFloat pageControlVerticalOffset = [UIScreen mainScreen].bounds.size.height == 480.0f ? IDP_INTRODUCTION_PAGE_CONTROL_VERTICAL_OFFSET_3_5_INCH : IDP_INTRODUCTION_PAGE_CONTROL_VERTICAL_OFFSET_4_INCH;

#define IDP_INTRODUCTION_PAGE_CONTROL_WIDTH 182.0f
#define IDP_INTRODUCTION_PAGE_CONTROL_HEIGHT 37.0f
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - IDP_INTRODUCTION_PAGE_CONTROL_WIDTH) * .5f /*centering*/, CGRectGetMaxY(frame) - pageControlVerticalOffset,IDP_INTRODUCTION_PAGE_CONTROL_WIDTH, IDP_INTRODUCTION_PAGE_CONTROL_HEIGHT)];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _pageControl.numberOfPages = _pageResources.count;
        [self.view addSubview:_pageControl];
        
        
#define IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_VERTICAL_OFFSET_3_5_INCH 41.0f
#define IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_VERTICAL_OFFSET_4_INCH 51.0f
        const CGFloat nexrAndDoneButtonVerticalOffset = [UIScreen mainScreen].bounds.size.height == 480.0f ? IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_VERTICAL_OFFSET_3_5_INCH :IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_VERTICAL_OFFSET_4_INCH;

#define IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_WIDTH 89.0f
#define IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_HEIGHT 30.0f
        
        _buttonNextAndDone = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetMaxX(frame) - 101,CGRectGetMaxY(frame) - nexrAndDoneButtonVerticalOffset, IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_WIDTH, IDP_INTRODUCTION_NEXT_AND_DONE_BUTTON_HEIGHT)];
        _buttonNextAndDone.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [_buttonNextAndDone addTarget:self action:@selector(firedNextAndDone:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_buttonNextAndDone];
    }
}

- (void)registerEffectForView:(UIView *)aView depth:(CGFloat)depth;
{
	UIInterpolatingMotionEffect *effectX;
	UIInterpolatingMotionEffect *effectY;
    effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	
	
	effectX.maximumRelativeValue = @(depth);
	effectX.minimumRelativeValue = @(-depth);
	effectY.maximumRelativeValue = @(depth);
	effectY.minimumRelativeValue = @(-depth);
	
	[aView addMotionEffect:effectX];
	[aView addMotionEffect:effectY];
}


/**
 *  code bese initialize.
 */
- (void) loadView
{
    [super loadView];

    // 背景画像の構築
    [self constructBackground];

    // コンテンツの構築
    [self constructContents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if( _initializedScrollViewLayout != YES ){
        _initializedScrollViewLayout = YES;
        
        if( _backgroundView == nil ){
            [self constructBackground];
        }
        
        if( _scrollView == nil ){
            [self constructContents];
        }

        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        // バックグランドの移動長さを計算
        CGFloat backgoundHorizontalLength = _backgroundView.bounds.size.width - screenSize.width;
        _backgroundScrollRatio = backgoundHorizontalLength / (screenSize.width * (_pageResources.count-1));
        
        [self updateContents];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Next And Done handler.
 *
 *  @param sender sender
 */
- (void)firedNextAndDone:(id)sender
{
    NSInteger currentPhotoIndex = [self currentIndex];
    if( currentPhotoIndex != _pageResources.count - 1){
        CGPoint contentsOffset = CGPointMake((currentPhotoIndex + 1) * [UIScreen mainScreen].bounds.size.width, _scrollView.contentOffset.y);
        
        [_scrollView setContentOffset:contentsOffset animated:YES];
        
        _forcedContentOffset = [NSValue valueWithCGPoint:contentsOffset];
        // オフセットを強制設定
        
        [self updateContents];
        // コンテンツを更新
    }else{
        [_delegate introductionViewControllerDidDone:self];
    }
}

/**
 *  current index
 *
 *  @return current index
 */
- (NSInteger) currentIndex
{
    CGPoint contentsOffset = _forcedContentOffset != nil ? [_forcedContentOffset CGPointValue] : _scrollView.contentOffset;
    NSInteger currentIndex = (NSInteger)contentsOffset.x / [UIScreen mainScreen].bounds.size.width;
    return currentIndex;
}

/**
 *  unused page method.
 *
 *  @param contentView content view
 */
- (void) unuseWithContentView:(IDPInroductionContentView *)contentView
{
    NSArray* subViews = [NSArray arrayWithArray:contentView.subviews];
    for( UIView *subView in subViews ){
        [subView removeFromSuperview];
        
        [_delegate introductionViewController:self unuseContentView:subView];
    }
}

/**
 *  update page method.
 *
 *  @param contentView content view
 *  @param index       page index
 */
- (void) updateWithContentView:(IDPInroductionContentView *)contentView index:(NSInteger)index
{
    NSString *nibName = _pageResources[index];
    
    [[UINib nibWithNibName:nibName bundle:nil] instantiateWithOwner:self options:nil];
    
    UIView *pageContentView = _pageContentView;
    [_pageContentView removeFromSuperview];
    _pageContentView = nil;
    
    pageContentView.center = CGPointMake(contentView.frame.size.width * .5f, contentView.frame.size.height * .5f);
    
    [contentView addSubview:pageContentView];
    // コンテンツを追加
    
    [_delegate introductionViewController:self updateContentView:pageContentView index:(NSUInteger)index];
}

// update page control and button title.
- (void) updatePageControl
{
    NSInteger currentPhotoIndex = [self currentIndex];
    if( _pageControl.currentPage != currentPhotoIndex ){
        _pageControl.currentPage = currentPhotoIndex;
    }
    
    if( currentPhotoIndex != _pageResources.count -1 ){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_titleNext = [[NSAttributedString alloc] initWithString:IDP_INTRODUCTION_LOCALIZED_NEXT_TITLE
                                                        attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor]
                                                        ,NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f]
                                                        }];
            s_titleNextHighlighted = [[NSAttributedString alloc] initWithString:IDP_INTRODUCTION_LOCALIZED_NEXT_TITLE
                                                        attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor colorWithHue:.0f saturation:.0f brightness:.87f alpha:1.0f]
                                                        ,NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f]
                                                        }];
        });
        
        
        [_buttonNextAndDone setAttributedTitle:s_titleNext forState:UIControlStateNormal];
        [_buttonNextAndDone setAttributedTitle:s_titleNextHighlighted forState:UIControlStateHighlighted];
    }else{
        s_titleDone = [[NSAttributedString alloc] initWithString:IDP_INTRODUCTION_LOCALIZED_DONE_TITLE
                                                        attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor]
                                                        ,NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f]
                                                        }];
        s_titleDoneHighlighted = [[NSAttributedString alloc] initWithString:IDP_INTRODUCTION_LOCALIZED_DONE_TITLE
                                                        attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor colorWithHue:.0f saturation:.0f brightness:.87f alpha:1.0f]
                                                        ,NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f]
                                                        }];
        [_buttonNextAndDone setAttributedTitle:s_titleDone forState:UIControlStateNormal];
        [_buttonNextAndDone setAttributedTitle:s_titleDoneHighlighted forState:UIControlStateHighlighted];
    }
}

/**
 *  content update method.
 */
- (void) updateContents
{
    [self updatePageControl];
    // ページ情報を更新
    
    NSInteger currentPhotoIndex = [self currentIndex];
    
    NSInteger beginIndex = currentPhotoIndex -2;
    beginIndex = beginIndex >= 0 ? beginIndex : 0;
    
    NSRange range = NSMakeRange(beginIndex,5);
    // 範囲を設定
    range = (range.length + range.location) <= _pageResources.count ? range : NSMakeRange(beginIndex,_pageResources.count - range.location);
    
    // 要素回収
    NSMutableArray* sweepViews = [NSMutableArray array];
    for( id view in _scrollView.subviews ){
        if( [view isKindOfClass:[IDPInroductionContentView class]] ){
            IDPInroductionContentView* contentView = view;
            
            BOOL bFind = NO;
            for (NSUInteger position = range.location;position != (range.location + range.length) ; position ++ ) {
                if( contentView.position == position ){
                    bFind = YES;
                    break;
                }
            }
            
            if( bFind != YES )
                [sweepViews addObject:view];
        }
    }
    
    // Resuable へ戻す
    for( IDPInroductionContentView* subView in sweepViews ){
        subView.position = NSUIntegerMax;
        
        [self unuseWithContentView:subView];
        // 再利用のため初期化
        
        [subView removeFromSuperview];
        [self.reusableViews addObject:subView];
    }
    
    // 存在していない要素を追加する
    for (NSUInteger position = range.location;position != (range.location + range.length) ; position ++ ) {
        BOOL bFind = NO;
        for( id view in _scrollView.subviews ){
            if( [view isKindOfClass:[IDPInroductionContentView class]] ){
                IDPInroductionContentView* subView = view;
                if( subView.position == position ){
                    bFind = YES;
                    break;
                }
            }
        }
        
        // 要素を追加
        if( bFind != YES ){
            IDPInroductionContentView* subView = [self.reusableViews lastObject];
            [self.reusableViews removeLastObject];
            
            subView.position = position;
            
            CGRect bounds = _scrollView.bounds;
            CGRect frame = CGRectMake(position * [UIScreen mainScreen].bounds.size.width, .0f, bounds.size.width , bounds.size.height);
            subView.frame = frame;
            
            [self updateWithContentView:subView index:position];
            
            [_parallaxView addSubview:subView];
            
        }
    }
}

#pragma mark -- UIScrollViewDelegate --

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    _forcedContentOffset = nil;
    
    // 画像の更新
    [self updateContents];
}

// スクロール管理の初期化
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView ) {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    if(scrollView == _scrollView ) {
        CGPoint origin = [scrollView contentOffset];
        [scrollView setContentOffset:CGPointMake(origin.x, 0.0)];
        
        
        // 背景を移動
        CGPoint backgroundOrigin = CGPointMake(-origin.x * _backgroundScrollRatio, _backgroundView.frame.origin.y);
        
        const CGFloat backgroundmaxOrigin = 7.5f;
        const CGFloat backgroundMinimumOrigin = -(7.5f + CGRectGetWidth(_backgroundView.frame) - [UIScreen mainScreen].bounds.size.width);
        
        if( backgroundOrigin.x > backgroundmaxOrigin ){
            backgroundOrigin.x = backgroundmaxOrigin;
        }else if( backgroundOrigin.x <= backgroundMinimumOrigin){
            backgroundOrigin.x = backgroundMinimumOrigin;
        }
        
        _backgroundView.frame = (CGRect){ backgroundOrigin ,_backgroundView.frame.size};
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    // メインスクロールビューの場合
    if (!decelerate) {
        _forcedContentOffset = nil;
        
        // 画像の更新
        [self updateContents];
    }
}

@end