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
#define CMD_PREV_WRD    0x0040
#define CMD_NEXT_WRD    0x0080
#define CMD_DEL_MEAN    0x0100
#define CMD_CONJ_WRD    0x0200
#define CMD_FIND_WRD    0x0400

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
extern void MakeDataCmdBar();
extern void DataCmdBarEnable( int sw );
extern void DataCmdBarDisable( int sw );
extern void DataCmdBarPosBottomView( UIView* view );
extern void DataCmdBarRefresh();
extern BOOL DataCmdBarIsEnable( int sw );
extern BOOL DataCmdBarInView( UIView* view );

//=========================================================================================================================================================
@interface BtnsBarView : UIView

@property (nonatomic) int Left;                             // Número de botones pegados a la izquierda

- (void) AddBtn:(int) idBtn WithImage:(NSString*) sImg;

- (BOOL) IsEnable:(int) sw;

- (void) Enable:(int) sw;
- (void) Disable:(int) sw;

- (UIButton*) GetButtonWithID:(int) IdBtn;
- (UIButton*) GetButtonWithIndex:(int) idx;

- (BOOL) IsActiveBtnWithID:(int) IdBtn;

@end
//=========================================================================================================================================================
