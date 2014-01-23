//
//  SFRoundProgressView.m
//  SFRoundProgressCounter
//
//  Initially created by Renaud Pradenc on 13/06/12.
//  Copyright (c) 2012 Céroce. All rights reserved.
//
//  Adapted by Thomas Winkler on 22/01/14.
//
//

#import "SFRoundProgressView.h"
#import "SFRoundProgressLayer.h"

@interface SFRoundProgressView ()

@end

@implementation SFRoundProgressView

+ (Class) layerClass
{
    return [SFRoundProgressLayer class];
}

#pragma mark - init stuff

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.tintColor = [UIColor colorWithRed:0.2 green:0.45 blue:0.8 alpha:1.0];
    self.trackColor = [UIColor whiteColor];
    
    // On Retina displays, the layer must have its resolution doubled so it does not look blocky.
    self.layer.contentsScale = [UIScreen mainScreen].scale;
}

# pragma mark - progress handling

- (float) progress
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    return layer.progress;
}

- (void) setProgress:(float)progress
{
    BOOL growing = progress > self.progress;
    [self setProgress:progress animated:growing];
}

- (void) setProgress:(float)progress animated:(BOOL)animated
{
    // Coerce the value
    if(progress < 0.0f)
        progress = 0.0f;
    else if(progress > 1.0f)
        progress = 1.0f;
    
    // Apply to the layer
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    if(animated)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = 0.25;
        animation.fromValue = [NSNumber numberWithFloat:layer.progress];
        animation.toValue = [NSNumber numberWithFloat:progress];
        [layer addAnimation:animation forKey:@"progressAnimation"];
        
        layer.progress = progress;
    }
    
    else {
        layer.progress = progress;
        [layer setNeedsDisplay];
    }
}

# pragma mark - settings

- (UIColor *)tintColor
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    return layer.tintColor;
}
- (void) setTintColor:(UIColor *)tintColor
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    layer.tintColor = tintColor;
    [layer setNeedsDisplay];
}

- (UIColor *)trackColor
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    return layer.trackColor;
}

- (void) setTrackColor:(UIColor *)trackColor
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    layer.trackColor = trackColor;
    [layer setNeedsDisplay];
}

- (BOOL)reverse
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    return layer.reverse;
}

- (void) setReverse:(BOOL)reverse
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    layer.reverse = reverse;
    [layer setNeedsDisplay];
}


- (float) startAngle
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    return layer.startAngle;
}

- (void) setStartAngle:(float)startAngle
{
    SFRoundProgressLayer *layer = (SFRoundProgressLayer *)self.layer;
    layer.startAngle = startAngle;
    [layer setNeedsDisplay];
}


@end
