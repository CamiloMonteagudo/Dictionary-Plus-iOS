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
  // Crea un gesto para ocultar o mostrar el nombre de idioma para ganar espacio
  UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(OnGeture:)];
  [self addGestureRecognizer:gesture];

  //self.backgroundColor = [UIColor redColor];
  _Left = FALSE;
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
  
  //btn.backgroundColor = [UIColor blueColor];
  [self addSubview:btn];
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
  if( _Left ) [self layoutToLeft ];
  else        [self layoutToRigth];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Organiza los botones hacia la derecha
- (void)layoutToRigth
  {
  CGFloat   y = self.bounds.size.height / 2;
  CGFloat   x = wBTN/2;
  
  for( UIView* btn in self.subviews )
    {
    if( Actives & (btn.tag) )
      {
      btn.center = CGPointMake(x, y);
      btn.hidden = FALSE;
    
      x += wBTN;
      }
    else
      btn.hidden = TRUE;
    }
  
  if( x != lastWidth )
    {
    lastWidth = x;
    [Ctrller UpdateRightBarSize];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Organiza los botones hacia la izquierda
- (void)layoutToLeft
  {
  CGSize sz   = self.bounds.size;
  
  CGFloat w = sz.width;
  CGFloat y = sz.height / 2;
  CGFloat x = w - (wBTN/2);
  
  for( UIView* btn in self.subviews )
    {
    if( Actives & (btn.tag) )
      {
      btn.center = CGPointMake(x, y);
      btn.hidden = FALSE;

      x -= wBTN;
      }
    else
      btn.hidden = TRUE;
    }
  
  if( x != lastWidth )
    {
    lastWidth = x;
    [Ctrller UpdateRightBarSize];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Permite desplazar hacia el lado la ventana
- (void) OnGeture:(UIPanGestureRecognizer *)sender
  {
  if( sender.state == UIGestureRecognizerStateChanged )
     {
     }
  else if( sender.state == UIGestureRecognizerStateEnded )
     {
   
     [UIView animateWithDuration:0.15
                      animations:^{
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
  CGSize sz = view.bounds.size;
  
  if( DictCmdBar.superview != view )
    {
    [DictCmdBar removeFromSuperview];
    [view addSubview:DictCmdBar];
    }
  
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


