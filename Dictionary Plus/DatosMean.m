//===================================================================================================================================================
//  DatosMean.m
//  MultiDict
//
//  Created by Camilo Monteagudo Peña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import "DatosMean.h"
#import "ZoneDatosView.h"
//#import "MarkView.h"
#import "EntryDesc.h"
#import "ConjCore.h"
#import "BtnsBarView.h"

static NSCharacterSet * Nums = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
  
//===================================================================================================================================================
// Editor personalizado para saber cuando se selecciona una zona de datos
@interface MyEdit : UITextView
@end

@implementation MyEdit

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  DatosMeanCell* cell = (DatosMeanCell*)self.superview.superview;
  
  [ZoneDatosView SelectDatos: cell.Datos];
  }

@end

//===================================================================================================================================================
// Vista para mostrar los datos de una entrada en el diccionario
@interface DatosMean()
  {
  EntryDesc* Entry;                                 // Descripcion de la entrada en el diccionario

//  NSMutableArray<MarkView*> *Marks;               // Controles para cambiar las marcas

  CGFloat wSustData;                                // Contiene el mayor ancho de los datos de los textos de sustitución en la entrada
  
  ParseMeans* Parse;
  
  NSAttributedString* AttrStr;
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
@implementation DatosMean

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea objeto con los datos de la entrada 'Idx' en el diccionario actual
+ (DatosMean*) DatosForIndex:(NSInteger) Idx
  {
  EntryDict* Entry = [Dict getDataAt: Idx];                       // Obtiene los datos de la entrada en el diccionario general

  return [DatosMean DatosForEntry:Entry Src:LGSrc Des:LGDes];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea objeto con los datos de la entrada 'Idx'
+ (DatosMean*) DatosForEntry:(EntryDict*) Entry Src:(int)src Des:(int)des
  {
  DatosMean* Datos = [[DatosMean alloc] init];                    // Crea vista de datos nueva
  
  Datos.CellName = @"InfoMeanCell";
  Datos.src = src;
  Datos.des = des;

  Datos.sKey   = Entry.Key;
  Datos->Entry = [EntryDesc DescWithEntry:Entry Src:src Des:des];

  Datos.HasSustMarks = (Datos->Entry.nMarks>0);                     // Pone si tiene marcas de sustitución o no

  return Datos;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el analisis de las palabras del significado
- (ParseMeans*) GetParseMeans
  {
  [self GetAttrStr];
  
  if( !Parse )
    Parse = [ParseMeans ParseWithStr:AttrStr.string LangSrc:_src LangDes:_des];
  
  return Parse;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la cadena con atributos que representa los significados de la palabra
- (NSAttributedString*) GetAttrStr
  {
  if( !AttrStr ) AttrStr = [Entry getAttrString];
  
  return AttrStr;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la palabra seleccionada y el idioma
- (void) CheckSelectedWord
  {
  BOOL btnFind = DataCmdBarIsEnable(CMD_FIND_WRD);
  BOOL btnConj = DataCmdBarIsEnable(CMD_CONJ_WRD);
  
  BOOL showFind = FALSE;
  BOOL showConj = FALSE;
  
  if( _ActualWord && _ActualWord.Rg.length>0 )
    {
    if( ![_ActualWord.Wrd isEqualToString:_sKey] )
      showFind = TRUE;
    
    if( [ConjCore IsVerbWord:_ActualWord.Wrd InLang:_ActualWord.lng] )
      showConj = TRUE;
    }

  if( btnFind != showFind )
    {
    if( showFind ) DataCmdBarEnable ( CMD_FIND_WRD);
    else           DataCmdBarDisable( CMD_FIND_WRD);
    
    DataCmdBarRefresh();
    }
  
  if( btnConj != showConj )
    {
    if( showConj ) DataCmdBarEnable ( CMD_CONJ_WRD);
    else           DataCmdBarDisable( CMD_CONJ_WRD);
    
    DataCmdBarRefresh();
    }
  }


//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando los datos son seleccionados
- (void) SelectedDatos
  {
  [self.Cell BckColor: SelColor];
  
  DataCmdBarDisable(CMD_ALL);
  DataCmdBarEnable( CMD_PREV_WRD|CMD_NEXT_WRD|CMD_DEL_MEAN );
  DataCmdBarPosBottomView( self.Cell.contentView, 0 );
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
// Muestra/Oculta los controles de sustitución
//- (void) SustWords
//  {
//  if( _HSustMarks==0 ) [self CreateSustBoxView ];
//  else                 _HSustMarks = -_HSustMarks;
//
//  [ZoneDatosView SelectDatos:self];
//  }

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
// Reorganiza todas las subvistas dentro de la zona de datos
- (CGFloat) ResizeWithWidth:(CGFloat) w
  {
  w -= (2*SEP);

  CGFloat y = 0;                                            // Altura donde va la proxima vista

  [self GetAttrStr];                                        // Obtiene la texto con atributos
  
  CGSize sz = CGSizeMake( w, 5000);                         // Calcula la altura del texto
  CGRect rc = [AttrStr boundingRectWithSize:sz options:NSStringDrawingUsesLineFragmentOrigin context:nil ];
  
  _HText = (int)(rc.size.height + 16.9);                    // El TextView tiene un pading de 8 por arriba y por abajo
  y += _HText;

  if( _HSustMarks>0 )                                       // Si hay controles de sustitución
    {
//    y += _HSustMarks + SEP;                                 // Avanza la y en la altura de recuadro
    }

  if( self==ZoneDatosView.SelectedDatos )                   // Si es el dato seleccionado
    {
    _HText += 8;                                            // Crece un poco el texto, para la selección en la ultima linea
    y+= 40;                                                 // Crece la altura para mostra los botones
    }
  
  return y;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void) SelActualWord
  {
  [self GetParseMeans];
  if( Parse && self.Cell)
    {
    _ActualWord = [Parse GetSelected];
    
    [(DatosMeanCell*)self.Cell SelWordInRange:_ActualWord.Rg ];
    }
  
  [self CheckSelectedWord];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void) PreviosWord
  {
  if( Parse==nil ) [self GetParseMeans];
  else             [Parse GetPrevios];
  
  [self SelActualWord];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void) NextWord
  {
  if( Parse==nil ) [self GetParseMeans];
  else             [Parse GetNext];
  
  [self SelActualWord];
  }

@end

//===================================================================================================================================================

//===================================================================================================================================================
// Celda en la tabla para representar los datos de un significado
@interface DatosMeanCell()
  {
  MyEdit* Text;                                     // Texto de la tradución

  UIView* SustBox;                                  // Recuadro donde se pone los datos de sustitución de palabras
  
//  NSMutableArray<MarkView*> *Marks;               // Controles para cambiar las marcas

  CGFloat wSustData;                                // Contiene el mayor ancho de los datos de los textos de sustitución en la entrada
  }

@end

//===================================================================================================================================================
// Celda en la tabla para representar los datos de un significado
@implementation DatosMeanCell


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
  Text = self.contentView.subviews[0];
  Text.delegate = self;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Inicializa la celda para mostrar los datos especificados
- (void) UseWithInfoDatos:(DatosMean*) datos
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
// Ocurre cada vez que se cambia la selección del texto
- (void)textViewDidChangeSelection:(UITextView *)textView
  {
  DatosMean* datos = (DatosMean*)self.Datos;
  if( !datos ) return;
  
  MeanWord* SelWrd = datos.ActualWord;
  
  NSRange rg = Text.selectedRange;                                     // Obtiene el rango selecciondo

  if( !SelWrd || !NSEqualRanges(SelWrd.Rg, rg) )
    {
    ParseMeans* Parse = [datos GetParseMeans];
    
    datos.ActualWord = [Parse WordInRange:rg];

    [datos CheckSelectedWord];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Copia el texto seleccionado o la traducción al portapapeles
//- (void) CopyText
//  {
//  NSString* Txt;                                                        // Texto a copiar
//  
//  NSRange rg = Text.selectedRange;                                      // Obtiene el rango selecciondo
//  if( rg.length==0 )                                                    // No hay texto seleccionado
//    {
//    NSInteger iDes = [Entry IndexTrdInString:Text.text];             // Obtiene el indice donde comienza la traducción
//    if( iDes<=0 ) return;
//    
//    rg = NSMakeRange(iDes, Text.text.length-iDes);                    // Rango de donde empieza la traducción hasta el final
//    }
//  
//  Txt = [Text.text substringWithRange:rg];                            // Obtiene el texto a copiar
//  
//  Txt = [Txt stringByReplacingOccurrencesOfString:LGFlag(_src) withString:@"" ];      // Quita las banderitas
//  Txt = [Txt stringByReplacingOccurrencesOfString:LGFlag(_des) withString:@"" ];
//  
//  NSPasteboard *gpBoard = [NSPasteboard generalPasteboard];             // Obtiene ep pasteboard
//  
//  [gpBoard clearContents];                                              // Limpia el contenido anterior
//  
//  [gpBoard writeObjects: @[Txt] ];                                      // Escribe el objeto
//  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Muestra/Oculta los controles de sustitución
//- (void) SustWords
//  {
//  if( _HSustMarks==0 ) [self CreateSustBoxView ];
//  else                 _HSustMarks = -_HSustMarks;
//
//  [ZoneDatosView SelectDatos:self];
//  
//  [self.superview setNeedsLayout];
//  }

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
// Dibuja el fondo de la zona
//- (void)drawRect:(CGRect)rect
//  {
//  CGRect rc = self.bounds;
//  rc.size.height -= 2;
//
//  UIColor* ColBody;
//  UIColor* ColBrd = [UIColor darkGrayColor];
//  
//       if( self == [ZoneDatosView SelectedDatos] ) ColBody = SelColor;
//  else if( _HasSustMarks                         ) ColBody = SustColor;
//  else                                             ColBody = BackColor;
//
//  DrawRoundRect( rc, ColBrd, ColBody );
//  }
//
////-------------------------------------------------------------------------------------------------------------------------------------------------------
//// Dibuja el rectangulo 'rc' con bordes redondeados
//void DrawRoundRect( CGRect rc, UIColor* ColBrd, UIColor* ColBody )
//  {
//  float RSup = 6;
//  float RInf = 6;
//  
//  float xIzq = rc.origin.x;
//  float xDer = xIzq + rc.size.width;
//
//  float ySup = rc.origin.y;
//  float yInf = ySup + rc.size.height;
//  
//  float ycSup  = ySup + RSup;
//  float xcSupI = xIzq + RSup;
//  float xcSupD = xDer - RSup;
//
//  float ycInf  = yInf - RInf;
//  float xcInfI = xIzq + RInf;
//  float xcInfD = xDer - RInf;
//  
//  CGContextRef ct = UIGraphicsGetCurrentContext();
//  
//  CGContextSetStrokeColorWithColor(ct, ColBrd.CGColor);
//  CGContextSetFillColorWithColor(ct, ColBody.CGColor);
//
//  CGContextSetLineWidth(ct, 1);
//  
//  CGContextBeginPath(ct);
//  
//  CGContextMoveToPoint   (ct, xcSupI, ySup  );
//  CGContextAddArc        (ct, xcSupI, ycSup , RSup, -M_PI_2, -M_PI  , 1 );
//  CGContextAddLineToPoint(ct, xIzq  , ycInf );
//  CGContextAddArc        (ct, xcInfI, ycInf , RInf, -M_PI  ,  M_PI_2, 1 );
//  CGContextAddLineToPoint(ct, xcInfD, yInf );
//  CGContextAddArc        (ct, xcInfD, ycInf , RInf, M_PI_2 ,  0     , 1 );
//  CGContextAddLineToPoint(ct, xDer  , ycSup );
//  CGContextAddArc        (ct, xcSupD, ycSup , RSup, 0      , -M_PI_2, 1 );
//  
//  if( RSup>0 ) CGContextClosePath(ct);
//  
//  CGContextDrawPath( ct, kCGPathFillStroke);
//  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  [ZoneDatosView SelectDatos: self.Datos];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Selecciona el rango especificado de texto
- (void) SelWordInRange:(NSRange) rg
  {
  [Text becomeFirstResponder];
  Text.selectedRange = rg;
  }


@end

//===================================================================================================================================================












