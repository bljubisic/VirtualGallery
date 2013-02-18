//
//  ViewController.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubišić on 24/07/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/QuartzCore.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface ViewController () {
    int firstX;
    int firstY;
    int startX;
    int startY;
    int centralIndex;
    NSString *initialPosition;
    NSMutableArray *imagesHolder;
    NSMutableArray *viewsHolder;
    UIView *tmpView;
    BOOL detailsTouched;
    UILabel *titleLabel;
    ImageObject *imageSelected;
    dispatch_queue_t workQ;
}
@end

@implementation ViewController
@synthesize pictView;
@synthesize searchButton;
@synthesize addButton;
@synthesize model;
@synthesize mainToolbar;
@synthesize commandTextField;
@synthesize searchView;
@synthesize spinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchView setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.pictView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
    /*
    CGRect viewFrame = pictView.frame;
    
    viewFrame.origin.x = 0;
    viewFrame.origin.y = 0;
    viewFrame.size.height = 271;
    viewFrame.size.width = 480;
    
    [pictView setFrame:viewFrame];
    */
    [pictView setClipsToBounds:YES];

    //FlickrModel *model = [[FlickrModel alloc] init];

    model = [[ImageModel alloc] init];
    [model setDelegate:self];
    centralIndex = 0;
    tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //[mainToolbar setFrame:CGRectMake(0, 50, 320, 20)];
    [pictView bringSubviewToFront:mainToolbar];
    addButton = [mainToolbar.items objectAtIndex:2];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(480/2.0, 271/2.0)]; // I do this because I'm in landscape mode
    [self.pictView addSubview:spinner]; // spinner is not visible until started
    [pictView bringSubviewToFront:spinner];
    [spinner startAnimating];
    [model getImagesWithCriteria: nil];
    detailsTouched = NO;
    workQ = dispatch_queue_create("label for your queue", 0);

}

-(void) loadFinished: (NSArray *) imagesArray {
    
    int l = ([imagesArray count] > 9)? 9: [imagesArray count];
    imagesHolder = [[NSMutableArray alloc] init];
    viewsHolder = [[NSMutableArray alloc] init];
    for(int i = 0; i < l; i++) {
        ImageObject *image = imagesArray[i];
        
        UIView *viewPurple = [image createImageViewOn:@(i) withColor:[UIColor purpleColor]];
        
        
        [viewPurple addGestureRecognizer:[self createGestureRecognizer] ];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
        [tapRecognizer setDelegate:self];
        [viewPurple addGestureRecognizer:(UITapGestureRecognizer *) tapRecognizer];
        [self.pictView addSubview:viewPurple];
        image.imageView = viewPurple;
        [imagesHolder addObject: image];
        [viewsHolder addObject:viewPurple];
    }
    [pictView bringSubviewToFront:mainToolbar];
    [spinner stopAnimating];
}

-(UIPanGestureRecognizer *) createGestureRecognizer {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    return panRecognizer;
}

- (IBAction)pressedAddButton:(id)sender {
}

