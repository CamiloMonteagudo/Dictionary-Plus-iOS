//=========================================================================================================================================================
//  ConjController.m
//  TrdSuite
//
//  Created by Camilo on 03/05/15.
//  Copyright (c) 2015 Softlingo. All rights reserved.
//=========================================================================================================================================================

#import "ConjController.h"
#import "AppData.h"
#import "ConjDataView.h"
#import "ColAndFont.h"
#import "ConjCore.h"

#define BY_WORDS   0
#define BY_MODES   1
#define BY_PERSONS 2

#define BTN_W      50             // Ancho de los botones de la barra de botones
#define BTN_H      50             // Alto de los botones de la barra de botones
#define BTN_SEP    10             // Separación entre los botones de la barra

#define BRD_W  1                  // Ancho del borde de las zonas redondeadas
#define SEP_BRD   5               // Sepatación de los bordes

//=========================================================================================================================================================
@interface ConjController ()
  {
  BOOL IsVerb;
  }

  @property (weak, nonatomic) IBOutlet SelLangView *selLang;
  @property (weak, nonatomic) IBOutlet UITextField *FindVerb;
  @property (weak, nonatomic) IBOutlet ConjHeaderView *HdrConjs;
  @property (weak, nonatomic) IBOutlet ConjDataView   *LstConjs;

- (IBAction)OnConjugate:(id)sender;
- (IBAction)EditingVerb:(UITextField *)sender;
- (IBAction)OnBtnBack:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightConjHrd;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WidthSelLang;

@end

//=========================================================================================================================================================
@implementation ConjController
//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
  {
  [super viewDidLoad];

  self.view.backgroundColor = ColMainBck;                     // Pone el color de fondo de la vista

  [self LoadDefaults];
  
  _HdrConjs.Delegate = self;
  _selLang.Delegate  = self;
  _selLang.SelLang   = LGConj;

  [ConjCore LoadConjLang:LGConj ];                            // Carga la conjugacion para el idiom actual
  
  _FindVerb.text = _Verb;                                     // Lo pone en el editor
    
  if( [ConjCore IsVerbWord:_Verb InLang:LGConj] )             // Si el parameto recibido es un verbo
    {
    IsVerb = [ConjCore IsVerbWord:_Verb InLang:LGConj];       // Determina si el texto es un verbo o alguna conjugación
    [self Conjugate];                                         // Lo manda a conjugar
    }
  else
    {
    [self ClearConjData];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Carga los valores por defecto para el modulo
- (void) LoadDefaults
  {
  NSUserDefaults* UserDef = [NSUserDefaults standardUserDefaults];

  NSNumber* mode = [UserDef objectForKey:@"lastConjMode"];    // El último modo utilizado por el usuario
  if( mode != nil )
    {
    _HdrConjs.Mode = mode.intValue;
    _LstConjs.ViewMode = mode.intValue;
    }

  if( _Verb==nil )
    {
    NSString* verb = [UserDef objectForKey:@"lastConjVerb"];  // El último verbo conjugado
    if( verb != nil )  _Verb = verb;
    
    NSNumber* Lang = [UserDef objectForKey:@"lastConjLang"];  // El último idioma usado
    if( Lang != nil ) LGConj = Lang.intValue;
    }
  
  if( LGConj < 0 ) LGConj = LGSrc;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia el tamaño de la vista del modulo de conjugaciones
- (void)viewDidLayoutSubviews
  {
  CGFloat w = self.view.bounds.size.width;
  
  _selLang.HideName = (w<370);
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama antes de pasar a la proxima pantalla
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
  {
  if( IsVerb )
    {
    NSUserDefaults* UserDef = [NSUserDefaults standardUserDefaults];
  
    NSNumber* oLng = [NSNumber numberWithInt:LGConj];
  
    [UserDef setObject:_Verb forKey:@"lastConjVerb"];
    [UserDef setObject:oLng  forKey:@"lastConjLang"];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se selecciona un idioma en la vista para selección de idiomas
- (void) OnSelLang:(SelLangView *)view
  {
  LGConj = view.SelLang;
  [ConjCore LoadConjLang: LGConj];          // Carga la conjugacion para el idiom actual
  
  [self ConjugateIfVerb];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia el tamaño de la vista para seleccionar el idioma
- (void)OnSelLangChagedSize:(SelLangView *)view
  {
  _WidthSelLang.constant = view.WView;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cada ves que se cambia el texto de origen
- (IBAction)EditingVerb:(UITextField *)sender
  {
  [self ConjugateIfVerb];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Cuando ese toca el boton de budcar en el teclado
- (void)OnKeyBoardReturn
  {
  [self Conjugate];
  HideKeyboard();
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama al oprimir el boton de conjugación
- (IBAction)OnConjugate:(id)sender
  {
  HideKeyboard();
  
  [self Conjugate];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se cambia el modo como se muestran las conjugaciones
- (void)OnConjHdrChangeMode:(ConjHeaderView *)view
  {
  int viewMode = view.Mode;
  
  _LstConjs.ViewMode = viewMode;                          // Pone el modo nuevo

  if( viewMode == BY_WORDS )                              // Si el nuevo modo es por palabras
    {
    NSString* sVerb = _FindVerb.text;                     // Toma el texto que hay en el editor
    [_LstConjs SelectConj:sVerb  ];                       // Selecciona la conjugacion tecleada
    }
  
  // Guarda el último modo usado por el usuario
  NSUserDefaults* UserDef = [NSUserDefaults standardUserDefaults];
  [UserDef setObject:[NSNumber numberWithInt:viewMode] forKey:@"lastConjMode"];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia el tamaño del encabezamiento de las conjugaciones
- (void)OnConjHdrChangeSize:(ConjHeaderView *)view
  {
  _HeightConjHrd.constant = view.hPanel;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime el botón de retroceder
- (IBAction)OnBtnBack:(id)sender
  {
  [self performSegueWithIdentifier: @"Back" sender: self];  // Retorna a la vista anterior
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Conjuga la palabra actual
- (void) ConjugateIfVerb
  {
  NSString* sVerb = _FindVerb.text;                       // Toma el contenido del editor
  
  IsVerb = [ConjCore IsVerbWord:sVerb InLang:LGConj ];    // Determina si el texto es un verbo o alguna conjugación
  
  if( IsVerb ) [self Conjugate];
  else         [self ClearConjData];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Conjuga la palabra actual
- (void)Conjugate
  {
  NSString* sVerb = _FindVerb.text;                         // Toma el texto que hay en el editor
  
  if( [ConjCore ConjVerb:sVerb] )                           // Si se puedo obtener las conjugaciones
    [self ShowConjData:sVerb];
   else                                                     // No se puedo obtener las conjugaciones
    [self ClearConjData];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Muestra los datos de las conjugaciones
- (void) ShowConjData:(NSString*) sVerb
  {
  _LstConjs.contentOffset = CGPointMake(0, 0);            // Pone el escroll de los datos al inicio
    
  [_LstConjs UpdateConjugate   ];                         // Actualiza los datos de la conjugación
  [_LstConjs SelectConj:sVerb  ];                         // Selecciona las conjugaciones tecleadas
    
  [_HdrConjs ShowDataVerb:IsVerb];
  
  [_HdrConjs setNeedsLayout];
  [_HdrConjs layoutIfNeeded];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Quita los datos de las conjugaciones
- (void) ClearConjData
  {
  [_HdrConjs ClearData];
  
  if( _FindVerb.text.length > 0 )
    [_HdrConjs ShowMessage:NSLocalizedString(@"NoVerb", nil) Color:ColErrInfo];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
  {
  }

@end
//=========================================================================================================================================================
