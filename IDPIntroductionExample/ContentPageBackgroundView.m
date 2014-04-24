//
//  ContentPageBackgroundView.m
//  Introduction
//
//  Created by 能登 要 on 2014/04/23.
//  Copyright (c) 2014年 Irimasu Densan Planning. All rights reserved.
//

#import "ContentPageBackgroundView.h"

@implementation ContentPageBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIColor* color2 = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 1];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0, 146.44)];
    [bezierPath addCurveToPoint: CGPointMake(281, 146.44) controlPoint1: CGPointMake(0, 145.44) controlPoint2: CGPointMake(281, 146.44)];
    [color2 setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
}

@end
