//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Tim Danner on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)calculate {
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    id result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    if ([result isKindOfClass:[NSNumber class]])
        self.display.text = [NSString stringWithFormat:@"%g", [result doubleValue]];
    else
        self.display.text = [result description];

    NSSet *variablesUsed = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSString *varDesc = @"";
    for (NSString *var in variablesUsed) {
        varDesc = [varDesc stringByAppendingFormat:@"%@ = %g  ", var, [[self.testVariableValues objectForKey:var] doubleValue]];
    }
}

- (IBAction)backspacePressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
        if (self.display.text.length == 0 || [self.display.text isEqualToString:@"-"]) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if (!contains(self.display.text, @".")) {
            self.display.text = [self.display.text stringByAppendingString:@"."];
        }
    } else {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }        
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self calculate];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    [self.brain performOperation:[sender currentTitle]];
    [self calculate];
}

- (IBAction)clearPressed {
    [self.brain clear];
    [self calculate];
}

- (IBAction)plusMinusPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([self.display.text characterAtIndex:0] == '-') {
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    } else {
        [self.brain pushOperand:-1];
        [self.brain performOperation:@"*"];
        [self calculate];
    }
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
    [self calculate];
}

- (void)setVariableValuesX:(double)x
                         a:(double)a
                         b:(double)b {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:x], @"x", [NSNumber numberWithDouble:a], @"a", [NSNumber numberWithDouble:b], @"b", nil];
    [self calculate];
}

- (IBAction)undoPressed {
    [self backspacePressed];
    if (![self userIsInTheMiddleOfEnteringANumber]) {
        [self.brain pop];
        [self calculate];
    }
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GraphProgram"]) {
        GraphViewController *graphViewController = segue.destinationViewController;
        graphViewController.function = self.brain.program;
    }
}
@end
