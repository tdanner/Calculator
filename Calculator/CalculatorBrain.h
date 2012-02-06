//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Tim Danner on 1/27/12.
//  Copyright (c) 2012 Tim Danner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variableName;
- (double)performOperation:(NSString *)operation;
- (void)pop;
- (void)clear;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
