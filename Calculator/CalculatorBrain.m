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

+ (int)precedenceForOperation:(NSString *)operation
{
    if ([operation isEqualToString:@"+"])
        return 1;
    else if ([operation isEqualToString:@"-"])
        return 1;
    else
        return 0;
}

+ (BOOL)isOperation:(NSString *)term
{
    return nil != [self.operations objectForKey:term];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
                             withPrecendence:(int)precedence
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
            result = [NSString stringWithFormat:@"%@(%@)", str, [self descriptionOfTopOfStack:stack withPrecendence:0]];
        } else {
            int operationPrecedence = [self precedenceForOperation:str];
            NSString *operand1 = [self descriptionOfTopOfStack:stack withPrecendence:operationPrecedence];
            NSString *operand2 = [self descriptionOfTopOfStack:stack withPrecendence:operationPrecedence];
            result = [NSString stringWithFormat:@"%@ %@ %@", operand2, str, operand1];
            if (precedence < operationPrecedence)
                result = [NSString stringWithFormat:@"(%@)", result];
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

    NSMutableArray *descriptionPieces = [[NSMutableArray alloc] init];
    while ([stack count] > 0)
        [descriptionPieces insertObject:[self descriptionOfTopOfStack:stack withPrecendence:1] atIndex:0];
    
    return [descriptionPieces componentsJoinedByString:@", "];
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
                 withVariableValues:(NSDictionary *)variableValues
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
            result = [self popOperandOffProgramStack:stack withVariableValues:variableValues] +
            [self popOperandOffProgramStack:stack withVariableValues:variableValues];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack withVariableValues:variableValues] *
            [self popOperandOffProgramStack:stack withVariableValues:variableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack withVariableValues:variableValues];
            result = [self popOperandOffProgramStack:stack withVariableValues:variableValues] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack withVariableValues:variableValues];
            if (divisor) result = [self popOperandOffProgramStack:stack withVariableValues:variableValues] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack withVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack withVariableValues:variableValues]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            double operand = [self popOperandOffProgramStack:stack withVariableValues:variableValues];
            if (operand >= 0)
                result = sqrt(operand);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else {
            result = [[variableValues objectForKey:operation] doubleValue];
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
    return [self popOperandOffProgramStack:stack withVariableValues:variableValues];
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

- (void)pop
{
    [self.programStack removeLastObject];
}

- (void)clear
{
    [self.programStack removeAllObjects];
}

@end
