//=========================================================================================================================================================
//  ViewController.h
//  Dictionary Plus
//
//  Created by Admin on 13/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

- (BOOL) LoadDictWithSrc:(int) src AndDes:(int) des;

@end
//=========================================================================================================================================================

