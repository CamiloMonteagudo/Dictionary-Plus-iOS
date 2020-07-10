//=========================================================================================================================================================
//  SelLangsView.m
//  Dictionary Plus
//
//  Created by Admin on 16/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "SelLangsView.h"
#import "AppData.h"
#import "LangPopUpView.h"

//=========================================================================================================================================================
@interface SelLangsView ()
  {
  UIImageView* srcIcon;            // Bandera para el idioma fuente
  UILabel*     srcLabel;           // Descripcion del idioma fuente
  UIImageView* srcDwm;             // Icono para indicar que se puede seleccionar
  
  UIImageView* SwapIcon;           // Icono para el intercambio de idioma
  
  UIImageView* desIcon;
  UILabel*     desLabel;
  UIImageView* desDwm;
  
  CGFloat X;                        // Posicion en la x de la vista de idiomas
  CGFloat Y;                        // Posicion en la y de la vista de idiomas
  CGFloat H;                        // Altura de la vista de idiomas
  CGFloat W;                        // Ancho de la vista de idiomas
  
  CGFloat yLb;                      // Posición en y de los labels
  CGFloat hLb;                      // Altura de los labels
  
  CGFloat wIcon;                    // Ancho del icono del idioma
  CGFloat wDwn;                     // Ancho del icono para despazar hacia abajo
  CGFloat wSwap;                    // Ancho del icono para intercambiar los idiomas
  CGFloat wSrc;                     // Ancho del nombre del idioma fuente
  CGFloat wDes;                     // Ancho del nombre del idioma destino
  
  int lngSrc;
  int lngDes;
  }
@end

