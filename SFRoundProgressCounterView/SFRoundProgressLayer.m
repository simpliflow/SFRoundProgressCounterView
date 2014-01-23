//
//  CERoundProgressLayer.m
//  SFRoundProgressCounter
//
//  Initially created by Renaud Pradenc on 13/06/12.
//  Copyright (c) 2012 Céroce. All rights reserved.
//
//  Adapted by Thomas Winkler on 22/01/14.
//

#import "SFRoundProgressLayer.h"

@implementation SFRoundProgressLayer

- (id) initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if(self)
    {
        if([layer isKindOfClass:[SFRoundProgressLayer class]])
        {
            SFRoundProgressLayer *otherLayer = layer;
        
            self.progress = otherLayer.progress;
            self.startAngle = otherLayer.startAngle;
            self.tintColor = otherLayer.tintColor;
            self.trackColor = otherLayer.trackColor;
            self.reverse = otherLayer.reverse;
        }
    }
    
    return self;
}

- (void)dealloc
{
    self.tintColor = nil;
    self.trackColor = nil;
}

+ (BOOL) needsDisplayForKey:(NSString *)key
{
    if([key isEqualToString:@"progress"])
        return YES;
    else
        return [super needsDisplayForKey:key];
}

- (void) drawInContext:(CGContextRef)context
{
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height)/2.0;
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    
    // Background circle
    CGRect circleRect = CGRectMake(center.x-radius, center.y-radius, radius*2.0, radius*2.0);
    CGContextAddEllipseInRect(context, circleRect);
    
    CGContextSetFillColorWithColor(context, self.trackColor.CGColor);
    CGContextFillPath(context);
    
    // Elapsed arc
    if (self.reverse) {
        CGContextAddArc(context, center.x, center.y, radius, self.startAngle + ((1- self.progress)*2.0*M_PI), self.startAngle, 0);
    } else {
        CGContextAddArc(context, center.x, center.y, radius, self.startAngle, self.startAngle + self.progress*2.0*M_PI, 0);
    }

    CGContextAddLineToPoint(context, center.x, center.y);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    CGContextFillPath(context);
}

@end
