//
//  CurvesHelper.h
//  PSCurves
//
//  Created by openthread on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurvesHelper : NSObject

//传入数组包含全是CGPoint的字符串表示,传出数组包含全是double的NSNumber;
+ (NSArray *)secondDerivative:(NSArray *)pointArray;

@end
