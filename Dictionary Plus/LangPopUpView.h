//
//  LangPopUpView.h
//  Dictionary Plus
//
//  Created by Admin on 17/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LangPopUpView : UIView

@property (nonatomic) int SelectedLang;

- (instancetype)initWithRefView:(UIView*) view AtLeft:(BOOL) left DeltaX:(int) dx DeltaY:(int) dy;
- (void) ShowWithLang:(int) lng CallBack:(SEL) callBck Target:(id) target;

@end
