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

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)drawRect:(CGRect)rect
{
/*    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];*/

    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        self.scale *= recognizer.scale; // adjust our scale
        recognizer.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
        [self setNeedsDisplay];
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [recognizer translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [recognizer setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];
    }
}

- (void)tap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.origin = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}


@end
