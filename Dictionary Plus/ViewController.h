//=========================================================================================================================================================
//  ViewController.h
//  Dictionary Plus
//
//  Created by Admin on 13/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL CmdsRight;

- (BOOL) LoadDictWithSrc:(int) src AndDes:(int) des;
- (void) UpdateBarSizeAndPos;

- (int) CountFoundWord;
- (int) CountOfMeans;

@end
//=========================================================================================================================================================

