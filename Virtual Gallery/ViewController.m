//
//  ViewController.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubišić on 24/07/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "ViewController.h"




@interface ViewController () {
    int firstX;
    int firstY;
    int startX;
    int startY;
    NSString *initialPosition;
}
@end

@implementation ViewController
@synthesize pictView;
@synthesize searchButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    /*
    CGRect viewFrame = pictView.frame;
    
    viewFrame.origin.x = 0;
    viewFrame.origin.y = 0;
    viewFrame.size.height = 271;
    viewFrame.size.width = 480;
    
    [pictView setFrame:viewFrame];
    */
    [pictView setClipsToBounds:YES];

    ImageObject *imageObject = [[ImageObject alloc] init];
    
    UIView *viewBlue = [imageObject createImageView:[[NSNumber alloc] initWithInt:0] withColor:[UIColor blueColor]];
    UIPanGestureRecognizer *panRecognizer = [self createGestureRecognizer];
    
    [viewBlue addGestureRecognizer:panRecognizer];
    
    [pictView addSubview:viewBlue];
    
    UIView *viewGreen = [imageObject createImageView:[[NSNumber alloc] initWithInt:1] withColor:[UIColor greenColor]];
    
    [viewGreen addGestureRecognizer:[self createGestureRecognizer]];
    
    [pictView addSubview:viewGreen];
    
    UIView *viewBlack = [imageObject createImageView:[[NSNumber alloc] initWithInt:2] withColor:[UIColor blackColor]];
    
    [viewBlack addGestureRecognizer:[self createGestureRecognizer]];
    
    [pictView addSubview:viewBlack];
    
    UIView *viewGray = [imageObject createImageView:[[NSNumber alloc] initWithInt:3] withColor:[UIColor grayColor]];


    [viewGray addGestureRecognizer:[self createGestureRecognizer] ];
    
    [pictView addSubview:viewGray];
    
    UIView *viewYellow = [imageObject createImageView:[[NSNumber alloc] initWithInt:4] withColor:[UIColor yellowColor]];
    
    
    [viewYellow addGestureRecognizer:[self createGestureRecognizer] ];
    
    [pictView addSubview:viewYellow];
    
    UIView *viewRed = [imageObject createImageView:[[NSNumber alloc] initWithInt:5] withColor:[UIColor redColor]];
    
    
    [viewRed addGestureRecognizer:[self createGestureRecognizer] ];
    
    [pictView addSubview:viewRed];
    
    UIView *viewCyan = [imageObject createImageView:[[NSNumber alloc] initWithInt:6] withColor:[UIColor cyanColor]];
    
    
    [viewCyan addGestureRecognizer:[self createGestureRecognizer] ];
    
    [pictView addSubview:viewCyan];
    
    UIView *viewBrown = [imageObject createImageView:[[NSNumber alloc] initWithInt:7] withColor:[UIColor brownColor]];
    
    
    [viewBrown addGestureRecognizer:[self createGestureRecognizer] ];
    
    [pictView addSubview:viewBrown];
    
    UIView *viewPurple = [imageObject createImageView:[[NSNumber alloc] initWithInt:8] withColor:[UIColor purpleColor]];
    
    
    [viewPurple addGestureRecognizer:[self createGestureRecognizer] ];
    
    [pictView addSubview:viewPurple];
}

-(UIPanGestureRecognizer *) createGestureRecognizer {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    return panRecognizer;
}

