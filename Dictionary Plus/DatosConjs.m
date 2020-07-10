//===================================================================================================================================================
//  DatosConjs.m
//  MultiDict
//
//  Created by Camilo Monteagudo Peña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import "DatosConjs.h"
#import "ZoneDatosView.h"
#import "ConjCore.h"
#import "BtnsBarView.h"

//===================================================================================================================================================
// Vista para mostrar los datos de una entrada en el diccionario
@interface DatosConjs()
  {
  NSAttributedString* AttrStr;
  }

@end

//===================================================================================================================================================
// Vista donde se ponen los datos de una palabra
@implementation DatosConjs

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea objeto con el verbo y el idioma
+ (DatosConjs*) DatosForWord:(NSString *) wrd Lang:(int)lng;
  {
  DatosConjs* Datos = [[DatosConjs alloc] init];                    // Crea vista de datos nueva
  
  Datos.CellName = @"InfoConjCell";
  Datos.Lang = lng;
  Datos.Verb = wrd;
  
  return Datos;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la cadena con atributos que representa los significados de la palabra
- (NSAttributedString*) GetAttrStr
  {
  if( !AttrStr )
    {
    [ConjCore LoadConjLang: _Lang];                           // Carga la conjugación para el idioma actual

    if( [ConjCore ConjVerb:_Verb ] )                              // Si la palabra se puede conjugar
      {
      NSArray<NSString*> *lstWrds = [ConjCore GetConjsList];   // Obtiene la lista de palabras de la conjugacion
    
      AttrStr = [ConjCore GetConjList:lstWrds ForVerb:_Verb];
      }
    }
  
  return AttrStr;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando los datos son seleccionados
- (void) SelectedDatos
  {
  [self.Cell BckColor: SelColor];
  
  DataCmdBarDisable(CMD_ALL);
  DataCmdBarEnable(CMD_DEL_MEAN);
  
  UIView* view = self.Cell.contentView;
  CGFloat off  = view.frame.size.width - 50;
  
  DataCmdBarPosBottomView( view, off );
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando los datos son deseleccionados los seleccionados
- (void) UnSelectedDatos
  {
  [self.Cell BckColor: BackColor];
  
  if( DataCmdBarInView(self.Cell.contentView) )
    DataCmdBarPosBottomView( nil, 0 );
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Reorganiza todas las subvistas dentro de la zona de datos
- (CGFloat) ResizeWithWidth:(CGFloat) w
  {
  w -= (2*SEP);

  CGFloat y = 0;                                            // Altura donde va la proxima vista

  [self GetAttrStr];
  
  CGSize sz = CGSizeMake( w, 5000);
  CGRect rc = [AttrStr boundingRectWithSize:sz options:NSStringDrawingUsesLineFragmentOrigin context:nil ];
  
  _HText = (int)(rc.size.height+8);
  y += _HText;

//  if( self==ZoneDatosView.SelectedDatos )                   // Si es el dato seleccionado
    y+= 30;                                                 // Crece la altura en 20 pixeles
  
  return y;
  }

@end

//===================================================================================================================================================

//===================================================================================================================================================
// Celda en la tabla para representar los datos de un significado
@interface DatosConjsCell()
  {
  UILabel* Text;                                      // Texto con las conjugaciones
  UIButton* btnConj;                                  // Boton para llamar al conjugador
  }

@end

//===================================================================================================================================================
// Celda en la tabla para representar los datos de un significado
@implementation DatosConjsCell


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
  Text    = self.contentView.subviews[0];
  btnConj = self.contentView.subviews[1];
  
  [btnConj addTarget:self action:@selector(OnCmdBtn:) forControlEvents:UIControlEventTouchUpInside];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime un boton
- (void)OnCmdBtn:(UIButton *)btn
  {
  NSString* Verb = ((DatosConjs*)self.Datos).Verb;
  int       Lang = ((DatosConjs*)self.Datos).Lang;
  
  [Ctrller  GoToConjVerb:Verb Lang:Lang];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Inicializa la celda para mostrar los datos especificados
- (void) UseWithInfoDatos:(DatosConjs*) datos
  {
  datos.Cell = self;
  self.Datos = datos;
  
  Text.attributedText = [datos GetAttrStr];
  
  CGRect rc = Text.frame;
  rc.size.height = datos.HText;
  
  Text.frame = rc;
  
  if( datos == ZoneDatosView.SelectedDatos ) [datos SelectedDatos];
  else                                       [datos UnSelectedDatos];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Inicializa la celda para mostrar los datos especificados
- (void) BckColor:(UIColor*) col
  {
  Text.backgroundColor = col;
  self.backgroundColor = col;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  [ZoneDatosView SelectDatos: self.Datos];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------

@end

//===================================================================================================================================================












