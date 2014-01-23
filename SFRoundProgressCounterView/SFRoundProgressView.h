//
//  SFRoundProgressView.h
//  SFRoundProgressCounter
//
//  Initially created by Renaud Pradenc on 13/06/12.
//  Copyright (c) 2012 Céroce. All rights reserved.
//
//  Adapted by Thomas Winkler on 22/01/14.
//
//

#import <UIKit/UIKit.h>

@interface SFRoundProgressView : UIView

// setting progress (0..1)
@property (nonatomic, assign) float progress;

- (void) setProgress:(float)progress animated:(BOOL)animated;

// setting start angle of progress view (0..2π)
@property (nonatomic, assign) float startAngle;

@property (nonatomic, retain) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *trackColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) BOOL reverse;
@property (nonatomic, assign) BOOL showCounterLabel;

@end
