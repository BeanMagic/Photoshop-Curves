//
//  ViewController.h
//  PSCurves
//
//  Created by openthread on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurveView.h"

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    CurveView *_curveView;
    
    UITextField *_point1x;
    UITextField *_point1y;
    UITextField *_point2x;
    UITextField *_point2y;
    
    NSArray *_textFieldArray;
}

@end
