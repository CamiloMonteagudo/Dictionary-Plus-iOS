//=========================================================================================================================================================
//  NumsController.m
//  TrdSuite
//
//  Created by Camilo on 03/05/15.
//  Copyright (c) 2015 Softlingo. All rights reserved.
//=========================================================================================================================================================

#import "NumsController.h"
#import "AppData.h"
#import "ColAndFont.h"
#import "NumGroupView.h"
#import "ReadNumber.h"

//=========================================================================================================================================================
@interface NumsController ()
  {
  int lang;
  }

@property (weak, nonatomic) IBOutlet SelLangView   *selLang;
@property (weak, nonatomic) IBOutlet NumGroupView  *GrpNum;
@property (weak, nonatomic) IBOutlet UILabel       *lbNum;
@property (weak, nonatomic) IBOutlet NumResultView *NumResult;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WidthLang;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightResult;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSeparac;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RightSeparac;

- (IBAction)OnBtnBack:(id)sender;

@end

//=========================================================================================================================================================
@implementation NumsController

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
  {
  [super viewDidLoad];

  self.view.backgroundColor = ColMainBck;                     // Pone el color de fondo de la vista
  
  _lbNum.font      = fontPanelTitle;
  _lbNum.textColor = ColPanelTitle;
  _lbNum.text      = NSLocalizedString(@"NumLabel", nil);

  _selLang.Delegate  = self;
  _selLang.SelLang   = LGSrc;

  lang = LGSrc;
  
  _GrpNum.Ctrller  = self;
  _GrpNum.NGroup   = GrpAll;
  
  _GrpNum.MaxChars = [ReadNumber MaxDigistInLang:LGSrc];
  
  _NumResult.NumEdit =_GrpNum;
  
//  _ModuleLabel.Text = NSLocalizedString(@"MnuNums", nil);
//  [_ModuleLabel OnCloseBtn:@selector(OnBtnClose:) Target:self];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Reorganiza todas las subvistas que estan dentro de la vista del viewcontroller
- (void)viewDidLayoutSubviews
  {
  CGFloat w = self.view.bounds.size.width;
  
  _selLang.HideName = (w<370);
  
  _TopSeparac.constant   = (w<550)? 30 : 0;
  _RightSeparac.constant = (w<550)? 8  : 60;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se gira la pantalla
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
  {
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime el botón de retroceder
- (IBAction)OnBtnBack:(id)sender
  {
  [self performSegueWithIdentifier: @"Back" sender: self];  // Retorna a la vista anterior
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se selecciona un idioma en la vista para selección de idiomas
- (void) OnSelLang:(SelLangView *)view
  {
  lang = view.SelLang;
  HideKeyboard();                                       // Oculta el teclado
  
  [_NumResult SetNumberReadingInLang:lang];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia el tamaño de la vista para seleccionar el idioma
- (void)OnSelLangChagedSize:(SelLangView *)view
  {
  _WidthLang.constant = view.WView;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia el tamaño de la vista que muestra el número
- (void)OnNumResultChagedSize:(NumResultView *)view
  {
  _HeightResult.constant = view.hPanel;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cada ves que cambia el número que se esta analizando
- (void) OnChageNum
  {
  [_NumResult SetNumberReadingInLang:lang];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
  {
  HideKeyboard();
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------

@end
//=========================================================================================================================================================
