//=========================================================================================================================================================
//  SelLangView.m
//  Dictionary Plus
//
//  Created by Admin on 16/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "SelLangView.h"
#import "AppData.h"
#import "LangPopUpView.h"

//=========================================================================================================================================================
@interface SelLangView ()
  {
  UIImageView* Icon;                // Bandera para el idioma fuente
  UILabel*     Label;               // Descripcion del idioma fuente
  UIImageView* Dwm;                 // Icono para indicar que se puede seleccionar
  
  CGFloat X;                        // Posicion en la x de la vista de idiomas
  CGFloat Y;                        // Posicion en la y de la vista de idiomas
  CGFloat H;                        // Altura de la vista de idiomas
  
  CGFloat yLb;                      // Posición en y de los labels
  CGFloat hLb;                      // Altura de los labels
  
  CGFloat wIcon;                    // Ancho del icono del idioma
  CGFloat wDwn;                     // Ancho del icono para despazar hacia abajo
  CGFloat wSrc;                     // Ancho del nombre del idioma fuente
  }
@end

//=========================================================================================================================================================
@implementation SelLangView

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
  Icon  = self.subviews[0];
  Label = self.subviews[1];
  Dwm   = self.subviews[2];
  
  X = self.frame.origin.x;
  Y = self.frame.origin.y;
  H = self.frame.size.height;
  
  yLb = Label.frame.origin.y;
  hLb = Label.frame.size.height;
  
  wIcon = Icon.frame.size.width;
  wDwn  = Dwm.frame.size.width;
  
  _WView = self.frame.size.width;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
  {
  [Label sizeToFit];
  
  CGFloat x = 0;
  Icon.frame = CGRectMake(x, 0, wIcon, H);
  x += wIcon;

  if( !_HideName )
    {
    wSrc  = Label.frame.size.width;                          // Ancho del nombre del idioma fuente
    Label.frame = CGRectMake(x, yLb, wSrc, hLb);
    x += wSrc;
    }
  
  Dwm.frame = CGRectMake(x, 0, wDwn, H);
  _WView = x + wDwn;
  
  if( _WView != self.frame.size.width )
    if(_Delegate ) [_Delegate OnSelLangChagedSize:self];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se pone el dedo sobre la vista
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  HideKeyboard();
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se levanta el dedo de la vista
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  LangPopUpView* PopUp = [[LangPopUpView alloc] initWithRefView:Icon AtLeft:NO DeltaX:0 DeltaY:-10];
  [PopUp ShowWithLang:_SelLang CallBack:@selector(SelectedLang:) Target:self];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se selecciona un idioma
- (void) SelectedLang:(LangPopUpView *) PopUp
  {
  int newLng = PopUp.SelectedLang;
  if( newLng==-1 ) return;
  
  [self setSelLang:newLng];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone el idioma para la conjugación
- (void)setSelLang:(int) lang
  {
  NSCharacterSet *sp = [NSCharacterSet whitespaceCharacterSet];
  
  Icon.image = [UIImage imageNamed: LGFlagName(lang) ];
  Label.text = [LGName(lang) stringByTrimmingCharactersInSet:sp];
  
  _SelLang = lang;
  
  [self setNeedsLayout];
  
  if( _Delegate ) [_Delegate OnSelLang:self];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Oculta el nombre del idioma
- (void)setHideName:(BOOL)HideName
  {
  if( HideName == _HideName ) return;

  _HideName = HideName;
  Label.hidden = HideName;
  [self setNeedsLayout];
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
