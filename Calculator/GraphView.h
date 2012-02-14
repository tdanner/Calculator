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

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@property (weak, nonatomic) id <GraphDelegate> graphDelegate;

- (void)pinch:(UIPinchGestureRecognizer *)recognizer;
- (void)pan:(UIPanGestureRecognizer *)recognizer;
- (void)tap:(UITapGestureRecognizer *)recognizer;

@end
