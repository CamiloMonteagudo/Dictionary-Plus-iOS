//===================================================================================================================================================
//  DatosView.m
//  MultiDict
//
//  Created by Camilo Monteagudo Peña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import "DatosView.h"
#import "ZoneDatosView.h"
//#import "MarkView.h"
#import "EntryDesc.h"
//#import "ConjCore.h"
//#import "BtnsData.h"


//===================================================================================================================================================
// Editor personalizado para saber cuando se selecciona una zona de datos
@interface MyEdit : UITextView
@end

@implementation MyEdit

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  [ZoneDatosView SelectDatos: (DatosView*)self.superview];
  }

@end

//===================================================================================================================================================
// Vista para mostrar los datos de una entrada en el diccionario
@interface DatosView()
  {
  MyEdit* Text;                                     // Texto de la tradución

  UIView* SustBox;                                  // Recuadro donde se pone los datos de sustitución de palabras

  EntryDesc* Entry;                                 // Descripcion de la entrada en el diccionario

//  NSMutableArray<MarkView*> *Marks;               // Controles para cambiar las marcas

  CGFloat wSustData;                                // Contiene el mayor ancho de los datos de los textos de sustitución en la entrada
  }

@end

//===================================================================================================================================================
@implementation MarkNum
  
//--------------------------------------------------------------------------------------------------------------------------------------------------------
 // Crea objeto con los datos de la entrada 'Idx' en el diccionario actual
+ (MarkNum*) Create
  {
  MarkNum* obj = [MarkNum new];
  
  obj.Count = 1;
  obj.Now   = 1;
  
  return obj;
  }
  
@end

