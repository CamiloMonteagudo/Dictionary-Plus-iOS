//=========================================================================================================================================================
//  BtnsBarView.h
//  Dictionary Plus
//
//  Created by Admin on 6/4/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import <UIKit/UIKit.h>

#define CMD_MENU        0x0001
#define CMD_SPLIT       0x0002
#define CMD_WRDS        0x0004
#define CMD_MEANS       0x0008
#define CMD_ALL_MEANS   0x0010
#define CMD_DEL_MEANS   0x0020

#define ExecComamd  @"ExecComamdNotification"

//=========================================================================================================================================================
extern void MakeDictCmdBar();

extern void DictCmdBarAddToView(UIView* view);
extern void DictCmdBarEnable( int sw );
extern void DictCmdBarDisable( int sw );

extern UIButton* DictCmdBarGetBtn( int ID);
extern CGFloat   DictCmdBarWidth();
extern void      DictCmdBarRefresh();
extern void      DictCmdBarOnRight( BOOL oRight );

extern NSString* TitleForComand( int ID );

//=========================================================================================================================================================
@interface BtnsBarView : UIView

@property (nonatomic) BOOL Left;

- (void) AddBtn:(int) idBtn WithImage:(NSString*) sImg;

- (void) Enable:(int) sw;
- (void) Disable:(int) sw;

- (UIButton*) GetButtonWithID:(int) IdBtn;
- (UIButton*) GetButtonWithIndex:(int) idx;

- (BOOL) IsActiveBtnWithID:(int) IdBtn;

@end
//=========================================================================================================================================================
