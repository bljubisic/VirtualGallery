//
//  ViewController.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubišić on 24/07/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageObject.h"
#import "FlickrModel.h"
#import "ImageModel.h"

#define STARTX 0
#define STARTY 0
#define MIDX 240
#define MIDY 138
#define ENDX 480
#define ENDY 276

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UISearchBarDelegate, ImageModelDelegate>


@property (weak, nonatomic) IBOutlet UIView *pictView;
@property (weak, nonatomic) IBOutlet UIToolbar *mainToolbar;
@property (strong, nonatomic) IBOutlet UISearchBar *commandTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, retain) ImageModel *model;
@property (weak, nonatomic) IBOutlet UIView *searchView;


- (IBAction)pressedSearchButton:(id)sender;
- (IBAction)peopleValueChanged:(id) sender;
- (void) loadFinished: (NSNotification *) notification;
- (UIPanGestureRecognizer *) createGestureRecognizer;
- (IBAction)pressedAddButton:(id)sender;
- (void) move: (id) sender;
- (void) moveMidOuterImage: (NSString *) initialPosition;
- (void) moveCentralImage:(int) changeIndex;
- (void)viewIntersectsWithAnotherView:(UIView*)selectedView;
- (void) resetViews;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
- (void)clearViews;
- (void)imageInfoReceived:(NSDictionary *)response;

@end
