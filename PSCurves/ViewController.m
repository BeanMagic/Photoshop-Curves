//
//  ViewController.m
//  PSCurves
//
//  Created by openthread on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CurvesHelper.h"

@implementation ViewController

- (void)drawWithPoints:(NSArray *)points
{
    points = [points sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        CGPoint point1 = [obj1 CGPointValue];
        CGPoint point2 = [obj2 CGPointValue];
        NSComparisonResult rst;
        if (point1.x > point2.x) rst = NSOrderedDescending;
        if (point1.x == point2.x) rst = NSOrderedSame;
        if (point1.x < point2.x) rst = NSOrderedAscending;
        return rst;
    }];
    [_curveView removeFromSuperview];
    _curveView = nil;
    _curveView = [[CurveView alloc] initWithFrame:CGRectMake(160 - 256 / 2, 20, 256, 256)];
    _curveView.backgroundColor = [UIColor whiteColor];
    NSArray *sd = [CurvesHelper secondDerivative:points];
    
    //初始化曲线前映射
    int firstX = [[points objectAtIndex:0] CGPointValue].x;
    int firstY = [[points objectAtIndex:0] CGPointValue].y;
    for (int i = 0; i < firstX; i++)
    {
        [_curveView setColorMap:firstY toIndex:i];
    }
    
    //初始化曲线映射
    for(int i = 0; i<[points count] - 1; i++)
    {
        CGPoint cur = [[points objectAtIndex:i] CGPointValue];
    	CGPoint next  = [[points objectAtIndex:i + 1] CGPointValue];
    	for(int x=cur.x;x<=next.x;x++)
        {
            double t = (double)(x-cur.x)/(next.x-cur.x);
            double a = 1-t;
            double b = t;
            double h = next.x-cur.x;
            double y= a*cur.y + b*next.y + (h*h/6)*( (a*a*a-a)*[[sd objectAtIndex:i] doubleValue]+ (b*b*b-b)*[[sd objectAtIndex:i + 1] doubleValue]);
            
            if (y < 0) y = 0;
            if (y > 255) y = 255;
            [_curveView setColorMap:y toIndex:x];
        }
    }
    
    //初始化曲线后映射
    int lastX = [[points lastObject] CGPointValue].x;
    int lastY = [[points lastObject] CGPointValue].y;
    for (int i = 255; i > lastX; i--)
    {
        [_curveView setColorMap:lastY toIndex:i];
    }
    
    [_curveView setNeedsDisplay];
    [self.view addSubview:_curveView];
}

- (void)endEditing
{
    self.view.frame = CGRectMake(0, 20, 320, 460);
    [_point1x resignFirstResponder];
    [_point1y resignFirstResponder];
    [_point2x resignFirstResponder];
    [_point2y resignFirstResponder];
    
    for (UITextField *textField in _textFieldArray)
    {
        if ([textField.text intValue] <= 0)
        {
            textField.text = @"1";
        }
        else if ([textField.text intValue] >255)
        {
            textField.text = @"255";
        }
    }
    
    int point1x = [_point1x.text intValue];
    int point1y = [_point1y.text intValue];
    int point2x = [_point2x.text intValue];
    int point2y = [_point2y.text intValue];


    if (point2x <= point1x)
    {
        point2x = point1x + 1;
        _point2x.text = [NSString stringWithFormat:@"%d",point2x];
    }
    if (point1x == 254)
    {
        point1x--;
        point2x--;
    }
    
    CGPoint point1 = CGPointMake(point1x, point1y);
    CGPoint point2 = CGPointMake(point2x, point2y);

    NSArray *points = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:(CGPointMake(0, 0))],
                       [NSValue valueWithCGPoint:point1],
                       [NSValue valueWithCGPoint:point2],
                       [NSValue valueWithCGPoint:(CGPointMake(255, 255))],
                       nil];
    [self drawWithPoints:points];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, -195, 320, 460);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [control addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:control];
    
    _curveView = [[CurveView alloc] initWithFrame:CGRectMake(160 - 256 / 2, 20, 256, 256)];
    _curveView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_curveView];
    
    _point1x = [[UITextField alloc] initWithFrame:CGRectMake(120, 296, 50, 30)];
    _point1x.backgroundColor = [UIColor whiteColor];
    _point1x.keyboardType = UIKeyboardTypeNumberPad;
    _point1x.text = @"100";
    _point1x.delegate = self;
    
    _point1y = [[UITextField alloc] initWithFrame:CGRectMake(260, 296, 50, 30)];
    _point1y.backgroundColor = [UIColor whiteColor];
    _point1y.keyboardType = UIKeyboardTypeNumberPad;
    _point1y.text = @"100";
    _point1y.delegate = self;

    _point2x = [[UITextField alloc] initWithFrame:CGRectMake(120, 336, 50, 30)];
    _point2x.backgroundColor = [UIColor whiteColor];
    _point2x.keyboardType = UIKeyboardTypeNumberPad;
    _point2x.text = @"200";
    _point2x.delegate = self;

    _point2y = [[UITextField alloc] initWithFrame:CGRectMake(260, 336, 50, 30)];
    _point2y.backgroundColor = [UIColor whiteColor];
    _point2y.keyboardType = UIKeyboardTypeNumberPad;
    _point2y.text = @"200";
    _point2y.delegate = self;
    
    _textFieldArray = [[NSArray alloc] initWithObjects:_point1x, _point1y, _point2x, _point2y, nil];

    [self.view addSubview:_point1x];
    [self.view addSubview:_point1y];
    [self.view addSubview:_point2x];
    [self.view addSubview:_point2y];
    
    UILabel *point1xLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 296, 100, 30)];
    point1xLabel.text = @"Point1 input:";
    point1xLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:point1xLabel];
    
    UILabel *point2xLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 336, 100, 30)];
    point2xLabel.text = @"Point2 input:";
    point2xLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:point2xLabel];
    
    UILabel *point1yLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 296, 60, 30)];
    point1yLabel.text = @"Output:";
    point1yLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:point1yLabel];
    
    UILabel *point2yLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 336, 60, 30)];
    point2yLabel.text = @"Output:";
    point2yLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:point2yLabel];
    
    NSArray *points = [NSArray arrayWithObjects:
                       [NSValue valueWithCGPoint:(CGPointMake(0, 0))],
                       [NSValue valueWithCGPoint:(CGPointMake(255, 255))],
                       nil];
    [self drawWithPoints:points];
}

@end
