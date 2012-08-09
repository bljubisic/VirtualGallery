//
//  ViewController.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubišić on 24/07/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageObject.h"


#define STARTX 0
#define STARTY 0
#define MIDX 240
#define MIDY 138
#define ENDX 480
#define ENDY 276

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *pictView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
- (IBAction)pressedSearchButton:(id)sender;

@end
