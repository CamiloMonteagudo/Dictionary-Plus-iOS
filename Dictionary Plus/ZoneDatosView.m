//===================================================================================================================================================
//  ZoneDatosView.m
//  MultiDict
//
//  Created by Camilo Monteagudo Peña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import "ZoneDatosView.h"
#import "AppData.h"
#import "BtnsBarView.h"
//#import "BuyMsgView.h"

static DatosViewBase* DatosSel;
//===================================================================================================================================================
// Sirve de base para todas las vistas que va a aparecer en la zona de datos
@implementation DatosViewBase

- (void) SelectedDatos {}
- (void) UnSelectedDatos {}

- (CGFloat) ResizeWithWidth:(CGFloat) w { return 0;}

@end

//===================================================================================================================================================
// Zona donde se muestran los datos de las palabras
@implementation ZoneDatosView

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Retorna la cantidad de datos que hay en la zona
- (int)Count
  {
  return (int)self.subviews.count;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona los datos de la palabra 'Idx' en la parte superior de la zona de datos de palabras
- (void) AddDatos:(DatosViewBase*) Datos;
  {
  DictCmdBarEnable(CMD_DEL_MEANS);
  DictCmdBarRefresh();
  
  [ZoneDatosView SelectDatos:Datos];

  UIScrollView* parent = (UIScrollView*)self.superview;
  [parent setContentOffset:CGPointMake(0, 0)];                        // Pone el scroll en el primer iten de la lista

  [self addSubview:Datos];                                           // Adiciona vista de datos nueva
  [self setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Inserta los datos de la entrada suministrada después de la vista seleccionada
- (void) AddDatosAfterSel:(DatosViewBase*) Datos;
  {
  [self insertSubview:Datos belowSubview:DatosSel];                             // Adiciona vista de datos nueva
  [self setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Reposiciona todos las vistas de datos aduadamente
- (void) ClearDatos
  {
  NSInteger n = self.subviews.count;
  for( NSInteger i=n-1; i>=0; --i)
    [self.subviews[i] removeFromSuperview];

  CGFloat w = self.superview.bounds.size.width;                       // Ancho del contenido del scroll
  self.frame = CGRectMake(0, 0, w, 20);                               // Redimensiona la zona de datos
  
  DictCmdBarDisable(CMD_DEL_MEANS);
  DictCmdBarRefresh();
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el alto de todas las vistas de datos existentes
- (NSInteger) HeightDatos
  {
  NSInteger h = 5;
  NSInteger n = self.subviews.count;
  for( NSInteger i=0; i<n; ++i)
    {
    UIView* sub = self.subviews[i];
    h += sub.frame.size.height;
    }

  return h;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Inserta la altura 'h' en la parte superior de todas las subvistas
- (NSInteger) InsertInTopHeight:(CGFloat) h
  {
  NSInteger n = self.subviews.count;
  for( NSInteger i=0; i<n; ++i)
    {
    UIView* sub = self.subviews[i];

    CGRect rc = sub.frame;
    rc.origin.y += h;
    sub.frame = rc;
    }

  return h;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Redimensiona todos los controles de datos cada vez que cambia el tamaño del scroll
- (void)layoutSubviews
  {
  UIScrollView* parent = (UIScrollView*)self.superview;
  CGFloat w = parent.bounds.size.width;                       // Ancho del contenido del scroll
  CGFloat h = 0;

  NSInteger n = self.subviews.count;
  for( NSInteger i=n-1; i>=0; --i)
    {
    UIView* Sub  = self.subviews[i];
    
    CGFloat hSub = [(DatosViewBase*)Sub ResizeWithWidth:w];
    
    CGRect rc = Sub.frame;
    rc.origin = CGPointMake( 4, h);
    Sub.frame = rc;

    h += hSub;
    }

  self.frame = CGRectMake(0, 0, w, h);                                // Redimensiona la zona de datos
  [parent setContentSize: CGSizeMake(w, h)];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone los datos identificados por 'view' como datos seleccionados
+(void) SelectDatos:(DatosViewBase*) view
  {
  if( DatosSel!=nil ) [DatosSel UnSelectedDatos];
  
  DatosSel = view;
  HideKeyboard();

  if( view!=nil ) [view SelectedDatos];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Retorna la vista de los datos seleccionados
+(DatosViewBase*) SelectedDatos
  {
  return DatosSel;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Borra los datos seleccionados
- (void) DeleteSelectedDatos
  {
  NSInteger n = self.subviews.count;
  DatosViewBase* next = nil;

  for( NSInteger i=0; i<n; ++i)
    {
    DatosViewBase* sub = self.subviews[i];
    if( sub == DatosSel )
      {
      if( i>0      ) next = self.subviews[i-1];
      else if( n>1 ) next = self.subviews[i+1];
      }
    }

  [DatosSel removeFromSuperview];

  [ZoneDatosView SelectDatos:next];

  [self setNeedsLayout];

  if( self.subviews.count == 0 )
    {
    DictCmdBarDisable(CMD_DEL_MEANS);
    DictCmdBarRefresh();
    }
  }

@end
//===================================================================================================================================================
