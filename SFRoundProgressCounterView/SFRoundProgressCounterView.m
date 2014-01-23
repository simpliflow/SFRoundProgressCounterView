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

- (void) setup
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGPoint center = CGPointMake(self.bounds.origin.x + (self.bounds.size.width/2.0), self.bounds.origin.y + (self.bounds.size.height/2.0));
    
    double diameter = self.bounds.size.width;
    if (self.bounds.size.height < self.bounds.size.width) {
        diameter = self.bounds.size.height;
    }
    
    // total progress view
    self.totalProgressView = [[SFRoundProgressView alloc] initWithFrame:self.bounds];
    self.totalProgressView.startAngle = (3.0*M_PI)/2.0;
    self.totalProgressView.tintColor = self.progressColor;
    [self.totalProgressView setProgress:1.0 animated:NO];

    [self addSubview:self.totalProgressView];
    
    // white circle view
    UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, diameter - 3.0, diameter - 3.0)];
    circleView.layer.cornerRadius = circleView.frame.size.width/2.0;
    circleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:circleView];
    [circleView setCenter:center];
    
        
    // interval progress view
    self.intervalProgressView = [[SFRoundProgressView alloc] initWithFrame:CGRectMake(0,0, diameter - 9.0, diameter - 9.0)];
    self.intervalProgressView.startAngle = (3.0*M_PI)/2.0;
    self.intervalProgressView.tintColor = self.progressColor;
    [self.intervalProgressView setProgress:1.0 animated:NO];
    [self.intervalProgressView setCenter:center];
    
    [self addSubview:self.intervalProgressView];
    
    // white circle view
    circleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, diameter - 10.0, diameter - 10.0)];
    circleView.layer.cornerRadius = circleView.frame.size.width/2.0;
    circleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:circleView];
    [circleView setCenter:center];
    
    // counter label view
    int fontSize = self.bounds.size.height/COUNTER_LABEL_SCALE_FACTOR;
    self.counterLabel = [[SFCounterLabel alloc] initWithFrame:CGRectMake(0, 0, diameter - 10.0, diameter/2.0)];
    self.counterLabel.countDirection = kCountDirectionDown;
    self.counterLabel.countdownDelegate = self;

    [self.counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize + 20]];
    [self.counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize + 15]];
    [self.counterLabel updateApperance];
    
    [self addSubview: self.counterLabel];
    [self.counterLabel setCenter:center];
    
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
        if (self.currentIntervalPosition >= [self.intervals count]) {
            self.totalProgressView.hidden = YES;
        }
        [self setNeedsDisplay];
    });
    
    [UIView animateWithDuration:0.6 animations:^{
        self.counterLabel.alpha = 0.0;
        
        if (self.delegate) {
            
            // delegate call interval did end
            if (!isFinished) {
                if ([self.delegate respondsToSelector:@selector(intervalDidEnd:WithIntervalPosition:)]) {
                    [self.delegate intervalDidEnd:self WithIntervalPosition:self.currentIntervalPosition];
                }
            }
        }

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            self.counterLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.progressStopped = NO;
            if (!isFinished) {
                [self startNextInterval];
            } else {
                
                // delegate call countdown did end
                if (self.delegate && [self.delegate respondsToSelector:@selector(countdownDidEnd:)]) {
                    [self.delegate countdownDidEnd:self];
                }
            }
        }];
        
    }];
    
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

#pragma mark - tint color for rounded progress bars and label
- (UIColor*)progressColor {
    return self.totalProgressView.tintColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    self.totalProgressView.tintColor = progressColor;
    self.intervalProgressView.tintColor = progressColor;
}

- (UIColor*)labelColor {
    return self.counterLabel.textColor;
}

- (void)setLabelColor:(UIColor *)labelColor
{
    self.counterLabel.textColor = labelColor;
}

@end
