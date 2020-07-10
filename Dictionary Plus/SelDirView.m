//=========================================================================================================================================================
//  SelDirView.m
//  Dictionary Plus
//
//  Created by Admin on 16/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "SelDirView.h"
#import "AppData.h"
#import "DirPopUpView.h"

//=========================================================================================================================================================
@interface SelDirView ()
  {
  UIImageView* srcIcon;            // Bandera para el idioma fuente
  UILabel*     srcLabel;           // Descripcion del idioma fuente
  
  UIImageView* desIcon;            // Bandera del idioma destino
  UILabel*     desLabel;           // Descripción del idioma destino
  
  UIImageView* SwapIcon;           // Icono para el intercambio de idioma
  
  CGFloat X;                        // Posicion en la x de la vista de idiomas
  CGFloat Y;                        // Posicion en la y de la vista de idiomas
  CGFloat H;                        // Altura de la vista de idiomas
  CGFloat W;                        // Ancho de la vista de idiomas
  
  CGFloat yLb;                      // Posición en y de los labels
  CGFloat hLb;                      // Altura de los labels
  
  CGFloat wSrc;                     // Ancho del nombre del idioma fuente
  CGFloat wDes;                     // Ancho del nombre del idioma destino
  CGFloat wSwap;                    // Ancho del icono para intercambiar los idiomas
  CGFloat wIcon;                    // Ancho del icono del idioma
  }
@end

//=========================================================================================================================================================
@implementation SelDirView

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
  srcIcon  = self.subviews[0];
  srcLabel = self.subviews[1];
  SwapIcon = self.subviews[2];
  desIcon  = self.subviews[3];
  desLabel = self.subviews[4];
  
  
  X = self.frame.origin.x;
  Y = self.frame.origin.y;
  H = self.frame.size.height;
  
  yLb = srcLabel.frame.origin.y;
  hLb = srcLabel.frame.size.height;
  
  wIcon = srcIcon.frame.size.width;
  wSwap = SwapIcon.frame.size.width;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
  {
  [srcLabel sizeToFit];
  [desLabel sizeToFit];

  wSrc  = srcLabel.frame.size.width;                            // Ancho del nombre del idioma fuente
  wDes  = desLabel.frame.size.width;                            // Ancho del nombre del idioma destino
  
  CGFloat wDisp = self.superview.bounds.size.width - X - 55;    // Ancho disponible la vista que contiene los idiomas
  
  W = wIcon + wSrc + wSwap + wIcon + wDes ;                     // Tamaño normal
  if( W>wDisp )                                                 // Si no cabe en el espacio disponible
    {
    srcLabel.hidden = TRUE;                                     // Oculta los nombres de los idiomas
    desLabel.hidden = TRUE;

    wSrc = 0;                                                   // Pone anchos a 0
    wDes = 0;
    
    W = wIcon + wSwap + wIcon;                                  // Recalcula el ancho
    }
  else
    {
    srcLabel.hidden = FALSE;                                    // Garantiza que se muestren los nombres de idioma
    desLabel.hidden = FALSE;
    }
  
  CGFloat x = 0;
  srcIcon.frame = CGRectMake(x, 0, wIcon, H);
  x += wIcon;
  
  srcLabel.frame = CGRectMake(x, yLb, wSrc, hLb);
  x += wSrc;
  
  SwapIcon.frame = CGRectMake(x, 0, wSwap, H);
  x += wSwap;

  desIcon.frame = CGRectMake(x, 0, wIcon, H);
  x += wIcon;
  
  desLabel.frame = CGRectMake(x, yLb, wDes, hLb);
  x += wDes;
  
  W = x;
 // self.frame = CGRectMake(X, Y, W, H);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone los idiomas fuente y destino del diccionario
- (void)SetDictWithSrc:(int) src AndDes:(int) des
  {
  if( ![Ctrller LoadDictWithSrc:src AndDes:des] )
    return;
  
  NSCharacterSet *sp = [NSCharacterSet whitespaceCharacterSet];
  
  srcIcon.image = [UIImage imageNamed: LGFlagName(src) ];
  srcLabel.text = [LGName(src) stringByTrimmingCharactersInSet:sp];
  
  desIcon.image = [UIImage imageNamed: LGFlagName(des) ];
  desLabel.text = [LGName(des) stringByTrimmingCharactersInSet:sp];
  
  LGSrc = src;
  LGDes = des;
  
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
  if( pnt.y<=5 || pnt.y>=45  ) return;

  CGRect rc = SwapIcon.frame;
  
  if( CGRectContainsPoint(rc, pnt) ) [self SwapLanguajes];
  else [self SelSrcLanguajes];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Intercambia los idiomas fuentes y destinos
- (void)SwapLanguajes
  {
  CGRect rcIcn1 = srcIcon.frame;
  CGRect rcTxt1 = srcLabel.frame;
  
  CGRect rcSwap = SwapIcon.frame;

  CGRect rcIcn2 = desIcon.frame;
  CGRect rcTxt2 = desLabel.frame;

  rcIcn2.origin.x = 0;
  rcTxt2.origin.x = wIcon;
  
  CGFloat x = wIcon + wDes;
  rcSwap.origin.x = x;
  rcIcn1.origin.x = x + wSwap;
  rcTxt1.origin.x = x + wSwap + wIcon;

  [UIView animateWithDuration:0.5 animations:^{
    srcIcon.frame  = rcIcn1;
    srcLabel.frame = rcTxt1;

    SwapIcon.frame = rcSwap;
    
    desIcon.frame  = rcIcn2;
    desLabel.frame = rcTxt2;
    }
  completion:^(BOOL finished) {
    [self SetDictWithSrc:LGDes AndDes:LGSrc];
  }];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Seleciona el idioma fuente
- (void)SelSrcLanguajes
  {
  int iDir = DIRFromLangs( LGSrc, LGDes );
  
  DirPopUpView* PopUp = [[DirPopUpView alloc] initWithRefView:srcIcon AtLeft:TRUE DeltaX:0 DeltaY:-10];
  [PopUp ShowWithDir:iDir CallBack:@selector(SelectedLang:) Target:self];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se selecciona un idioma
- (void) SelectedLang:(DirPopUpView *) PopUp
  {
  int newDir = PopUp.SelectedDir;
  if( newDir==-1 ) return;
  
  int iSrc = DIRSrc(newDir);
  int iDes = DIRDes(newDir);

  [self SetDictWithSrc:iSrc AndDes:iDes];
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
