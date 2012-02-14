//
//  GraphView.m
//  Calculator
//
//  Created by Tim Danner on 2/13/12.
//  Copyright (c) 2012 Tim Danner. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize graphDelegate = _graphDelegate;

- (void)setup {
    self.scale = 20.0;
    self.origin = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));    
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    [self setNeedsDisplay];
}

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
    [self setNeedsDisplay];
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (float)cartesianXFromScreenX:(float)screenX {
    return (screenX - self.origin.x) / self.scale;
}

- (float)screenYFromCartesianY:(float)cartesianY {
    return self.origin.y - cartesianY * self.scale;
}

- (void)drawRect:(CGRect)rect
{
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];

    CGContextRef context = UIGraphicsGetCurrentContext();
     
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    CGContextBeginPath(context);
    
    for (float x = self.bounds.origin.x; x < self.bounds.origin.x + self.bounds.size.width; x += 1/self.contentScaleFactor) {
        float cartesianY = [self.graphDelegate yForX:[self cartesianXFromScreenX:x]];
        float y = [self screenYFromCartesianY:cartesianY];
        
        if (x == self.bounds.origin.x) {
            CGContextMoveToPoint(context, x, y);
        } else {
            CGContextAddLineToPoint(context, x, y);
        }
    }
    
    CGContextStrokePath(context);
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        self.scale *= recognizer.scale; // adjust our scale
        recognizer.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [recognizer translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

- (void)tap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.origin = [recognizer locationInView:self];
    }
}

@end
