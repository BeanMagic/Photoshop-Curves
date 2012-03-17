//
//  ViewController.h
//  PSCurves
//
//  Created by openthread on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    UIImageView *_curveView;
    
    UITextField *_point1x;
    UITextField *_point1y;
    UITextField *_point2x;
    UITextField *_point2y;
    
    NSArray *_textFieldArray;
}

@end
