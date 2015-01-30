//
//  CurvesHelper.h
//  PSCurves
//
//  Created by openthread on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurvesHelper : NSObject

/*
 * @param:pointArray : Key points as NSValue:
        @[
            [NSValue valueWithCGPoint:(CGPointMake(input1, output1))],
            [NSValue valueWithCGPoint:(CGPointMake(input2, output2))],
            ...
         ]
 * @return: second derivative array, each member is an NSNumber.
 */
+ (NSArray *)secondDerivative:(NSArray *)pointArray;

@end
