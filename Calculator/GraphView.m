//
//  GraphView.m
//  Calculator
//
//  Created by Tim Danner on 2/13/12.
//  Copyright (c) 2012 Tim Danner. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

@synthesize graphDelegate = _graphDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
