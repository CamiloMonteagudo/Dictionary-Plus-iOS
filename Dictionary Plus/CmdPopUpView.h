//=========================================================================================================================================================
//  CmdPopUpView.h
//  Dictionary Plus
//
//  Created by Admin on 17/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import <UIKit/UIKit.h>

//=========================================================================================================================================================
@interface CmdPopUpView : UIView

@property (nonatomic, readonly) int SelectedCmd;

- (instancetype)initWithBtnsBar:(UIView*) view DeltaX:(int) dx DeltaY:(int) dy;

- (void) ShowWithCallBack:(SEL) callBck Target:(id) target;
- (void) HidePopUp;

@end
//=========================================================================================================================================================
