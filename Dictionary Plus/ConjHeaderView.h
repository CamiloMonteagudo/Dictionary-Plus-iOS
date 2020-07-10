//=========================================================================================================================================================
//  ConjHeaderView.h
//  TrdSuite
//
//  Created by Camilo on 17/09/15.
//  Copyright (c) 2015 Softlingo. All rights reserved.
//=========================================================================================================================================================

//=========================================================================================================================================================
#import <UIKit/UIKit.h>

@class ConjHeaderView;

//=========================================================================================================================================================
@protocol ConjHeaderDelegate

@optional

- (void) OnConjHdrChangeMode:(ConjHeaderView*) view;
- (void) OnConjHdrChangeSize:(ConjHeaderView*) view;

@end

//=========================================================================================================================================================
@interface ConjHeaderView : UIView

  @property (weak) id<ConjHeaderDelegate> Delegate;

  @property (nonatomic) int Mode;                                     // Modo que se muestra la vista
  @property (nonatomic) float wPanel;
  @property (nonatomic) float hPanel;
  
  - (void) ClearData;
  - (void) ShowDataVerb:(BOOL) isVerb;
  - (void) ShowMessage:(NSString*) sMsg Color:(UIColor*) col;

@end
//=========================================================================================================================================================
