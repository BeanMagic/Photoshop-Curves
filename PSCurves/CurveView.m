//
//  CurveView.m
//  PSCurves
//
//  Created by openthread on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CurveView.h"

@implementation CurveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setColorMap:(int)y toIndex:(int)x
{
    colorMap[x] = y;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};  
    CGColorRef color = CGColorCreate(colorSpace, components);  
    CGContextSetStrokeColorWithColor(context, color);
    CGContextMoveToPoint(context, 0, 255 - colorMap[0]);
    
    for (int i = 1; i < 256; i++)
    {
        CGContextAddLineToPoint(context, i, 255 - colorMap[i]);
    }
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(color);
}

@end
