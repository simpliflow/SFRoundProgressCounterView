//
//  SFRoundProgressCounterView.m
//  SFRoundProgressCounter
//
//  Created by Thomas Winkler on 22/01/14.
//  Copyright (c) 2014 Simpliflow. All rights reserved.
//

#import "SFRoundProgressCounterView.h"
#import "SFRoundProgressView.h"
#import "SFCounterLabel.h"

@interface SFRoundProgressCounterView ()

@property (nonatomic, strong) SFRoundProgressView* totalProgressView;
@property (nonatomic, strong) SFRoundProgressView* intervalProgressView;
@property (nonatomic, strong) SFCounterLabel* counterLabel;

@property (atomic) BOOL progressStopped;
@property (assign) int currentIntervalPosition;
@property (assign) int currentIntervalValue;
@property (atomic) unsigned long long totalCounterValue;
@property (nonatomic, assign) unsigned long currentTotalIntervalValues;

@end

@implementation SFRoundProgressCounterView

#define COUNTER_LABEL_SCALE_FACTOR 8.5

#pragma mark - setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aCoder {
    if(self = [super initWithCoder:aCoder]){
        [self setup];
    }
    return self;
}

- (void) layoutSubviews
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGPoint center = CGPointMake(self.bounds.origin.x + (self.bounds.size.width/2.0), self.bounds.origin.y + (self.bounds.size.height/2.0));
    
    double diameter = self.bounds.size.width;
    if (self.bounds.size.height < self.bounds.size.width) {
        diameter = self.bounds.size.height;
    }
    
    // total progress view
    self.totalProgressView.frame = self.bounds;
    [self addSubview:self.totalProgressView];
    
    // outer circle view
    float outerProgressViewDiameter = diameter - [self.outerCircleThickness floatValue];
    self.outerCircleView.frame = CGRectMake(0,0, outerProgressViewDiameter, diameter - [self.outerCircleThickness floatValue]);
    
    self.outerCircleView.layer.cornerRadius = self.outerCircleView.frame.size.width/2.0;
    [self addSubview:self.outerCircleView];
    [self.outerCircleView setCenter:center];
    
    float intervalProgressViewDiameter = outerProgressViewDiameter - [self.circleDistance floatValue];
    // interval progress view
    self.intervalProgressView.frame = CGRectMake(0,0, intervalProgressViewDiameter, intervalProgressViewDiameter);
    [self.intervalProgressView setCenter:center];
    [self addSubview:self.intervalProgressView];
    
    // inner circle view
    float innerWhiteCircleDiameter = intervalProgressViewDiameter - [self.innerCircleThickness floatValue];
    self.innerCircleView.frame = CGRectMake(0,0, innerWhiteCircleDiameter, innerWhiteCircleDiameter);
    self.innerCircleView.layer.cornerRadius = self.innerCircleView.frame.size.width/2.0;
    [self addSubview:self.innerCircleView];
    [self.innerCircleView setCenter:center];
    
    // counter label view
    int fontSize = self.bounds.size.height/COUNTER_LABEL_SCALE_FACTOR;
    self.counterLabel.frame = CGRectMake(0, 0, innerWhiteCircleDiameter, diameter/2.0);
    
    [self.counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize + 20]];
    [self.counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize + 15]];
    
    [self.counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize - 5]];

    self.counterLabel.adjustsFontSizeToFitWidth = YES;
    [self.counterLabel updateApperance];
    
    [self addSubview: self.counterLabel];
    [self.counterLabel setCenter:center];
    
}

- (void) setup
{
    // total progress view
    self.totalProgressView = [[SFRoundProgressView alloc] init];
    self.totalProgressView.startAngle = (3.0*M_PI)/2.0;
    self.totalProgressView.tintColor = self.outerProgressColor;
    self.totalProgressView.trackColor = self.innerTrackColor;
    [self.totalProgressView setProgress:1.0 animated:NO];
    
    // white circle view
    self.outerCircleView = [[UIView alloc] init];
    self.outerCircleView.backgroundColor = self.backgroundColor;
    
    // interval progress view
    self.intervalProgressView = [[SFRoundProgressView alloc] init];
    self.intervalProgressView.startAngle = (3.0*M_PI)/2.0;
    self.intervalProgressView.tintColor = self.innerProgressColor;
    self.intervalProgressView.trackColor = self.outerTrackColor;
    [self.intervalProgressView setProgress:1.0 animated:NO];
    
    // white circle view
    self.innerCircleView = [[UIView alloc] init];
    self.innerCircleView.backgroundColor = self.backgroundColor;
    
    // counter label view
    self.counterLabel = [[SFCounterLabel alloc] init];
    self.counterLabel.hideFraction = self.hideFraction;
    self.counterLabel.countDirection = kCountDirectionDown;
    self.counterLabel.countdownDelegate = self;
}

#pragma mark - setting intervals
- (void) setIntervals:(NSArray *)intervals
{
    if (intervals && intervals.count > 0) {
        _intervals = intervals;
    }
    
    [self reset];
}

#pragma mark - Counter stuff
- (void)start {
    [self reset];
    [self startNextInterval];
}

- (void)stop {
    [self.counterLabel stop];
}

- (void)resume {
    [self.counterLabel start];
}

- (void)reset {
    
    [self.counterLabel stop];
    
    unsigned long long total = 0;
    for (NSNumber* interval in self.intervals) {
        total += [interval longLongValue];
    }
    
    self.totalCounterValue = total;
    self.currentTotalIntervalValues = 0;
    self.currentIntervalPosition = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.totalProgressView setProgress:1.0 animated:NO];
        self.totalProgressView.hidden = NO;
        if (self.intervals.count <= 1) {
            self.intervalProgressView.hidden = YES;
        } else {
            self.intervalProgressView.hidden = NO;
        }
        [self.counterLabel setStartValue:[self.intervals[0] longValue]];
    });
}