-(void)move:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
    
    CGPoint translatedPoint = [recognizer translationInView:pictView];
    if([recognizer state] == UIGestureRecognizerStateEnded) {

        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
        int centerX = [pictView center].x;
        int centerY = [pictView center].y;
        float distanceFromStartLeft = sqrt(pow(abs(STARTX - firstX), 2) + pow(abs(STARTY - firstY), 2));
        float distanceFromStartRight = sqrt(pow(abs(ENDX - firstX), 2) + pow(abs(STARTY - firstY), 2));
        float distanceFromMidUp = sqrt(pow(abs(MIDX - firstX), 2) + pow(abs(STARTY - firstY), 2));
        float distanceFromMidDown = sqrt(pow(abs(MIDX - firstX), 2) + pow(abs(ENDY - firstY), 2));
        float distanceFromMidRight = sqrt(pow(abs(ENDX - firstX), 2) + pow(abs(MIDY - firstY), 2));
        float distanceFromMidLeft = sqrt(pow(abs(STARTX - firstX), 2) + pow(abs(MIDY - firstY), 2));
        float distanceFromEndRight = sqrt(pow(abs(ENDX - firstX), 2) + pow(abs(ENDY - firstY), 2));
        float distanceFromEndLeft = sqrt(pow(abs(STARTX - firstX), 2) + pow(abs(ENDY - firstY), 2));
        float distanceFromCenter = sqrt(pow(abs(firstX - centerX), 2) + pow(abs(firstY - centerY), 2));
        NSLog(@"\nstartLeft:%f\nstartRight:%f\nmidUp:%f\nmidDown:%f\nmidRight:%f\n", distanceFromStartLeft, distanceFromStartRight, distanceFromMidUp, distanceFromMidDown, distanceFromMidRight);
        NSLog(@"midLeft:%f\nendRight:%f\nendLeft:%fcenter:%f\n", distanceFromMidLeft, distanceFromEndRight, distanceFromEndLeft, distanceFromCenter);
        NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromStartLeft] forKey:@"startLeft"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromStartRight] forKey:@"startRight"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromMidUp] forKey:@"midUp"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromMidDown] forKey:@"midDown"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromMidLeft] forKey:@"midLeft"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromMidRight] forKey:@"midRight"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromEndRight] forKey:@"endRight"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromEndLeft] forKey:@"endLeft"];
        [tmpDictionary setObject:[[NSNumber alloc] initWithFloat:distanceFromCenter] forKey:@"center"];
        
        
        NSArray *sortedKeys = [tmpDictionary keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 floatValue] < [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedAscending;	
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSString *key = (NSString *) [sortedKeys objectAtIndex:0];
        NSLog(@"initialPosition: %@", initialPosition);
        NSLog(@"key: %@", key);
        if([initialPosition isEqualToString:@"center"]) {
            if([key isEqualToString:@"midRight"]) {
                translatedPoint = CGPointMake(ENDX, MIDY);
            } else if([key isEqualToString:@"midLeft"]) {
                translatedPoint = CGPointMake(STARTX, MIDY);
            } else
                translatedPoint = CGPointMake(startX, startY);
        } else {
            if([key isEqualToString:@"center"]) {
                translatedPoint = CGPointMake(centerX, centerY);
            } else
                translatedPoint = CGPointMake(startX, startY);
        }
        [[sender view] setCenter:translatedPoint];
         
                    
    }
    else {
        if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
            startX = [[sender view] center].x;
            startY = [[sender view] center].y;
            //initialPosition = [[NSString alloc] init];
            NSLog(@"startx: %d\nstartY: %d", startX, startY);
            if(startX == STARTX) {
                if(startY == STARTY)
                    initialPosition = @"startLeft";
                else if(startY == MIDY)
                    initialPosition = @"midLeft";
                else if(startY == ENDY)
                    initialPosition = @"endLeft";
            } else if(startX == MIDX) {
                if(startY == STARTY)
                    initialPosition = @"midUp";
                else if(startY == MIDY)
                    initialPosition = @"center";
                else if(startY == ENDY)
                    initialPosition = @"midDown";
            } else if(startX == ENDX) {
                if(startY == STARTY)
                    initialPosition = @"startRight";
                else if(startY == MIDY)
                    initialPosition = @"midRight";
                else if(startY == ENDY)
                    initialPosition = @"endRight";
            }
        }
        translatedPoint = CGPointMake(startX+translatedPoint.x, startY+translatedPoint.y);
        [[sender view] setCenter:translatedPoint];
    }
    
}

- (void)viewDidUnload
{
    [self setPictView:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    //return NO;
}

- (IBAction)pressedSearchButton:(id)sender {
    UIBarButtonItem *pressedButton = (UIBarButtonItem *)sender;
    
    NSLog(@"Pressed button: %@", [pressedButton debugDescription]);
    
}
@end
