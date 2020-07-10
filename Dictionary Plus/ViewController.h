//=========================================================================================================================================================
//  ViewController.h
//  Dictionary Plus
//
//  Created by Admin on 13/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import <UIKit/UIKit.h>
#import "TextQueryPlus.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (nonatomic) BOOL CmdsRight;
@property (nonatomic) BOOL AllMeans;          // Indica que se muestran todos los significados de las palabras encontradas

- (BOOL) LoadDictWithSrc:(int) src AndDes:(int) des;
- (void) UpdateBarSizeAndPos;

- (int) CountFoundWord;
- (int) CountOfMeans;

- (IBAction)ReturnFromUnwind:(UIStoryboardSegue *)unWindSegue;

- (void) GoToConjVerb:(NSString*) verb Lang:(int) lng;

- (void) FindFrasesWithQuery:(FOUNDS_ENTRY*) FoundEntries NWords:(NSInteger)Count Options:(int) sw;

@end
//=========================================================================================================================================================

