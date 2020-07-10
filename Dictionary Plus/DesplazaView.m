//
//  DesplazaView.m
//  Dictionary Plus
//
//  Created by Admin on 14/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//

#import "DesplazaView.h"

@interface DesplazaView ()
  {
  CGFloat xCent;
  CGFloat yCent;
  }
@end

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
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
  {
  CGFloat w = self.superview.frame.size.width;
  CGRect rc = self.frame;
  rc.size.width = 2*w;
  
  rc.origin.x = (rc.origin.x<0)? -w : 0;
  self.frame = rc;

  NSUInteger nViews = self.subviews.count;
  
  if( nViews>=1 )
    {
    CGRect rc1 = CGRectMake(0, 0, w, rc.size.height);
    self.subviews[0].frame = rc1;
    }
  
  if( nViews>=2 )
    {
    CGRect rc1 = CGRectMake(w, 0, w, rc.size.height);
    self.subviews[1].frame = rc1;
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Permite desplazar hacia el lado la ventana
- (void) OnGeture:(UIPanGestureRecognizer *)sender
  {
  if( sender.state == UIGestureRecognizerStateBegan )
     {
     CGPoint pnt = self.center;

     xCent = pnt.x;
     yCent = pnt.y;
     }
  else if( sender.state == UIGestureRecognizerStateChanged )
     {
     CGFloat x = xCent + [sender translationInView: self.superview].x;
     CGFloat w = self.superview.frame.size.width;
     
     if( x>=0 && x<=w )
       self.center = CGPointMake( x, yCent);
     }
  else if( sender.state == UIGestureRecognizerStateEnded )
    {
     CGFloat x = [sender translationInView:self.superview].x;
     CGFloat w = self.superview.frame.size.width;

     CGFloat desp = (x<0)? -x : x;
    
     if( desp > w/2 )
       xCent = ( x<0 )? 0 : w;
    
     [UIView animateWithDuration:0.5
                      animations:^{
                                  self.center = CGPointMake(xCent, yCent);
                                  }];
    
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
