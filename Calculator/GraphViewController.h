//
//  GraphController.h
//  Calculator
//
//  Created by Tim Danner on 2/13/12.
//  Copyright (c) 2012 Tim Danner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphDelegate>
@property (weak, nonatomic) id function;
@end
