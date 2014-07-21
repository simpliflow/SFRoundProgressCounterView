//
//  ViewController.h
//  TestSFRoundProgressTimerView
//
//  Created by Thomas Winkler on 22/01/14.
//  Copyright (c) 2014 Simpliflow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRoundProgressCounterView.h"

@interface ViewController : UIViewController<SFRoundProgressCounterViewDelegate>

@property (nonatomic, strong) NSArray* intervals;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) UIColor* bgColor;
@property (nonatomic) BOOL hideFraction;

@end
