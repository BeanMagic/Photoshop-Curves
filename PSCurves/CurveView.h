//
//  CurveView.h
//  PSCurves
//
//  Created by openthread on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurveView : UIView
{
    int colorMap[256];
}

- (void)setColorMap:(int)y toIndex:(int)x;

@end
