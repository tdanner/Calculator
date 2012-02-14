//
//  GraphController.m
//  Calculator
//
//  Created by Tim Danner on 2/13/12.
//  Copyright (c) 2012 Tim Danner. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@implementation GraphViewController

@synthesize function = _function;

- (void)setFunction:(id)function {
    _function = function;
    self.title = [CalculatorBrain descriptionOfProgram:function];
}

- (float)yForX:(float)x {
    return x;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