- (void) startNextInterval
{
    if (self.currentIntervalPosition > 0) {
        self.currentTotalIntervalValues += self.currentIntervalValue;
    }
    
    long intervalValue = [[self.intervals objectAtIndex:self.currentIntervalPosition] longValue];
    [self.counterLabel setStartValue:intervalValue];
    self.currentIntervalPosition++;
    self.currentIntervalValue = intervalValue;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.intervalProgressView setProgress:1.0 animated:NO];
        if (self.intervals.count > 1) {
            self.intervalProgressView.hidden = NO;
        }
    });
    
    [self.counterLabel start];
}

#pragma mark - SFCounterLabelDelegate

- (void)countdownDidEnd {
    
    BOOL isFinished = !self.intervals || self.currentIntervalPosition >= [self.intervals count];
    
    self.progressStopped = YES;
    [self.counterLabel stop];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.intervalProgressView.progress = 0.0;
        [self setNeedsDisplay];
    });
    
    if (self.delegate) {
        // delegate call interval did end
        if (!isFinished) {
            if ([self.delegate respondsToSelector:@selector(intervalDidEnd:WithIntervalPosition:)]) {
                [self.delegate intervalDidEnd:self WithIntervalPosition:self.currentIntervalPosition];
                [self startNextInterval];
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.totalProgressView.hidden = YES;
                self.intervalProgressView.hidden = YES;
                [self setNeedsDisplay];
            });
            
            if ([self.delegate respondsToSelector:@selector(countdownDidEnd:)]) {
                [self.delegate countdownDidEnd:self];
            }
        }
    }

    self.progressStopped = NO;
}

- (void)counter:(SFCounterLabel *)counter didReachValue:(unsigned long long)value
{
    if (!self.progressStopped) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.intervalProgressView.progress >= 0.0) {
                self.intervalProgressView.progress = 1.0 - (((self.currentIntervalValue - value) * 1.0)/self.currentIntervalValue);
                self.totalProgressView.progress = 1.0 - ((self.currentTotalIntervalValues * 1.0) + (self.currentIntervalValue - value))/self.totalCounterValue;
            }
        });
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(counter:didReachValue:)]) {
            [self.delegate counter:self didReachValue:value];
        }
    }
}

#pragma mark - color settings

@synthesize innerProgressColor = _innerProgressColor;
- (UIColor*)innerProgressColor {
    if (_innerProgressColor) {
        return _innerProgressColor;
    } else {
        return self.intervalProgressView.tintColor;
    }
}

- (void)setInnerProgressColor:(UIColor *)innerProgressColor
{
    _innerProgressColor = innerProgressColor;
    self.intervalProgressView.tintColor = innerProgressColor;
}

@synthesize outerProgressColor = _outerProgressColor;
- (UIColor*)outerProgressColor {
    if (_outerProgressColor) {
        return _outerProgressColor;
    } else {
        return self.totalProgressView.tintColor;
    }
}

- (void)setOuterProgressColor:(UIColor *)outerProgressColor
{
    _outerProgressColor = outerProgressColor;
    self.totalProgressView.tintColor = outerProgressColor;
}

@synthesize labelColor = _labelColor;
- (UIColor*)labelColor {
    if (_labelColor) {
        return _labelColor;
    } else {
        return self.counterLabel.textColor;
    }
}

- (void)setLabelColor:(UIColor *)labelColor
{
    _labelColor = labelColor;
    self.counterLabel.textColor = _labelColor;
}

@synthesize hideFraction = _hideFraction;

- (void)setHideFraction:(BOOL)hideFraction
{
    _hideFraction = hideFraction;
    self.counterLabel.hideFraction = _hideFraction;
}

@synthesize backgroundColor = _backgroundColor;
- (UIColor*)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = [UIColor whiteColor];
    }
    
    return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.innerCircleView.backgroundColor = backgroundColor;
    self.outerCircleView.backgroundColor = backgroundColor;
}

@synthesize innerTrackColor = _innerTrackColor;
- (UIColor *)innerTrackColor
{
    if (!_innerTrackColor) {
        _innerTrackColor = [UIColor clearColor];
    }
    
    return _innerTrackColor;
}

- (void)setInnerTrackColor:(UIColor *)innerTrackColor
{
    _innerTrackColor = innerTrackColor;
    self.intervalProgressView.trackColor = innerTrackColor;
}

@synthesize outerTrackColor = _outerTrackColor;
- (UIColor *)outerTrackColor
{
    if (!_outerTrackColor) {
        _outerTrackColor = [UIColor clearColor];
    }
    
    return _outerTrackColor;
}

- (void)setOuterTrackColor:(UIColor *)outerTrackColor
{
    _outerTrackColor = outerTrackColor;
    self.totalProgressView.trackColor = outerTrackColor;
}

#pragma mark - thickness parameter
- (NSNumber*)outerCircleThickness {
    if (!_outerCircleThickness) {
        _outerCircleThickness = [NSNumber numberWithFloat:3.f];
    }
    
    return _outerCircleThickness;
}

- (NSNumber*)innerCircleThickness {
    if (!_innerCircleThickness) {
        _innerCircleThickness = [NSNumber numberWithFloat:1.f];
    }
    
    return _innerCircleThickness;
}

- (NSNumber*)circleDistance {
    if (!_circleDistance) {
        _circleDistance = [NSNumber numberWithFloat:6.f];
    }
    
    return _circleDistance;
}


@end
