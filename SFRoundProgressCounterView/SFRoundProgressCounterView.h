//
//  SFRoundProgressCounterView.h
//  SFRoundProgressCounter
//
//  Created by Thomas Winkler on 22/01/14.
//  Copyright (c) 2014 Simpliflow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCounterLabel.h"

#pragma mark - SFRoundProgressCounterViewDelegate

@class SFRoundProgressCounterView;

@protocol SFRoundProgressCounterViewDelegate <NSObject>

@optional

- (void)countdownDidEnd:(SFRoundProgressCounterView*)progressCounterView;
- (void)intervalDidEnd:(SFRoundProgressCounterView*)progressCounterView WithIntervalPosition:(int)position;
- (void)counter:(SFRoundProgressCounterView *)progressCounterView didReachValue:(unsigned long long)value;

@end

@interface SFRoundProgressCounterView : UIView<SFCounterLabelDelegate>

@property (assign, nonatomic) id <SFRoundProgressCounterViewDelegate> delegate;

@property (strong, nonatomic) UIColor* innerProgressColor;
@property (strong, nonatomic) UIColor* outerProgressColor;

@property (strong, nonatomic) UIColor* labelColor;
@property (strong, nonatomic) UIColor* backgroundColor;

@property (strong, nonatomic) NSNumber* outerCircleThickness;
@property (strong, nonatomic) NSNumber* innerCircleThickness;
@property (strong, nonatomic) NSNumber* circleDistance;

@property (strong, nonatomic) UIColor* outerTrackColor;
@property (strong, nonatomic) UIColor* innerTrackColor;

@property (strong, nonatomic) NSArray* intervals;

- (void)start;
- (void)stop;
- (void)resume;
- (void)reset;

@end
