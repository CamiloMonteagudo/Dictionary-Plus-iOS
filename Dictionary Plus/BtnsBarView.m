//=========================================================================================================================================================
//  BtnsBarView.m
//  Dictionary Plus
//
//  Created by Admin on 6/4/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "BtnsBarView.h"
#import "AppData.h"
#import "CmdPopUpView.h"

BtnsBarView* DictCmdBar;
BtnsBarView* DataCmdBar;

#define wBTN    40
#define hBTN    40

//=========================================================================================================================================================
@interface BtnsBarView ()
  {
  int  Actives;
  
  CGFloat lastWidth;
  }
@end

//=========================================================================================================================================================
@implementation BtnsBarView

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
  //self.backgroundColor = [UIColor redColor];
  _Left = 1000;                                   // Asume todos los botones pegados a la izquierda
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona un boton a la barra de botones
- (void) AddBtn:(int) idBtn WithImage:(NSString*) sImg
  {
  UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];

  btn.frame  = CGRectMake(0, 0, wBTN, hBTN);
  btn.tag    = idBtn;
  btn.hidden = TRUE;
  
  [btn addTarget:self action:@selector(OnCmdBtn:) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage* img = [UIImage imageNamed:sImg ];
  [btn setImage:img forState:UIControlStateNormal ];
  
  btn.showsTouchWhenHighlighted = true;
  //btn.backgroundColor = [UIColor blueColor];
  [self addSubview:btn];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Determina si los comandos en 'sw' estan avilitados o no
- (BOOL) IsEnable:(int) sw
  {
  return ((Actives & sw) == sw);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Habilita los comandos especificados en 'sw'
- (void) Enable:(int) sw
  {
  Actives |= sw;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Desavilita los comandos especificados en 'sw'
- (void) Disable:(int) sw
  {
  Actives &= (~sw);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el boton con el identificador dado
- (UIButton*) GetButtonWithID:(int) idBtn
  {
  for( UIView* btn in self.subviews )
    if( btn.tag == idBtn ) return (UIButton*)btn;
  
  return nil;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el boton con el indice especificado
- (UIButton*) GetButtonWithIndex:(int) idx
  {
  if( idx>=0 && idx<self.subviews.count )
    return (UIButton*) self.subviews[idx];
  
  return nil;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Determina si el botón 'IdBtn' esta activo o no
- (BOOL) IsActiveBtnWithID:(int) IdBtn
  {
  UIButton* btn = [self GetButtonWithID:IdBtn];
  if( !btn ) return FALSE;
  
  return ( Actives & (btn.tag) );
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el ancho de la barra según los botones activos
- (CGFloat) Width
  {
  int act = 0;
  for( UIView* btn in self.subviews )
    if( Actives & (btn.tag) ) ++act;
  
  return wBTN * act;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime un boton
- (void)OnCmdBtn:(UIButton *)btn
  {
  NSInteger idBtn = btn.tag;
  if( idBtn != CMD_MENU )
    {
    NSNumber *idBtn = [NSNumber numberWithInteger:btn.tag];
  
    // Informa que se cambio la direccion de traducción
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:ExecComamd object:idBtn];
    }
  else
    {
    CmdPopUpView* PopUp = [[CmdPopUpView alloc] initWithBtnsBar:self DeltaX:0 DeltaY:-5];
    [PopUp ShowWithCallBack:@selector(OnSelCmdMnu:) Target:self];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime un boton
- (void)OnSelCmdMnu:(CmdPopUpView*) PopUp
  {
  int idBtn  = PopUp.SelectedCmd;
  if( idBtn <= 0 ) return;
  
  NSNumber *BtnNum = [NSNumber numberWithInteger:idBtn];
  
  // Informa que se cambio la direccion de traducción
  NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
  [center postNotificationName:ExecComamd object:BtnNum];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
  {
  CGSize  sz = self.bounds.size;
  CGFloat xl = wBTN/2;
  CGFloat xr = sz.width - (wBTN/2);
  CGFloat y  = sz.height / 2;
  CGFloat w  = 0;
  
  for( NSInteger i=0; i<self.subviews.count; ++i  )
    {
    UIView* btn = self.subviews[i];
    
    if( Actives & (btn.tag) )
      {
      if( i>=_Left )
        {
        btn.center = CGPointMake(xr, y);
        xr -= wBTN;
        }
      else
        {
        btn.center = CGPointMake(xl, y);
        xl += wBTN;
        }
      
      btn.hidden = FALSE;
      w += wBTN;
      }
    else
      btn.hidden = TRUE;
    }
  
  if( w != lastWidth )
    {
    lastWidth = w;
    [Ctrller UpdateBarSizeAndPos];
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

//=========================================================================================================================================================
// Crea la barra de botones para el diccionario
void MakeDictCmdBar()
  {
  DictCmdBar = [[BtnsBarView alloc] initWithFrame:CGRectMake(0, 0, 3*wBTN, hBTN)];
  
  [DictCmdBar AddBtn: CMD_MENU      WithImage:@"btnMnuCmds40"  ];
  [DictCmdBar AddBtn: CMD_SPLIT     WithImage:@"btnListMixss40"];
  [DictCmdBar AddBtn: CMD_WRDS      WithImage:@"btnListWrds40" ];
  [DictCmdBar AddBtn: CMD_MEANS     WithImage:@"btnListMeans40"];
  [DictCmdBar AddBtn: CMD_ALL_MEANS WithImage:@"btnShowAll40"  ];
  [DictCmdBar AddBtn: CMD_DEL_MEANS WithImage:@"btnDelMeans40" ];
  
  DictCmdBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [DictCmdBar Enable: CMD_MENU];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Habilita los comandos especificado con 'sw' en la barra de botones del diccionario
void DictCmdBarEnable( int sw )
  {
  [DictCmdBar Enable: sw];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Desabilita los comandos especificado con 'sw' en la barra de botones del diccionario
void DictCmdBarDisable( int sw )
  {
  [DictCmdBar Disable: sw];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona la barra de botones a una vista especificada por 'view'
void DictCmdBarAddToView( UIView* view )
  {
  if( DictCmdBar.superview != view )
    {
    [DictCmdBar removeFromSuperview];
    if( view==nil ) return;
    
    [view addSubview:DictCmdBar];
    }
  
  CGSize sz = view.bounds.size;
  DictCmdBar.frame = CGRectMake(0, 0, sz.width, sz.height);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el boton especificado de la barra de botones del diccionario
UIButton* DictCmdBarGetBtn( int ID )
  {
  return [DictCmdBar GetButtonWithID:ID];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el ancho de la barra de botones del diccionario
CGFloat DictCmdBarWidth()
  {
  return [DictCmdBar Width];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el ancho de la barra de botones del diccionario
void DictCmdBarRefresh()
  {
  [DictCmdBar setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone la barra de botones a la derecha o no
void DictCmdBarOnRight( BOOL oRight )
  {
  DictCmdBar.Left = oRight;
  }

static NSString* Titles[] = { @"", @"CmdSplitTitle", @"CmdWordsTitle", @"CmdMeansTilte", @"CmdAllMeansTitle", @"CmdDelMeansTitle" };

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene le nombre de un comando
NSString* TitleForComand( int ID )
  {
  for( int i=1; i< sizeof(Titles)/sizeof(Titles[0]); ++i)
    {
    int val = (ID>>i);
    
    if( val == 1 )  return NSLocalizedString(Titles[i], Nil);
    if( val == 0 )  break;
    }
  
  return @"";
  }

//=========================================================================================================================================================
// Crea la barra de botones para los datos del diccionario
void MakeDataCmdBar()
  {
  DataCmdBar = [[BtnsBarView alloc] initWithFrame:CGRectMake(0, 0, 3*wBTN, hBTN)];
  
  [DataCmdBar AddBtn: CMD_PREV_WRD WithImage:@"btnPrevWord40"];
  [DataCmdBar AddBtn: CMD_NEXT_WRD WithImage:@"btnNextWord40" ];
  [DataCmdBar AddBtn: CMD_DEL_MEAN WithImage:@"btnDelMean40" ];
  [DataCmdBar AddBtn: CMD_CONJ_WRD WithImage:@"btnConjWord40"  ];
  [DataCmdBar AddBtn: CMD_FIND_WRD WithImage:@"btnFindWord40"];
  
  DataCmdBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  
  [DataCmdBar Enable: CMD_PREV_WRD | CMD_NEXT_WRD | CMD_DEL_MEAN];
  DataCmdBar.Left = 2;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Habilita los comandos especificado con 'sw' en la barra de botones del diccionario
void DataCmdBarEnable( int sw )
  {
  [DataCmdBar Enable: sw];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Desabilita los comandos especificado con 'sw' en la barra de botones del diccionario
void DataCmdBarDisable( int sw )
  {
  [DataCmdBar Disable: sw];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Determina si los comandos especificados en 'sw' estan avilitados o no
BOOL DataCmdBarIsEnable( int sw )
  {
  return [DataCmdBar IsEnable:sw];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene el ancho de la barra de botones del diccionario
void DataCmdBarRefresh()
  {
  [DataCmdBar setNeedsLayout];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Determina si la barra de comando esta activa en la vista 'view'
BOOL DataCmdBarInView( UIView* view )
  {
  return (DataCmdBar.superview == view);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona la barra de botones a una vista especificada por 'view'
void DataCmdBarPosBottomView( UIView* view )
  {
  if( DataCmdBar.superview != view )
    {
    [DataCmdBar removeFromSuperview];
    if( view==nil ) return;
    
    [view addSubview:DataCmdBar];
    }
  
  if( view !=nil )
    {
    CGSize sz = view.bounds.size;
    DataCmdBar.frame = CGRectMake(0, sz.height-hBTN, sz.width, hBTN);
    }
  }

//=========================================================================================================================================================