- (void) touch:(id) sender {
    //if(!detailsTouched) {
    [spinner removeFromSuperview];
    /*
    spinner = nil;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(480/2.0, 271/2.0)]; // I do this because I'm in landscape mode
    [self.pictView addSubview:spinner]; // spinner is not visible until started
    [pictView bringSubviewToFront:spinner];
    [spinner startAnimating];
     */
    [tmpView removeFromSuperview];
    CGRect tmpViewFrame = [tmpView frame];
    CGRect senderViewFrame = [[sender view] frame];
    tmpViewFrame.origin.x = senderViewFrame.origin.x;
    tmpViewFrame.origin.y = senderViewFrame.origin.y;
    tmpViewFrame.size.height = senderViewFrame.size.height;
    tmpViewFrame.size.width = senderViewFrame.size.width;
        
    [tmpView setFrame:tmpViewFrame];
    [tmpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kocka3.png"]]];
    [pictView addSubview:tmpView];
    [pictView bringSubviewToFront:[sender view]];
    [pictView bringSubviewToFront:mainToolbar];
    NSMutableArray *toolbarButtons = [[self.mainToolbar items] mutableCopy];
        
    UIBarButtonItem *tmpItem = (UIBarButtonItem *) [toolbarButtons objectAtIndex:2];
    // This is how you remove the button from the toolbar and animate it
    [toolbarButtons removeObject:tmpItem];
    //[self setToolbarItems:toolbarButtons animated:YES];
    //[self.mainToolbar setItems:toolbarButtons animated:YES];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, 100.0f, 21.0f)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0]];
    [titleLabel setText:@"Title"];
    //[titleLabel setTextAlignment:UITexta];
    
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    [toolbarButtons insertObject:title atIndex:2];
    [self.mainToolbar setItems:toolbarButtons animated:YES];
    int index = [viewsHolder indexOfObject:[sender view]];
    ImageObject *tmpImage = [imagesHolder objectAtIndex:index];
    [model getImageInfo:tmpImage];
    if(index != 4) {
        if(!detailsTouched) {
            detailsTouched = YES;
            imageSelected = tmpImage;
        }
    }
    else {

        [self showCentralImage: tmpImage];
    }
    //[spinner stopAnimating];
}

-(void) showCentralImage: (ImageObject *) image {
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setCenter:CGPointMake(480/2.0, 271/2.0)]; // I do this because I'm in landscape mode
    [self.pictView addSubview:activity]; // spinner is not visible until started
    [pictView bringSubviewToFront:activity];
    [activity startAnimating];
    dispatch_async(workQ, ^{
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                      bundle:nil];
        ImageDetailsViewController *imageDetails = [sb instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        
        imageDetails.delegate = self;
        [imageDetails setImage: image];
        NSURL * tmpURLImage = [NSURL URLWithString:image.imageURLLarge];
        NSData * imageData = [NSData dataWithContentsOfURL:tmpURLImage];
        UIImage *tmpImage = [[UIImage alloc] initWithData:imageData];
        imageDetails.tempImage = tmpImage;
        [imageDetails setModel:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [activity stopAnimating];
            [self finishedProcessing: imageDetails];
        });
    });
}

-(void) finishedProcessing: (ImageDetailsViewController *) imageDetails {
    
    
    [self presentViewController:imageDetails animated:YES completion:nil];
}
-(void) doneButtonPressed {

    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [model setDelegate:self];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480, 320);
    }
    
    [UIView commitAnimations];
}

