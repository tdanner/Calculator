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
@synthesize graphView = _graphView;

- (void)setFunction:(id)function {
    _function = function;
    self.title = [CalculatorBrain descriptionOfProgram:function];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    self.graphView.graphDelegate = self;
    
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)];
    [self.graphView addGestureRecognizer:pinchGR];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)];
    [self.graphView addGestureRecognizer:panGR];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapGR.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapGR];
}

- (float)yForX:(float)x {
    return x;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setGraphView:nil];
    [super viewDidUnload];
}
@end
