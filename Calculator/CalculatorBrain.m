//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Tim Danner on 1/27/12.
//  Copyright (c) 2012 Tim Danner. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

static NSDictionary *_operations = nil;

- (NSMutableArray *)programStack
{
    if (!_programStack)
        _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

+ (NSDictionary *)operations
{
    if (!_operations)
        _operations = [NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithInt:2], @"+", 
                       [NSNumber numberWithInt:2], @"-", 
                       [NSNumber numberWithInt:2], @"*", 
                       [NSNumber numberWithInt:2], @"/", 
                       [NSNumber numberWithInt:1], @"sin", 
                       [NSNumber numberWithInt:1], @"cos", 
                       [NSNumber numberWithInt:1], @"sqrt", 
                       [NSNumber numberWithInt:0], @"π", 
                       nil];
    return _operations;
}

+ (BOOL)isOperation:(NSString *)term
{
    return nil != [self.operations objectForKey:term];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfTopOfProgramStack:(NSMutableArray *)stack
{
    NSString *result = @"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack description];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *str = topOfStack;
        NSNumber *operationArgCount = [self.operations objectForKey:str];
        int numArgs = [operationArgCount intValue];
        if (operationArgCount == nil) {
            result = str;
        } else if (numArgs == 0) {
            result = str;
        } else if (numArgs == 1) {
            result = [NSString stringWithFormat:@"%@(%@)", str, [self descriptionOfTopOfProgramStack:stack]];
        } else {
            result = [NSString stringWithFormat:@"%@ %@ %@", [self descriptionOfTopOfProgramStack:stack], str, [self descriptionOfTopOfProgramStack:stack]];
        }
    }
    
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }

    return [self descriptionOfTopOfProgramStack:stack];
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variableName
{
    [self.programStack addObject:variableName];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double operand = [self popOperandOffProgramStack:stack];
            if (operand >= 0)
                result = sqrt(operand);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *variables = [[NSMutableSet alloc] init];
    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    for (id item in stack) {
        if ([item isKindOfClass:[NSString class]] && ![self.operations objectForKey:item]) {
            [variables addObject:item];
        }
    }
    
    return [variables copy];
}

- (void)clear
{
    [self.programStack removeAllObjects];
}

@end