-(void)move:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
    
    CGPoint translatedPoint = [recognizer translationInView:pictView];
    if([recognizer state] == UIGestureRecognizerStateEnded) {

        [sender view].layer.shadowColor = [[UIColor clearColor] CGColor];
        [sender view].layer.shadowOffset = CGSizeMake(0, 0);
        [sender view].layer.shadowOpacity = 0;
        [sender view].layer.shadowRadius = 0;
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
        //NSLog(@"\nstartLeft:%f\nstartRight:%f\nmidUp:%f\nmidDown:%f\nmidRight:%f\n", distanceFromStartLeft, distanceFromStartRight, distanceFromMidUp, distanceFromMidDown, distanceFromMidRight);
        //NSLog(@"midLeft:%f\nendRight:%f\nendLeft:%fcenter:%f\n", distanceFromMidLeft, distanceFromEndRight, distanceFromEndLeft, distanceFromCenter);
        NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
        tmpDictionary[@"startLeft"] = @(distanceFromStartLeft);
        tmpDictionary[@"startRight"] = @(distanceFromStartRight);
        tmpDictionary[@"midUp"] = @(distanceFromMidUp);
        tmpDictionary[@"midDown"] = @(distanceFromMidDown);
        tmpDictionary[@"midLeft"] = @(distanceFromMidLeft);
        tmpDictionary[@"midRight"] = @(distanceFromMidRight);
        tmpDictionary[@"endRight"] = @(distanceFromEndRight);
        tmpDictionary[@"endLeft"] = @(distanceFromEndLeft);
        tmpDictionary[@"center"] = @(distanceFromCenter);
        
        
        NSArray *sortedKeys = [tmpDictionary keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 floatValue] > [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 floatValue] < [obj2 floatValue]) {
                return (NSComparisonResult)NSOrderedAscending;	
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSString *endingPosition = (NSString *) sortedKeys[0];
//        NSLog(@"initialPosition: %@", initialPosition);
//        NSLog(@"endingPosition: %@", endingPosition);
        if([initialPosition isEqualToString:@"center"]) {
            int changeIndex = 0;
            if([endingPosition isEqualToString:@"midRight"]) {
                translatedPoint = CGPointMake(ENDX, MIDY);
                changeIndex = -1;
            } else if([endingPosition isEqualToString:@"midLeft"]) {
                translatedPoint = CGPointMake(STARTX, MIDY);
                changeIndex = 1;
            } else
                translatedPoint = CGPointMake(startX, startY);
            if(changeIndex != 0)
                [self moveCentralImage: changeIndex];
            else
                [tmpView removeFromSuperview];
        } else {
            BOOL moved = NO;
            if([endingPosition isEqualToString:@"center"]) {
                translatedPoint = CGPointMake(centerX, centerY);
                moved = YES;
            } else
                translatedPoint = CGPointMake(startX, startY);
            if(([initialPosition isEqualToString:@"midRight"] || [initialPosition isEqualToString:@"midLeft"]) && moved)
                [self moveMidOuterImage: initialPosition];
            else if(!moved)
                [tmpView removeFromSuperview];
            else
                [self moveOuterImage: initialPosition];
        }
        [self resetViews];
        [[sender view] setCenter:translatedPoint];
    }
    else {
        if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
            CGRect tmpViewFrame = [tmpView frame];
            CGRect senderViewFrame = [[sender view] frame];
            tmpViewFrame.origin.x = senderViewFrame.origin.x;
            tmpViewFrame.origin.y = senderViewFrame.origin.y;
            tmpViewFrame.size.height = senderViewFrame.size.height;
            tmpViewFrame.size.width = senderViewFrame.size.width;
            
            [tmpView setFrame:tmpViewFrame];
            [tmpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kocka3.png"]]];
            [pictView addSubview:tmpView];
            /*
            NSLog(@"senderViewFrame: %f : %f", senderViewFrame.size.height, senderViewFrame.size.width );
            senderViewFrame.size.height += 20;
            senderViewFrame.size.width += 20;
            [[sender view] setFrame: senderViewFrame];
            NSLog(@"resized senderViewFrame: %f : %f", senderViewFrame.size.height, senderViewFrame.size.width );

            int index = [viewsHolder indexOfObject:[sender view]];
            ImageObject *tmpImage = [imagesHolder objectAtIndex:index];
            
            CGRect imageFrame = [tmpImage.imageView frame];
            NSLog(@"imageFame: %f : %f", imageFrame.size.height, imageFrame.size.width );
            imageFrame.size.height += 20;
            imageFrame.size.width += 20;
            [tmpImage.imageView setFrame:imageFrame];
            NSLog(@"resized imageFame: %f : %f", imageFrame.size.height, imageFrame.size.width );
             */
            [sender view].layer.shadowColor = [[UIColor blackColor] CGColor];
            [sender view].layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
            [sender view].layer.shadowOpacity = 1.0f;
            [sender view].layer.shadowRadius = 10.0f;
            [pictView bringSubviewToFront:[sender view]];
            [pictView bringSubviewToFront:mainToolbar];
           // [[sender view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"kocka3.png"]]];
            startX = [[sender view] center].x;
            startY = [[sender view] center].y;
            //initialPosition = [[NSString alloc] init];
            //NSLog(@"startx: %d\nstartY: %d", startX, startY);
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
        translatedPoint = CGPointMake(startX + translatedPoint.x, startY + translatedPoint.y);
    }
    
    //NSLog(@"new central point is: %f %f", translatedPoint.x, translatedPoint.y);
   // [self viewIntersectsWithAnotherView:[sender view]];
    
    [[sender view] setCenter:translatedPoint];
    
}

-(void) moveOuterImage: (NSString *) initialPositionTmp {
    
    [self clearViews];
    int position;
    if([initialPositionTmp isEqualToString:@"startLeft"])
        position = 0;
    else if([initialPositionTmp isEqualToString:@"midUp"])
        position = 1;
    else if([initialPositionTmp isEqualToString:@"startRight"])
        position = 2;
    else if([initialPositionTmp isEqualToString:@"endLeft"])
        position = 6;
    else if([initialPositionTmp isEqualToString:@"midDown"])
        position = 7;
    else position = 8;
    [pictView bringSubviewToFront:spinner];
    [spinner startAnimating];
    centralIndex = 0;
    [model moveOuterImageFromPosition:position];
        
}

