//
//  GraphView.h
//  Calculator
//
//  Created by Tim Danner on 2/13/12.
//  Copyright (c) 2012 Tim Danner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphDelegate <NSObject>

- (float)yForX:(float)x;

@end

@interface GraphView : UIView

@property (weak, nonatomic) id <GraphDelegate> graphDelegate;

@end
