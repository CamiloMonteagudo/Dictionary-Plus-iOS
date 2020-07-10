//=========================================================================================================================================================
//  DesplazaView.m
//  Dictionary Plus
//
//  Created by Admin on 14/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "DesplazaView.h"
#import "AppData.h"

//=========================================================================================================================================================
@interface DesplazaView ()
  {
  UIView* Panel1;
  UIView* Panel2;

  CGFloat xIni;

//  int nowPanel;
  int viewMode;                // 0 -Listado de palabras 1 -Pantalla dividida 2 - Significados
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
  // Crea un gesto para ocultar o mostrar el nombre de idioma para ganar espacio
  UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(OnGeture:)];
  [self addGestureRecognizer:gesture];
  
  Panel1 = self.subviews[0];
  Panel2 = self.subviews[1];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
  {
  if( viewMode==1 && self.frame.size.width<400 )
    viewMode=0;
  
  [self ShowInMode:viewMode Animate:FALSE];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)TogglePanel
  {
  int nowMode = ++viewMode;
  
  if( nowMode==1 && self.frame.size.width<400 )
    ++nowMode;
  
  if( nowMode>2 ) nowMode = 0;
  
  [self ShowInMode:nowMode Animate:TRUE];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)ShowInMode:(int) mode Animate:(BOOL) anim
  {
  CGFloat  w = self.frame.size.width;
  CGRect rc1 = Panel1.frame;
  CGRect rc2 = Panel2.frame;

  switch( mode )
    {
    case 0:
      rc1.origin.x = -w;
      Panel1.frame = rc1;
    
      rc1.origin.x = 0;
      rc2.origin.x = w;
      
      rc1.size.width = w;
      rc2.size.width = w;
      
      viewMode = 0;
      break;
      
    case 1:
      rc2.origin.x = rc1.origin.x + rc1.size.width;
      Panel2.frame = rc2;
    
      rc1.origin.x = 0;
      rc2.origin.x = w/2;
  
      rc1.size.width = w/2;
      rc2.size.width = w/2;
      
      viewMode = 1;
      break;
      
    case 2:
      rc2.origin.x = rc1.origin.x + rc1.size.width;
      Panel2.frame = rc2;
    
      rc2.origin.x = 0;
      rc1.origin.x = -w;
      
      rc1.size.width = w;
      rc2.size.width = w;
      
      viewMode = 2;
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
  if( viewMode==1 ) return;
  
  CGRect rc1 = Panel1.frame;
  CGRect rc2 = Panel2.frame;
     
  if( sender.state == UIGestureRecognizerStateChanged )
     {
     CGFloat x = [sender translationInView: self.superview].x;
     
     if( viewMode==0 )
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
     if( viewMode==0 )
       {
       if( dx > w/2 )
          {
          rc2.origin.x = 0;
          rc1.origin.x = (x<0)? -w : w;
          viewMode = 2;
          }
       else
          {
          rc1.origin.x = 0;
          rc2.origin.x = (x<0)? w : -w;
          viewMode = 0;
          }
       }
     else
       {
       if( dx > w/2 )
          {
          rc1.origin.x = 0;
          rc2.origin.x = (x<0)? -w : w;
          viewMode = 0;
          }
       else
          {
          rc2.origin.x = 0;
          rc1.origin.x = (x<0)? w : -w;
          viewMode = 2;
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