//=========================================================================================================================================================
@implementation SelLangsView

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
  lngSrc = -1;
  lngDes = -1;
  
  srcIcon  = self.subviews[0];
  srcLabel = self.subviews[1];
  srcDwm   = self.subviews[2];
  
  SwapIcon = self.subviews[3];
  
  desIcon  = self.subviews[4];
  desLabel = self.subviews[5];
  desDwm   = self.subviews[6];
  
  X = self.frame.origin.x;
  Y = self.frame.origin.y;
  H = self.frame.size.height;
  
  yLb = srcLabel.frame.origin.y;
  hLb = srcLabel.frame.size.height;
  
  wIcon = srcIcon.frame.size.width;
  wDwn  = srcDwm.frame.size.width;
  wSwap = SwapIcon.frame.size.width;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
  {
  [srcLabel sizeToFit];
  [desLabel sizeToFit];

  wSrc  = srcLabel.frame.size.width;                          // Ancho del nombre del idioma fuente
  wDes  = desLabel.frame.size.width;                          // Ancho del nombre del idioma destino
  
  CGFloat wDisp = self.superview.bounds.size.width - X - 55;   // Ancho disponible la vista que contiene los idiomas
  
  W = wIcon + wSrc + wDwn + wSwap + wIcon + wDes + wDwn;
  if( W>wDisp )
    {
    srcLabel.hidden = TRUE;
    desLabel.hidden = TRUE;

    W -= (wSrc + wDes);
    wSrc = 0;
    wDes = 0;
    }
  else
    {
    srcLabel.hidden = FALSE;
    desLabel.hidden = FALSE;
    }
  
  int wExtra = (wDisp - W) / 2;
  
  CGFloat x = 0;
  srcIcon.frame = CGRectMake(x, 0, wIcon, H);
  
  x += wIcon;
  srcLabel.frame = CGRectMake(x, yLb, wSrc, hLb);
  
  x += wSrc;
  srcDwm.frame = CGRectMake(x, 0, wDwn, H);

  x += (wDwn + wExtra);
  SwapIcon.frame = CGRectMake(x, 0, wSwap, H);
  
  x += (wSwap + wExtra);
  desIcon.frame = CGRectMake(x, 0, wIcon, H);
  
  x += wIcon;
  desLabel.frame = CGRectMake(x, yLb, wDes, hLb);
  
  x += wDes;
  desDwm.frame = CGRectMake(x, 0, wDwn, H);
  
  W = x + wDwn;
 // self.frame = CGRectMake(X, Y, W, H);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone los idiomas fuente y destino del diccionario
- (void)SetDictWithSrc:(int) src AndDes:(int) des
  {
  NSCharacterSet *sp = [NSCharacterSet whitespaceCharacterSet];
  
  srcIcon.image = [UIImage imageNamed: LGFlagName(src) ];
  srcLabel.text = [LGName(src) stringByTrimmingCharactersInSet:sp];
  
  desIcon.image = [UIImage imageNamed: LGFlagName(des) ];
  desLabel.text = [LGName(des) stringByTrimmingCharactersInSet:sp];
  
  lngSrc = src;
  lngDes = des;
  
  [self setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se pone el dedo sobre la vista
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  HideKeyboard();
  
//  CGSize sz = self.bounds.size;
//  
//  CGPoint pnt = [[touches anyObject] locationInView: self];     // Punto que se toco dentro de la vista
//
//       if( pnt.x < xSec1 ) Cover.frame = CGRectMake(    0, 0, xSec1         , sz.height);
//  else if( pnt.x > xSec2 ) Cover.frame = CGRectMake(xSec2, 0, sz.width-xSec2, sz.height);
//  else                     Cover.frame = CGRectMake(xSec1, 0, xSec2-xSec1   , sz.height);
//  
//  Cover.hidden = FALSE;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se levanta el dedo de la vista
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  CGPoint pnt = [[touches anyObject] locationInView: self];     // Punto que se toco dentro de la fila

  CGFloat MkSrc  = wIcon + wSrc + wDwn;
  CGFloat MkDes  = W - (wIcon + wDes + wDwn);
  
  CGRect rc = SwapIcon.frame;
  
       if( pnt.x < MkSrc ) [self SelSrcLanguajes];
  else if( pnt.x > MkDes ) [self SelDesLanguajes];
  else if( CGRectContainsPoint(rc, pnt) ) [self SwapLanguajes];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Intercambia los idiomas fuentes y destinos
- (void)SwapLanguajes
  {
  CGRect rc1 = srcIcon.frame;
  CGRect rc2 = srcLabel.frame;
  CGRect rc3 = srcDwm.frame;
  
  CGRect rc5 = desIcon.frame;
  CGRect rc6 = desLabel.frame;
  CGRect rc7 = desDwm.frame;

  rc5.origin.x = 0;
  rc6.origin.x = wIcon;
  rc7.origin.x = wIcon + wSrc;
  
  CGFloat x = W - (wIcon + wDes + wDwn);
  rc1.origin.x = x;
  rc2.origin.x = x + wIcon;
  rc3.origin.x = x + wIcon + wDes;

  [UIView animateWithDuration:0.5 animations:^{
    srcIcon.frame  = rc1;
    srcLabel.frame = rc2;
    srcDwm.frame   = rc3;
  
    desIcon.frame  = rc5;
    desLabel.frame = rc6;
    desDwm.frame   = rc7;
    }
  completion:^(BOOL finished) {
    [self SetDictWithSrc:lngDes AndDes:lngSrc];
  }];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Seleciona el idioma fuente
- (void)SelSrcLanguajes
  {
  LangPopUpView* PopUp = [[LangPopUpView alloc] initWithRefView:srcIcon AtLeft:TRUE DeltaX:0 DeltaY:-10];
  PopUp.tag = 0;
  [PopUp ShowWithLang:lngSrc CallBack:@selector(SelectedLang:) Target:self];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Seleciona el idioma destino
- (void)SelDesLanguajes
  {
  CGFloat leftSep = self.superview.bounds.size.width - desIcon.frame.origin.x;
  
  LangPopUpView* PopUp;
  if( leftSep>= 160 )
    PopUp = [[LangPopUpView alloc] initWithRefView:desIcon AtLeft:TRUE DeltaX:0 DeltaY:-10];
  else
    PopUp = [[LangPopUpView alloc] initWithRefView:desDwm AtLeft:FALSE DeltaX:0 DeltaY:-10];
  
  PopUp.tag = 1;
  [PopUp ShowWithLang:lngDes CallBack:@selector(SelectedLang:) Target:self];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se selecciona un idioma
- (void) SelectedLang:(LangPopUpView *) PopUp
  {
  int newLng = PopUp.SelectedLang;
  if( newLng==-1 ) return;
  
  if( PopUp.tag == 0 )
    {
    int newDes = (newLng==lngDes)? lngSrc : lngDes;
    [self SetDictWithSrc:newLng AndDes:newDes];
    }
  else
    {
    int newSrc = (newLng==lngSrc)? lngDes : lngSrc;
    [self SetDictWithSrc:newSrc AndDes:newLng];
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
