//=========================================================================================================================================================
//  LangPopUpView.m
//  Dictionary Plus
//
//  Created by Admin on 17/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "LangPopUpView.h"
#import "AppData.h"

#define HROW    50
#define SEP_     3

#define WPOP_UP  150
#define HPOP_UP  ( (LGCount*(HROW+SEP_)) + SEP_ )


//=========================================================================================================================================================
@interface LangPopUpView ()
  {
  UIView* popUp;
  
  SEL OnSelLang;
  id  InfoObj;
  }
@end

//=========================================================================================================================================================
@implementation LangPopUpView

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea un popup y lo posiciona relativo a la vista 'view' en la posicion definida por 'Pos' y desplazado en las magnitudes 'dx' y 'dy'
- (instancetype)initWithRefView:(UIView*) view AtLeft:(BOOL) left DeltaX:(int) dx DeltaY:(int) dy
  {
  _SelectedLang = -1;
  
  UIView* topView = FindTopView( view );
  if( topView==nil ) return nil;
  
  self = [super initWithFrame:topView.bounds];
  if( !self ) return self;
  
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.10];
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [topView addSubview:self];
  
  CGRect rcRef = view.frame;
  CGRect rc;
  
  if( left ) rc.origin.x = rcRef.origin.x + dx;
  else       rc.origin.x = rcRef.origin.x + rcRef.size.width - WPOP_UP + dx;
  
  rc.origin.y = rcRef.origin.y + rcRef.size.height + dy;
  
  rc.size.width  = WPOP_UP;
  rc.size.height = 0;
  
  CGRect rcFrm = [self convertRect:rc fromView: view.superview ];
  
  popUp = [[UIView alloc] initWithFrame:rcFrm];
  
  popUp.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
  popUp.clipsToBounds = TRUE;
  
  [self AddLanguajes ];
  [self addSubview:popUp];
  
  if( popUp.center.x > topView.center.x )
    popUp.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  
  return self;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone todo los idiomas en la lista
- (void) AddLanguajes
  {
  int y = -HPOP_UP + SEP_;
  
  for( int i=0; i<LGCount; ++i )
    {
    CGRect rc = CGRectMake(SEP_, y, WPOP_UP-SEP_-SEP_, HROW);
    UIView* row = [[UIView alloc]  initWithFrame:rc ];
    
    row.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    row.backgroundColor  = [UIColor whiteColor];
    
    [self FillRow:row WihtLang:i ];
    
    [popUp addSubview:row ];
    
    y += (SEP_ + HROW);
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Rellena la fila con los datos del idioma dado
- (void) FillRow:(UIView*)row WihtLang:(int) lng
  {
  CGRect rc1 = CGRectMake(5, 0, 42, 50);
  CGRect rc2 = CGRectMake(49, 13, 80, 21);
  
  UIImageView* srcIcon  = [[UIImageView alloc] initWithFrame:rc1];
  UILabel*     srcLabel = [[UILabel     alloc] initWithFrame:rc2];
  
  srcIcon.contentMode = UIViewContentModeLeft;
 
  [row addSubview:srcIcon];
  [row addSubview:srcLabel];
  
  NSCharacterSet *sp = [NSCharacterSet whitespaceCharacterSet];
  
  srcIcon.image = [UIImage imageNamed: LGFlagName(lng) ];
  srcLabel.text = [LGName(lng) stringByTrimmingCharactersInSet:sp];
  
  [srcLabel sizeToFit];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone como seleccionada la fila idxRow
- (void) SelectRow:(int) idxRow
  {
  if( _SelectedLang != -1 )
    popUp.subviews[_SelectedLang].backgroundColor = [UIColor whiteColor];
  
  if( idxRow>=0 && idxRow< (int)popUp.subviews.count)
    {
    _SelectedLang = idxRow;
    popUp.subviews[idxRow].backgroundColor = [UIColor colorWithRed:0.7 green:0.95 blue:1.0 alpha:1.0];
    }
  else
    _SelectedLang = -1;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void) ShowWithLang:(int) lng CallBack:(SEL) callBck Target:(id) target
  {
  OnSelLang = callBck;
  InfoObj   = target;
  
  [self SelectRow:lng];
  
  CGRect rc = popUp.frame;
  rc.size.height = HPOP_UP;
  
  [UIView animateWithDuration:0.5 animations:^{
   self->popUp.frame = rc;
  }];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Cuando toca sobre el fondo de la pantalla
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  CGPoint pnt = [[touches anyObject] locationInView: popUp];     // Punto que se toco dentro de la vista
  
  int lng = -1;
  if( pnt.x>0 && pnt.x<WPOP_UP && pnt.y>0 && pnt.y<(HPOP_UP-SEP_) )
    {
    lng = (int)(pnt.y / (HROW+SEP_));
  
    if( lng==_SelectedLang ) lng = -1;
    }
  
  [self SelectRow: lng];
  
  CGRect rc = popUp.frame;
  rc.size.height = 0;
  
  [UIView animateWithDuration:0.5
    animations:^
      {
      self->popUp.frame = rc;
      }
    completion:^(BOOL finished)
      {
      [self->InfoObj performSelector:self->OnSelLang withObject:self afterDelay:0.0];
  
      [self removeFromSuperview];
      }];
  
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
//=========================================================================================================================================================
