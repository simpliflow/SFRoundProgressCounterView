//
//  CERoundProgressLayer.h
//  SFRoundProgressCounter
//
//  Initially created by Renaud Pradenc on 13/06/12.
//  Copyright (c) 2012 Céroce. All rights reserved.
//
//  Adapted by Thomas Winkler on 22/01/14.
//

#import <QuartzCore/QuartzCore.h>

@interface SFRoundProgressLayer : CALayer

@property (nonatomic, assign) float progress;

@property (nonatomic, assign) float startAngle;
@property (nonatomic, retain) UIColor *tintColor;
@property (nonatomic, retain) UIColor *trackColor;
@property (nonatomic, assign) BOOL reverse;

@end
