//
//  CurvesHelper.m
//  PSCurves
//
//  Created by openthread on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CurvesHelper.h"

@implementation CurvesHelper

//+ (double[]) secondDerivative(Point... P)
//传入数组包含全是CGPoint的字符串表示,传出数组包含全是double的NSNumber
+ (NSArray *)secondDerivative:(NSArray *)pointArray;
{
	int n = [pointArray count];
    if (n == 0)//不需生成导数
    {
        return nil;   
    }
    if (n == 1)//二阶导为0,return.以防下面对matrix[n-1]和result[n-1]赋值报错
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
	for(int i=1;i<n-1;i++) {
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
	for(int i=1;i<n;i++)
    {
		double k = matrix[i][0]/matrix[i-1][1];
		matrix[i][1] -= k*matrix[i-1][2];
		matrix[i][0] = 0;
		result[i] -= k*result[i-1];
	}
	// solving pass2 (down->up)
	for(int i=n-2;i>=0;i--)
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