-(void) moveMidOuterImage: (NSString *) initialPositionTmp {
    

    [self clearViews];
    int changeIndex = 0;
    if([initialPositionTmp isEqualToString:@"midRight"])
        changeIndex = 1;
    else if([initialPositionTmp isEqualToString:@"midLeft"])
        changeIndex = -1;
    int changedIndex = centralIndex + changeIndex;
    centralIndex = changedIndex;
    //NSLog(@"moveOuter ChangeIndex: %d: %d", changedIndex, changeIndex);
    [pictView bringSubviewToFront:spinner];
    [spinner startAnimating];
    [model moveCentralImageWithIndex:changedIndex];
}

-(void) moveCentralImage:(int) changeIndex {
    
    [self clearViews];
    int changedIndex = centralIndex + changeIndex;
    centralIndex = centralIndex + changeIndex;
    //NSLog(@"moveCentral ChangeIndex: %d: %d", changedIndex, changeIndex);
    [pictView bringSubviewToFront:spinner];
    [spinner startAnimating];
    [model moveCentralImageWithIndex:changedIndex];
    
}

- (void) clearViews {
    
    for (UIView *subView in [[self pictView] subviews]) {
        if(![subView isEqual:mainToolbar] && ![subView isEqual:searchView] && ![subView isEqual:spinner])
            [subView removeFromSuperview];
    }
    
}

- (void) resetViews {
    for(int i = 0; i < [imagesHolder count]; i++) {
        ImageObject *tmpImage = (ImageObject *) imagesHolder[i];
        if([tmpImage.moved intValue] == 1) {
            UIView *theView = tmpImage.imageView;
            [theView setCenter:CGPointMake([tmpImage.stX intValue], [tmpImage.stY intValue])];
            tmpImage.moved = 0;
        }
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (void)viewDidUnload
{
    [self setPictView:nil];
    [self setSearchButton:nil];
    [self setMainToolbar:nil];
    [self setSearchView:nil];
    [self setAddButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (IBAction)pressedSearchButton:(id)sender {
    if(searchView.hidden == YES) {
        [pictView bringSubviewToFront:searchView];
        [searchView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
        [searchView setHidden:NO];
        for (UIView *searchBarSubview in [commandTextField subviews]) {
            
            if([searchBarSubview isKindOfClass:[UITextField class]]){
                UITextField *textField = (UITextField*)searchBarSubview;
                [textField becomeFirstResponder];
            }
        }
    }
    else {
        [searchView setHidden:YES];
    }
    
}

- (IBAction)pressedShareButton:(id)sender {
    NSArray *activityItems;
    NSString *postText = @"Seen on #virtualgallery: ";
    if (imageSelected != nil) {
        /*
        NSString * encodedUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                    NULL,
                                                                                    (CFStringRef)imageSelectedURL,
                                                                                    NULL,
                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                    kCFStringEncodingUTF8));
        
        NSURL *tinyUrl = [NSURL URLWithString: [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@", encodedUrl]];
        NSString *shortURL = [NSString stringWithContentsOfURL:tinyUrl encoding:NSASCIIStringEncoding error:nil];
        NSLog(@"Long: %@ - Short: %@",imageSelectedURL,shortURL);
         */
        NSURL *sentURL = [NSURL URLWithString:imageSelected.imageURL];
        activityItems = @[postText, sentURL];
    } else {
        postText = @"enjoying #virtualgallery";
        activityItems = @[postText];
    }
    
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    activityController.excludedActivityTypes  = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

- (IBAction)peopleValueChanged:(id)sender {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [self clearViews];
    for (UIView *searchBarSubview in [searchBar subviews]) {
        
        if([searchBarSubview isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField*)searchBarSubview;
            //[textField setFrame:CGRectMake(0, 0, 480, 10)];
            NSArray *searchData = [[textField text] componentsSeparatedByString:@" "];
            Criteria *crit = [[Criteria alloc] initWithData: searchData];
            [searchBar resignFirstResponder];
            [searchView setHidden:YES];
            [pictView bringSubviewToFront:spinner];
            [spinner startAnimating];
            [model getImagesWithCriteria:crit];
        }
        
    }
    [searchBar resignFirstResponder];
    [searchView setHidden:YES];
    
}

-(void) imageInfoReceived:(ImageObject *) photo {
    [titleLabel setText:photo.title];
    imageSelected = photo;
    detailsTouched = NO;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    UISearchBar *sBar = (UISearchBar *)searchBar;
    [sBar setShowsCancelButton:YES];
    //[sBar setCloseButtonTitle:@"Done" forState:UIControlStateNormal];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchView setHidden:YES];
    
}

@end
