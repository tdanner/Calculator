//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Tim Danner on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)
#define MAX_HISTORY_LENGTH  50

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
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

- (BOOL)equalsShown {
    return [self.history.text characterAtIndex:self.history.text.length - 1] == '=';
}

- (void)showEquals {
    if (![self equalsShown])
        self.history.text = [self.history.text stringByAppendingString:@" ="];
}

- (void)hideEquals {
    if ([self equalsShown])
        self.history.text = [self.history.text substringToIndex:self.history.text.length - 2];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        [self hideEquals];
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
        [self hideEquals];
    }        
}

- (void)addHistory:(NSObject *)item {
    [self hideEquals];
    self.history.text = [self.history.text stringByAppendingFormat:@" %@", item];

    if (self.history.text.length > MAX_HISTORY_LENGTH) {
        self.history.text = [self.history.text substringFromIndex:self.history.text.length - MAX_HISTORY_LENGTH];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self addHistory:self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    [self addHistory:operation];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self showEquals];
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.history.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self hideEquals];
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
        [self addHistory:@"+/-"];
        [self showEquals];
    }
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
