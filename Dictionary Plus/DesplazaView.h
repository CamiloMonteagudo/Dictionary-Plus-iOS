//=========================================================================================================================================================
//  DesplazaView.h
//  Dictionary Plus
//
//  Created by Admin on 14/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import <UIKit/UIKit.h>

#define MODE_LIST    0
#define MODE_SPLIT   1
#define MODE_MEANS   2


//=========================================================================================================================================================
@interface DesplazaView : UIView

@property(nonatomic,readonly) int  Mode;
@property(nonatomic,readonly) BOOL SplitDatos;

- (void)ShowInMode:(int) mode Animate:(BOOL) anim;
- (void) UpdateMode:(int) newMode;

@end
//=========================================================================================================================================================