//===================================================================================================================================================
// Vista donde se ponen los datos de una palabra
@implementation DatosView

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea objeto con los datos de la entrada 'Idx' en el diccionario actual
+ (DatosView*) DatosForIndex:(NSInteger) Idx
  {
  EntryDict* Entry = [Dict getDataAt: Idx];                       // Obtiene los datos de la entrada en el diccionario general

  return [DatosView DatosForEntry:Entry Src:LGSrc Des:LGDes];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea objeto con los datos de la entrada 'Idx'
+ (DatosView*) DatosForEntry:(EntryDict*) Entry Src:(int)src Des:(int)des
  {
  DatosView* Datos = [[DatosView alloc] init];                    // Crea vista de datos nueva
  Datos.src = src;
  Datos.des = des;

  Datos.backgroundColor = [UIColor clearColor];
  [Datos CreateTextWithEntry:Entry];                              // Crea e inicializa los controles

  [Datos.superview setNeedsLayout];

  return Datos;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Hace que el sistema de cordenada sea el normal
- (BOOL)isFlipped
  {
  return YES;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea todas las subviews que van dentro de la zona de datos
- (void) CreateTextWithEntry:(EntryDict *) entry
  {
  Text = [[MyEdit alloc] init];                                   // TextView para poner la descricción de los datos

  Text.backgroundColor = [UIColor clearColor];                    // Pone color trasparente (Se usa el fondo de DatosView)
  Text.editable = FALSE;                                          // Pone que el texto no se puede editar
  Text.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);

  Entry = [EntryDesc DescWithEntry:entry Src:_src Des:_des];

  [Text.textStorage setAttributedString: [Entry getAttrString]];  // Le pone el contenido al TextView
  [self addSubview:Text];                                         // Adiciona el TextView a DatosView

  Text.delegate = self;                                           // Pone este objeto como delegado del Textview

  _HasSustMarks = (Entry.nMarks>0);                                     // Pone si tiene marcas de sustitución o no
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Ocurre cada vez que se cambia la selección del texto
- (void)textViewDidChangeSelection:(NSNotification *)notification
  {
  [self CheckSelectedData];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la palabra seleccionada y el idioma
- (void) CheckSelectedData
  {
  DatosView* selDatos = (DatosView*)[ZoneDatosView SelectedDatos];
  if( !selDatos ) return;
  
//  NSButton* bntCj = BtnsData.BtnConjWord;
//  NSButton* bntFw = BtnsData.BtnFindWord;
//  
//  bntCj.hidden = true;
//  bntFw.title = @"";
//  bntFw.hidden = true;
//  
//  int lang;
//  NSString* selTxt = [self getSelWordAndLang:&lang];
//  if( selTxt.length==0 ) return;
//  
//  if( [ConjCore IsVerbWord:selTxt InLang:lang] )
//    {
//    bntCj.hidden = false;
//    }
//  
//  if( lang==_des && [selTxt rangeOfCharacterFromSet:wrdSep].location == NSNotFound )
//    {
//    bntFw.title = LGFlag(selDatos.src);                                 // Pone la bandera del idioma
//    bntFw.hidden = false;
//    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la palabra seleccionada y el idioma
- (NSString*) getSelWordAndLang:(int *)lang
  {
  NSRange rg = Text.selectedRange;                                     // Obtiene el rango selecciondo
  if( rg.length==0 ) return @"";                                       // Si hay no hace nada

  NSString* selTxt = [Text.text substringWithRange:rg];              // Obtiene el texto seleccionado
  
  selTxt = [selTxt stringByReplacingOccurrencesOfString:LGFlag(_src) withString:@"" ];      // Quita las banderitas
  selTxt = [selTxt stringByReplacingOccurrencesOfString:LGFlag(_des) withString:@"" ];

  NSInteger iDes   = [Entry IndexTrdInString:Text.text];               // Obtiene el indice donde comienza la traducción
  *lang = ( rg.location>iDes )? _des: _src;                            // Determina el idioma del texto seleccionado
  
  return selTxt;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Copia el texto seleccionado o la traducción al portapapeles
- (void) CopyText
  {
  NSString* Txt;                                                        // Texto a copiar
  
  NSRange rg = Text.selectedRange;                                      // Obtiene el rango selecciondo
  if( rg.length==0 )                                                    // No hay texto seleccionado
    {
    NSInteger iDes = [Entry IndexTrdInString:Text.text];             // Obtiene el indice donde comienza la traducción
    if( iDes<=0 ) return;
    
    rg = NSMakeRange(iDes, Text.text.length-iDes);                    // Rango de donde empieza la traducción hasta el final
    }
  
  Txt = [Text.text substringWithRange:rg];                            // Obtiene el texto a copiar
  
  Txt = [Txt stringByReplacingOccurrencesOfString:LGFlag(_src) withString:@"" ];      // Quita las banderitas
  Txt = [Txt stringByReplacingOccurrencesOfString:LGFlag(_des) withString:@"" ];
  
//  NSPasteboard *gpBoard = [NSPasteboard generalPasteboard];             // Obtiene ep pasteboard
//  
//  [gpBoard clearContents];                                              // Limpia el contenido anterior
//  
//  [gpBoard writeObjects: @[Txt] ];                                      // Escribe el objeto
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando los datos son seleccionados
- (void) SelectedDatos
  {
//  [BtnsData BtnsDataForView:self];
  
  [self CheckSelectedData];
  
  [self setNeedsDisplay];
  [self.superview setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando los datos son deseleccionados los seleccionados
- (void) UnSelectedDatos
  {
  [self setNeedsDisplay];
//  [BtnsData HideButtons];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Muestra/Oculta los controles de sustitución
- (void) SustWords
  {
  if( _HSustMarks==0 ) [self CreateSustBoxView ];
  else                 _HSustMarks = -_HSustMarks;

  [ZoneDatosView SelectDatos:self];
  
  [self.superview setNeedsLayout];
  }

static NSCharacterSet * Nums = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
  
//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea un recuadro con los controles de sustitución de marcadores
- (void) CreateSustBoxView
  {
//  NSRect frm = NSMakeRect(0,0, 30, 300 );
//
//  SustBox = [[NSBox alloc] initWithFrame:frm];
//  SustBox.title = NSLocalizedString(@"Sustituciones", nil);
//
//  [self addSubview:SustBox];
//
//  Marks = [NSMutableArray<MarkView*> new];
//
//  _HSustMarks = 23;                                               // Altura minima del recuadro para sustitución
//  wSustData = 0;                                                  // Ancho maximo para las vistas con datos de sustitución
//  
//  NSMutableDictionary<NSString*,MarkNum*>* dicNum = [self GetNumMarkInfo];
//  
//  for( int i=0; i<Entry.nMarks; ++i )
//    {
//    InfoMark* info = [Entry MarkAtIndex:i];
//    MarkNum*   mrk = dicNum[ [info.Code stringByTrimmingCharactersInSet:Nums] ];
//
//    MarkView* view = [MarkView CreateWithMark: info.Code MarkNum:mrk InView:self];
//
//    [SustBox addSubview:view];
//
//    [Marks addObject:view];
//
//    if( view.frame.size.width > wSustData )
//      wSustData = view.frame.size.width;
//    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la información sobre el numero de marcas de cada tipo
- (NSMutableDictionary<NSString*,MarkNum*>*) GetNumMarkInfo
  {
  NSMutableDictionary<NSString*,MarkNum*>* dicNum = [NSMutableDictionary<NSString*,MarkNum*> new];
  for( int i=0; i<Entry.nMarks; ++i )
    {
    InfoMark* info = [Entry MarkAtIndex:i];
    NSString* Cod  = [info.Code stringByTrimmingCharactersInSet:Nums];
    
    MarkNum* mrk = dicNum[Cod];
    
    if( mrk== nil ) dicNum[Cod] = [MarkNum Create];
    else            ++mrk.Count;
    }
  
  return dicNum;
  }
  
//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el texto para la marca de sustitución 'code' en la llave de la entrada
- (NSString*) TextInKeyForMark:(NSString*) code
  {
  return [Entry TextInKeyForMark: code];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el texto para la marca de sustitución 'code' en los datos de la entrada
- (NSString*) TextInDataForMark:(NSString*) code
  {
  return [Entry TextInDataForMark: code];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Sustituye la marca 'code' con el texto 'srcTxt' en la llave y 'desTxt' en los datos
- (void) ResplaceMark:(NSString*) code TextSrc:(NSString*) srcTxt TextDes:(NSString*) desTxt
  {
  [Entry ResplaceMark:code TextSrc:srcTxt TextDes:desTxt];

  [Text.textStorage setAttributedString: [Entry getAttrString]];  // Le pone el contenido al TextView

  [self.superview setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Reorganiza todas las subvistas dentro de la zona de datos
- (CGFloat) ResizeWithWidth:(CGFloat) w
  {
  w -= (2*SEP);

  CGFloat y = 8;                                            // Altura donde va la proxima vista

  CGSize sz = [Text sizeThatFits: CGSizeMake(w, 4000)];     // Calcula el tamaño que va a ocupar el texto
  
  Text.frame = CGRectMake( 0, y, w, sz.height+0.5 );        // Pone el tamaño y posición del TextView
  y += sz.height + 8 ;

//  if( Entry.nMarks>0  )                                     // Si hay marcas
//    [self SustButtonPositionX:w Y:y];                       // Posiciona el boton para sustituir las marcas

  if( _HSustMarks>0 )                                       // Si hay controles de sustitución
    {
//    [self ResizeSustBoxWidth:w AndPos:y];                   // Redimensiona cuadro de sustitución completo
//
//    y += _HSustMarks + SEP;                                 // Avanza la y en la altura de recuadro
    SustBox.hidden = false;                                 // Muestra el recuadro de sustitución
    }
  else                                                      // Si no hay controles de sustitución
    SustBox.hidden = true;                                  // Oculta el recuadro de sustitución

//  if( self==ZoneDatosView.SelectedDatos )                   // Si es el dato seleccionado
//    {
//    y+= 20;                                                 // Crece la altura en 20 pixeles
//    }
  
  y += SEP;                                                 // Separación entre los datos
  self.frame = CGRectMake(SEP, 0, w, y);                    // Rectangulo para el recuadro de datos
  
  [self setNeedsDisplay];
  return y;
  }

////--------------------------------------------------------------------------------------------------------------------------------------------------------
//// Posiciona correctamente el boton de mostrar/ocultar el botón de sustituicón de marcas
//- (void) SustButtonPositionX:(CGFloat)x Y:(CGFloat) y
//  {
//  [btnSust setFrameOrigin: NSMakePoint(x-WBTNS-SEP, y-HBTNS) ];   // Mueve el boton
//
//  if( HSust>0 ) btnSust.image = imgCloseSust;                 // Si el cuadro de sustitución esta visible, pone icon de ocultar
//  else          btnSust.image = imgOpenSust;                  // Si el cuadro de sustitución esta oculto, pone icon de mostrar
//  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Redimenciona el recuadro con los controles de sustitución de marcas de acuerdo al ancho disponible
- (void) ResizeSustBoxWidth:(CGFloat) w AndPos:(CGFloat) yPos
  {
//  int nCols = (w+SEP)/(wSustData+SEP);                      // Número de columnas de datos a mostrar para al ancho dado
//  if( nCols==0 ) nCols = 1;                                 // Cuando los datos no caben en una columna
//
//  int nRows = ((int)Marks.count+(nCols-1))/nCols;           // Número de filas de datos a mostrar
//
//  CGFloat x, y = SEP + nRows*(HSUST_DATA+SEP);              // Altura superior de la zona de datos
//
//  _HSustMarks = y + 23;                                     // Altura del recuadro de todos los datos
//  SustBox.frame = NSMakeRect(SEP, yPos, w, _HSustMarks );   // Posiciona y posiciona el recuadro de datos
//
//  int i = 0;                                                // Inidice del dato a posicionar
//  for( int row=0; row<nRows; ++row )                        // Recorre todas la filas de datos
//    {
//    y -= (HSUST_DATA+SEP);                                  // Define la posición en y de los datos de la fila
//    x = 0;                                                  // Pone la x al inicio de la fila
//
//    for( int col=0; col<nCols; ++col )                      // Recorre la columna
//      {
//      if( i>=Marks.count ) break;                           // Si no hay datos por posicnar, termina
//
//      Marks[i++].FrameOrigin = NSMakePoint(x, y);           // Posiciona la vista y pasa al proximo dato
//
//      x += (wSustData+SEP);                                 // Avanza la posición en la x
//      }
//    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia la forma de los datos
- (void)layoutSubviews
  {
//  [self.superview setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Dibuja el fondo de la zona
- (void)drawRect:(CGRect)rect
  {
  CGRect rc = self.bounds;
  rc.size.height -= 2;

  UIColor* ColBody;
  UIColor* ColBrd = [UIColor darkGrayColor];
  
       if( self == [ZoneDatosView SelectedDatos] ) ColBody = SelColor;
  else if( _HasSustMarks                         ) ColBody = SustColor;
  else                                             ColBody = BackColor;

  DrawRoundRect( rc, ColBrd, ColBody );
  }

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// Dibuja el rectangulo 'rc' con bordes redondeados
void DrawRoundRect( CGRect rc, UIColor* ColBrd, UIColor* ColBody )
  {
  float RSup = 6;
  float RInf = 6;
  
  float xIzq = rc.origin.x;
  float xDer = xIzq + rc.size.width;

  float ySup = rc.origin.y;
  float yInf = ySup + rc.size.height;
  
  float ycSup  = ySup + RSup;
  float xcSupI = xIzq + RSup;
  float xcSupD = xDer - RSup;

  float ycInf  = yInf - RInf;
  float xcInfI = xIzq + RInf;
  float xcInfD = xDer - RInf;
  
  CGContextRef ct = UIGraphicsGetCurrentContext();
  
  CGContextSetStrokeColorWithColor(ct, ColBrd.CGColor);
  CGContextSetFillColorWithColor(ct, ColBody.CGColor);

  CGContextSetLineWidth(ct, 1);
  
  CGContextBeginPath(ct);
  
  CGContextMoveToPoint   (ct, xcSupI, ySup  );
  CGContextAddArc        (ct, xcSupI, ycSup , RSup, -M_PI_2, -M_PI  , 1 );
  CGContextAddLineToPoint(ct, xIzq  , ycInf );
  CGContextAddArc        (ct, xcInfI, ycInf , RInf, -M_PI  ,  M_PI_2, 1 );
  CGContextAddLineToPoint(ct, xcInfD, yInf );
  CGContextAddArc        (ct, xcInfD, ycInf , RInf, M_PI_2 ,  0     , 1 );
  CGContextAddLineToPoint(ct, xDer  , ycSup );
  CGContextAddArc        (ct, xcSupD, ycSup , RSup, 0      , -M_PI_2, 1 );
  
  if( RSup>0 ) CGContextClosePath(ct);
  
  CGContextDrawPath( ct, kCGPathFillStroke);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  [ZoneDatosView SelectDatos:self];
  }

@end

//===================================================================================================================================================
