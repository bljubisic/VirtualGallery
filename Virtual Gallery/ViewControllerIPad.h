//
//  ViewControllerIPad.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 16/01/2013.
//  Copyright (c) 2013 Gtech Beograd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageObject.h"
#import "FlickrModel.h"
#import "ImageModel.h"
#import "ImageDetailsIPadViewController.h"

#define STARTXP 0
#define STARTYP 0
#define MIDXP 512
#define MIDYP 384
#define ENDXP 1024
#define ENDYP 768


@interface ViewControllerIPad : UIViewController <UIGestureRecognizerDelegate, UISearchBarDelegate, ImageModelDelegate, ImageDetailsDelegate>

@property (strong, nonatomic) IBOutlet UIView *pictView;
@property (weak, nonatomic) IBOutlet UIToolbar *mainToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, retain) UIActivityIndicatorView *spinner;
@property (strong, retain) ImageModel *model;
@property (strong, nonatomic) IBOutlet UISearchBar *commandTextField;

- (IBAction)pressedShareButton:(id)sender;
- (IBAction)pressedSearchButton:(id)sender;
- (IBAction)peopleValueChanged:(id) sender;
- (void) loadFinished: (NSNotification *) notification;
- (UIPanGestureRecognizer *) createGestureRecognizer;
- (IBAction)pressedAddButton:(id)sender;
- (void) move: (id) sender;
- (void) moveMidOuterImage: (NSString *) initialPosition;
- (void) moveCentralImage:(int) changeIndex;
- (void) resetViews;
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
- (void)clearViews;
- (void)imageInfoReceived:(ImageObject *) photo;


@end
