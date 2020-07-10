//=========================================================================================================================================================
//  LangPopUpView.m
//  Dictionary Plus
//
//  Created by Admin on 17/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "CmdPopUpView.h"
#import "AppData.h"
#import "BtnsBarView.h"
#import "ColAndFont.h"

#define SEP_    3

#define H_ROW   40
#define H_ICON  40
#define W_ICON  40
#define W_TEXT  120

//#define WPOP_UP  150
//#define HPOP_UP  ( (LGCount*(HROW+SEP_)) + SEP_ )


//=========================================================================================================================================================
@interface CmdPopUpView ()
  {
  UIView* popUp;
  
  SEL OnSelLang;
  id  InfoObj;
  
  CGRect Frame;
  BtnsBarView* Bar;
  
  NSMutableArray<UIButton*>* ActiveBtns;
  
  int HPopUp;
  int WPopUp;
  }
@end

//=========================================================================================================================================================
@implementation CmdPopUpView

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea un popup y lo posiciona relativo a la vista 'view' en la posicion definida por 'Pos' y desplazado en las magnitudes 'dx' y 'dy'
- (instancetype)initWithBtnsBar:(UIView*) view DeltaX:(int) dx DeltaY:(int) dy
  {
  Bar = (BtnsBarView*) view;
  
  UIView* topView = FindTopView( view );
  if( topView==nil ) return nil;
  
  Frame = topView.bounds;
  self = [super initWithFrame: Frame];
  if( !self ) return self;
  
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.10];
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [topView addSubview:self];
  
  [self GetActiveButtons];
  
  UIButton* btnMnu = [Bar GetButtonWithID:CMD_MENU];
  CGRect rcRef = btnMnu.frame;
  CGRect rc;
  
  CGPoint pnt = [btnMnu convertPoint:rcRef.origin toView:topView ];
  
  if( pnt.x < 150 ) rc.origin.x = rcRef.origin.x + dx;
  else              rc.origin.x = rcRef.origin.x + rcRef.size.width - WPopUp + dx;
  
  rc.origin.y = rcRef.origin.y + rcRef.size.height + dy;
  
  rc.size.width  = WPopUp;
  rc.size.height = 0;
  
  rc = [self convertRect:rc fromView: btnMnu.superview ];
  
  popUp = [[UIView alloc] initWithFrame:rc];
  
  popUp.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
  popUp.clipsToBounds = TRUE;
  
  [self AddCommands ];
  [self addSubview:popUp];
  
  if( popUp.center.x > topView.center.x )
    popUp.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  
  _SelectedCmd = 0;
  return self;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia el tamaño de la vista
- (void)layoutSubviews
  {
  CGSize sz = self.bounds.size;
  
  if( sz.width != Frame.size.width )
    [self HidePopUp];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone todo los idiomas en la lista
- (void) AddCommands
  {
  int y = -HPopUp + SEP_;
  
  for( int i=0; i<ActiveBtns.count; ++i )
    {
    CGRect rc = CGRectMake(SEP_, y, WPopUp-SEP_-SEP_, H_ROW);
    UIView* row = [[UIView alloc]  initWithFrame:rc ];
    
    row.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    row.backgroundColor  = [UIColor whiteColor];
    
    [self FillRow:row Index:i ];
    
    [popUp addSubview:row ];
    
    y += (SEP_ + H_ROW);
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Rellena la fila con los datos del idioma dado
- (void) FillRow:(UIView*)row Index:(int) idx
  {
  UIButton* btn = ActiveBtns[idx];
  NSString* Txt = TitleForComand((int)btn.tag);
  
  CGFloat w = row.frame.size.width;
  
  CGRect rcIcon = CGRectMake(0, 0, W_ICON, H_ICON);
  CGRect rcText = CGRectMake(W_ICON-5, 0, w-W_ICON+5, H_ROW);
  
  UIImageView* cmdIcon = [[UIImageView alloc] initWithFrame:rcIcon];
  UITextView*  cmdLabel = [[UITextView  alloc] initWithFrame:rcText];
  
  cmdIcon.contentMode = UIViewContentModeLeft;
 
  [row addSubview:cmdIcon];
  [row addSubview:cmdLabel];
  
  cmdLabel.userInteractionEnabled = false;
  cmdLabel.backgroundColor = [UIColor clearColor];

  cmdIcon.image = btn.imageView.image;
  cmdLabel.attributedText = [[NSAttributedString alloc] initWithString:Txt attributes:attrCmdMnu];
  
  [cmdLabel sizeToFit];
  
  CGFloat xc = cmdLabel.center.x;
  cmdLabel.center = CGPointMake(xc, H_ROW/2);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene une arreglo con todos los comandos activos
- (void) GetActiveButtons
  {
  ActiveBtns = [NSMutableArray new];
  
  for( int i=0;; ++i )
    {
    UIButton* btn = [Bar GetButtonWithIndex:i];
    if( !btn ) break;
    
    NSInteger idBtn = btn.tag;
    if( idBtn!=CMD_MENU && [Bar IsActiveBtnWithID:(int)idBtn] )
      [ActiveBtns addObject:btn];
    }
  
  WPopUp = W_ICON + W_TEXT + SEP_;
  HPopUp = (int)ActiveBtns.count * (SEP_ + H_ROW) + SEP_ ;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void) ShowWithCallBack:(SEL) callBck Target:(id) target
  {
  OnSelLang = callBck;
  InfoObj   = target;
  
  CGRect rc = popUp.frame;
  
  int nRows = (int)popUp.subviews.count;
  rc.size.height = nRows * (SEP_ + H_ROW) + SEP_;
  
  [UIView animateWithDuration:0.5 animations:^{
    popUp.frame = rc;
  }];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Oculta la selección de un comando
- (void) HidePopUp
  {
  CGRect rc = popUp.frame;
  rc.size.height = 0;
  
  [UIView animateWithDuration:0.5
    animations:^
      {
      popUp.frame = rc;
      }
    completion:^(BOOL finished)
      {
      [InfoObj performSelector:OnSelLang withObject:self afterDelay:0.0];
  
      [self removeFromSuperview];
      }];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Cuando toca sobre el fondo de la pantalla
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  CGPoint pnt = [[touches anyObject] locationInView: popUp];     // Punto que se toco dentro de la vista
  
  if( pnt.x>0 && pnt.x<WPopUp && pnt.y>0 && pnt.y<(HPopUp-SEP_) )
    {
    int idx = (int)(pnt.y / (H_ROW+SEP_));
    [self SelectRow:idx];
    }
  
  [self HidePopUp];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone como seleccionada la fila idxRow
- (void) SelectRow:(int) idxRow
  {
  if( idxRow>=0 && idxRow<ActiveBtns.count )
    {
    _SelectedCmd = (int)ActiveBtns[idxRow].tag;
    popUp.subviews[idxRow].backgroundColor = [UIColor colorWithRed:0.7 green:0.95 blue:1.0 alpha:1.0];
    }
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
