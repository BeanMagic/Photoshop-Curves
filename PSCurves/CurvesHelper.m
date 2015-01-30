//
//  CurvesHelper.m
//  PSCurves
//
//  Created by openthread on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CurvesHelper.h"

@implementation CurvesHelper

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
{
	NSUInteger n = [pointArray count];
    if (n == 0)//do not need generate derivative
    {
        return nil;   
    }
    if (n == 1)//derivative is 0,return. Avoid set value to matrix[n-1] or result[n-1] crashs
    {
        NSArray *returnArray = [NSArray arrayWithObject:[NSNumber numberWithFloat:0]];
        return returnArray;
    }
	// build the tridiagonal system 
    double matrix[n][3];
    double result[n];
    matrix[0][0] = 0;
	matrix[0][1] = 1;
    matrix[0][2] = 0;
    result[0] = 0;
	for(int i=1;i<n-1;i++)
    {
        CGPoint pointI = [[pointArray objectAtIndex:i] CGPointValue];
        CGPoint pointIm1 = [[pointArray objectAtIndex:i-1] CGPointValue];
        CGPoint pointIp1 = [[pointArray objectAtIndex:i+1] CGPointValue];
		matrix[i][0]=((double)(pointI.x-pointIm1.x))/6;
		matrix[i][1]=((double)(pointIp1.x-pointIm1.x))/3;
		matrix[i][2]=((double)(pointIp1.x-pointI.x))/6;
		result[i]=((double)(pointIp1.y-pointI.y))/(pointIp1.x-pointI.x) - ((double)(pointI.y-pointIm1.y))/(pointI.x-pointIm1.x);
	}
    matrix[n-1][0] = 0;
	matrix[n-1][1] = 1;
    matrix[n-1][2] = 0;
    result[n-1] = 0;
    
	// solving pass1 (up->down)
	for(NSInteger i = 1; i < n; i++)
    {
		double k = matrix[i][0]/matrix[i-1][1];
		matrix[i][1] -= k*matrix[i-1][2];
		matrix[i][0] = 0;
		result[i] -= k*result[i-1];
	}
	// solving pass2 (down->up)
	for(NSInteger i = n - 2; i >= 0; i--)
    {
		double k = matrix[i][2]/matrix[i+1][1];
		matrix[i][1] -= k*matrix[i+1][0];
		matrix[i][2] = 0;
		result[i] -= k*result[i+1];
	}
    
	// return second derivative value for each point
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
	for(int i=0;i<n;i++)
    {
        double y2 = result[i]/matrix[i][1];
        [resultArray addObject:[NSNumber numberWithDouble:y2]];
    }
    
	return resultArray;
}

@end