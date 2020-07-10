//=========================================================================================================================================================
//  NumResultView.h
//  TrdSuite
//
//  Created by Camilo on 28/09/15.
//  Copyright (c) 2015 Softlingo. All rights reserved.
//=========================================================================================================================================================

#import <UIKit/UIKit.h>

@class NumGroupView;
@class NumResultView;

//=========================================================================================================================================================
@protocol NumResultDelegate

@optional
- (void) OnNumResultChagedSize:(NumResultView *) view;

@end
//=========================================================================================================================================================

@interface NumResultView : UIView

  @property (weak) id<NumResultDelegate> Delegate;

  @property (nonatomic) NSString* Text;
  @property (nonatomic) float hPanel;
  @property (nonatomic) float wPanel;
  
  @property (weak, nonatomic) NumGroupView *NumEdit;

- (void) SetNumberReadingInLang:(int) lng;

@end
//=========================================================================================================================================================
