//=========================================================================================================================================================
//  DesplazaView.m
//  Dictionary Plus
//
//  Created by Admin on 14/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "DesplazaView.h"
#import "AppData.h"
#import "BtnsBarView.h"

//=========================================================================================================================================================
@interface DesplazaView ()
  {
  UIView* Panel1;
  UIView* Panel2;

  CGFloat xIni;
  }
@end

//=========================================================================================================================================================
@implementation DesplazaView

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (instancetype)initWithFrame:(CGRect)frame
  {
  self = [super initWithFrame:frame];
  if( !self ) return self;
  
  [self initDatos];
  return self;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (instancetype)initWithCoder:(NSCoder *)aDecoder
  {
  self = [super initWithCoder:aDecoder];
  if( !self ) return self;
  
  [self initDatos];
  return self;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)initDatos
  {
  _Mode = -1;       // Para forzar a un cambio de modo al inicio
  
  // Crea un gesto para ocultar o mostrar el nombre de idioma para ganar espacio
  UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(OnGeture:)];
  [self addGestureRecognizer:gesture];
  
  Panel1 = self.subviews[0];
  Panel2 = self.subviews[1];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
  {
  int nowMode = _Mode;
  
  if( (nowMode == MODE_SPLIT && self.frame.size.width<400) || nowMode<MODE_LIST || nowMode>MODE_MEANS )
    nowMode = MODE_LIST;
  
  [self ShowInMode:nowMode Animate:FALSE];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)TogglePanel
  {
  int nowMode = _Mode+1;
  
  if( nowMode == MODE_SPLIT && self.frame.size.width<400 )
    nowMode = MODE_MEANS;
  
  if( nowMode<MODE_LIST || nowMode>MODE_MEANS )
    nowMode = MODE_LIST;
  
  [self ShowInMode:nowMode Animate:TRUE];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Actualiza el modo de mostrar los datos del diccionario y la interface de usuario asocida a el
- (void) UpdateMode:(int) newMode
  {
  _Mode = newMode;
  
  int setAct = 0;  int desAct = 0;
  
  int ActSpit = CMD_SPLIT; int desSpit = 0;
  if( self.frame.size.width<400 ) { ActSpit = 0; desSpit = CMD_SPLIT; }

  int ActDel = CMD_DEL_MEANS; int desDel = 0;
  if( !Ctrller.CountOfMeans ) { ActDel = 0; desDel = CMD_DEL_MEANS; }

  int ActAll = CMD_ALL_MEANS; int desAll = 0;
  if( !Ctrller.CountFoundWord ) { ActAll = 0; desAll = CMD_ALL_MEANS; }

  switch (_Mode)
    {
    case MODE_LIST:
      setAct = CMD_MEANS | ActAll | ActSpit;
      desAct = CMD_WRDS  | CMD_DEL_MEANS | desAll | desSpit;
      break;
    case MODE_MEANS:
      setAct = CMD_WRDS  | ActDel | ActSpit;
      desAct = CMD_MEANS | CMD_ALL_MEANS | desDel | desSpit;
      break;
    case MODE_SPLIT:
      setAct = CMD_MEANS | CMD_WRDS | ActDel | ActAll;
      desAct = CMD_SPLIT | desDel | desAll;
      break;
    }

  DictCmdBarEnable( setAct );
  DictCmdBarDisable( desAct );
  DictCmdBarRefresh();
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)ShowInMode:(int) mode Animate:(BOOL) anim
  {
  //if( mode== _Mode ) return;
  
  CGFloat  w = self.frame.size.width;
  CGRect rc1 = Panel1.frame;
  CGRect rc2 = Panel2.frame;

  switch( mode )
    {
    case MODE_LIST:
      rc1.origin.x = -w;
      Panel1.frame = rc1;
    
      rc1.origin.x = 0;
      rc2.origin.x = w;
      
      rc1.size.width = w;
      rc2.size.width = w;
      
      [self UpdateMode:MODE_LIST];
      break;
      
    case MODE_SPLIT:
      rc2.origin.x = rc1.origin.x + rc1.size.width;
      Panel2.frame = rc2;
    
      rc1.origin.x = 0;
      rc2.origin.x = w/2;
  
      rc1.size.width = w/2;
      rc2.size.width = w/2;
      
      [self UpdateMode:MODE_SPLIT];
      break;
      
    case MODE_MEANS:
      rc2.origin.x = rc1.origin.x + rc1.size.width;
      Panel2.frame = rc2;
    
      rc2.origin.x = 0;
      rc1.origin.x = -w;
      
      rc1.size.width = w;
      rc2.size.width = w;
      
      [self UpdateMode:MODE_MEANS];
      break;
    }
  
  if( anim )
    [UIView animateWithDuration:0.4
                   animations:^{
                               Panel1.frame = rc1;
                               Panel2.frame = rc2;
                               }];
  else
    {
    Panel1.frame = rc1;
    Panel2.frame = rc2;
    }
  
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Permite desplazar hacia el lado la ventana
- (void) OnGeture:(UIPanGestureRecognizer *)sender
  {
  if( _Mode == MODE_SPLIT ) return;
  
  CGRect rc1 = Panel1.frame;
  CGRect rc2 = Panel2.frame;
     
  if( sender.state == UIGestureRecognizerStateChanged )
     {
     CGFloat x = [sender translationInView: self.superview].x;
     
     if( _Mode == MODE_LIST )
       {
       rc1.origin.x = xIni + x;
       if( rc1.origin.x < 0 ) rc2.origin.x = rc1.origin.x + rc1.size.width;
       else                   rc2.origin.x = rc1.origin.x - rc2.size.width;
       }
     else
       {
       rc2.origin.x = xIni + x;
       if( rc2.origin.x < 0 ) rc1.origin.x = rc2.origin.x + rc2.size.width;
       else                   rc1.origin.x = rc2.origin.x - rc1.size.width;
       }

     Panel1.frame = rc1;
     Panel2.frame = rc2;
     }
  else if( sender.state == UIGestureRecognizerStateEnded )
     {
     CGFloat w = self.frame.size.width;
     CGFloat x = [sender translationInView: self.superview].x;
     
     CGFloat dx = (x<0)? -x : x;
     if( _Mode == MODE_LIST )
       {
       if( dx > w/2 )
          {
          rc2.origin.x = 0;
          rc1.origin.x = (x<0)? -w : w;
          
          [self UpdateMode:MODE_MEANS];
          }
       else
          {
          rc1.origin.x = 0;
          rc2.origin.x = (x<0)? w : -w;
          }
       }
     else
       {
       if( dx > w/2 )
          {
          rc1.origin.x = 0;
          rc2.origin.x = (x<0)? -w : w;
          
          [self UpdateMode:MODE_LIST];
          }
       else
          {
          rc2.origin.x = 0;
          rc1.origin.x = (x<0)? w : -w;
          }
       }
    
     [UIView animateWithDuration:0.15
                      animations:^{
                                  Panel1.frame = rc1;
                                  Panel2.frame = rc2;
                                  }];
    
     }
  
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  HideKeyboard();
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
