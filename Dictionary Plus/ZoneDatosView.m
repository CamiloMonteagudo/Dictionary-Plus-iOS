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
#import "DatosMean.h"
#import "DatosConjs.h"

//#import "BuyMsgView.h"

static InfoDatos* DatosSel;
static UITableView* _TableDatos;

//===================================================================================================================================================
// Clase base para mostrar información en la lista de la derecha
@implementation InfoCell

- (void) UseWithInfoDatos:(InfoDatos*) datos {}
- (void) BckColor:(UIColor*) col {}

@end

//===================================================================================================================================================
// Clase base para los datos de la información que se muestra a la derecha
@implementation InfoDatos

- (CGFloat) ResizeWithWidth:(CGFloat) w { return 0;}

- (void) SelectedDatos {}
- (void) UnSelectedDatos {}

@end

//=========================================================================================================================================================
@interface ZoneDatosView ()
{
UITableView* TableDatos;

NSMutableArray<InfoDatos*> *Datos;
}

@end

//===================================================================================================================================================
// Zona donde se muestran los datos de las palabras
@implementation ZoneDatosView

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
  Datos = [NSMutableArray new];
  
  NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
  [center addObserver:self selector:@selector(OnExecComamd:) name:ExecComamd object:nil];
  
  TableDatos = self.subviews[0];
  
  TableDatos.estimatedRowHeight = 60;
//  TableDatos.rowHeight = UITableViewAutomaticDimension;
  
  _TableDatos = TableDatos;
  
  [TableDatos reloadData];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama para saber el número de datos de palabras o frases que se van a mostrar
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
  {
  return Datos.count;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
  {
  CGFloat w = tableView.frame.size.width;
  
	int row = (int)[indexPath row];
  InfoDatos* datos = Datos[row];
  
  CGFloat h = [datos ResizeWithWidth:w];
  
  return h;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama para conocer la palabra que se corresponde con la fila 'row'
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
  {
	int row = (int)[indexPath row];
  InfoDatos* datos = Datos[row];
  
	InfoCell *cell = [tableView dequeueReusableCellWithIdentifier: datos.CellName];
  
  return cell;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando la celda se va a mostrar
- (void)tableView:(UITableView *)tableView willDisplayCell:(InfoCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
  {
	int row = (int)[indexPath row];
  InfoDatos* datos = Datos[row];
  
  [cell UseWithInfoDatos:datos];

  [cell setNeedsDisplay];
  [cell layoutIfNeeded];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Retorna la cantidad de datos que hay en la zona
- (int)Count
  {
  return (int)Datos.count;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Fuerza a que se refresque la información que se muestra en la tabla
- (void) UpdateInfo
  {
  [TableDatos reloadData];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona los datos de la palabra 'Idx' en la parte superior de la zona de datos de palabras
- (void) AddDatos:(InfoDatos*) datos Select:(BOOL) sel
  {
  DictCmdBarEnable(CMD_DEL_MEANS);
  DictCmdBarRefresh();
  
  [Datos insertObject:datos atIndex:0];                                           // Adiciona vista de datos nueva
  
  if( sel )
    {
    [ZoneDatosView SelectDatos:datos];
    [_TableDatos reloadData];
    
    NSIndexPath* idx = [NSIndexPath indexPathForRow:0 inSection:0];
    [_TableDatos scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Selecciona el primer iten de la lista
- (void) SelectFirst
  {
  [ZoneDatosView SelectDatos: Datos[0]];
  [_TableDatos reloadData];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Inserta los datos de la entrada suministrada después de la vista seleccionada
- (void) AddDatosAfterSel:(InfoDatos*) Datos;
  {
//  [self insertSubview:Datos belowSubview:DatosSel];                             // Adiciona vista de datos nueva
//  [self setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Reposiciona todos las vistas de datos aduadamente
- (void) ClearDatos
  {
  [Datos removeAllObjects];
  [TableDatos reloadData];
  
  [ZoneDatosView SelectDatos:nil];
  
  DictCmdBarDisable(CMD_DEL_MEANS);
  DictCmdBarRefresh();
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone los datos identificados por 'view' como datos seleccionados
+(void) SelectDatos:(InfoDatos*) datos
  {
  HideKeyboard();
  if( DatosSel == datos ) return;
  
  if( DatosSel )  [DatosSel UnSelectedDatos];
  
  DatosSel = datos;

  if( datos ) [datos SelectedDatos];
  
  [_TableDatos reloadData];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Retorna la vista de los datos seleccionados
+(InfoDatos*) SelectedDatos
  {
  return DatosSel;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Borra los datos seleccionados
- (void) DeleteSelectedDatos
  {
  NSInteger i=0;
  for( ;i<Datos.count; ++i )
    if( Datos[i] == DatosSel )
      {
      [Datos removeObjectAtIndex:i];
      break;
      }

  if( i>=Datos.count ) --i;
  if( i>=0 )
    {
    [ZoneDatosView SelectDatos:Datos[i]];
    }
  else
    {
    [ZoneDatosView SelectDatos:nil];
    
    DictCmdBarDisable(CMD_DEL_MEANS);
    DictCmdBarRefresh();
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se ejecuta un comando en cualquier parte la aplicación
- (void)OnExecComamd:(NSNotification *)notify
  {
  if( !DatosSel || ![DatosSel isKindOfClass:DatosMean.class] )
    return;
  
  DatosMean* datos = (DatosMean*)DatosSel;
  NSNumber *idBnt = notify.object;
  
  switch( idBnt.integerValue )
    {
    case CMD_PREV_WRD: [datos PreviosWord    ]; break;
    case CMD_NEXT_WRD: [datos NextWord       ]; break;
    case CMD_CONJ_WRD: [self ConjNowWordInDatos:datos ]; break;
    case CMD_FIND_WRD: [self FindNowWordInDatos:datos ]; break;
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Conjuga la palabra actual en los datos y las muesta en una fila nueva a continuación del dato seleccionado
- (void) ConjNowWordInDatos:(DatosMean *)MeanDato
  {
  DictCmdBarEnable(CMD_DEL_MEANS);
  DictCmdBarRefresh();
  
  MeanWord* wrd = MeanDato.ActualWord;
  DatosConjs* ConfDato = [DatosConjs DatosForWord:wrd.Wrd Lang:wrd.lng];
  
  int idx = [self IndexAfter:MeanDato];
  [Datos insertObject:ConfDato atIndex:idx];                                           // Adiciona vista de datos nueva
  
  NSIndexPath* Idx = [NSIndexPath indexPathForRow:idx inSection:0];
  NSArray<NSIndexPath *> *rows = [NSArray arrayWithObject:Idx];
  
  [_TableDatos insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic ];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Busca la palabra actual en los datos y las muesta en una fila nueva a continuación del dato seleccionado
- (void) FindNowWordInDatos:(DatosMean *)datos
  {
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Busca el indice posterior al dato dado
- (int) IndexAfter:(InfoDatos *)RefDato
  {
  int n = (int)Datos.count;
  for (int i=0; i<n; ++i)
    {
    InfoDatos* dato = Datos[i];
    if( dato==RefDato ) return i+1;
    }
  
  return n;
  }


@end
//===================================================================================================================================================
