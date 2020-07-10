//=========================================================================================================================================================
//  ViewController.m
//  Dictionary Plus
//
//  Created by Admin on 13/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "ViewController.h"
#import "SelLangsView.h"
#import "AppData.h"
#import "PanelRigthView.h"
#import "DesplazaView.h"
#import "SearchController.h"

//=========================================================================================================================================================
@interface ViewController ()
  {
  PanelRigthView* PopUp;                                  // Vista que muestra el menú con las opciones adicionales
  
  UIButton* btnLeft;                                      // Boton al la derecha del cuedra de búsqueda
  
  UIImage* imgPlus;                                       // Icono para mostrar las búsquedas avanzadas
  UIImage* imgMinus;                                      // Icono para ocultar las búsquedas avanzadas
  
  SearchController* FindPlusCtrller;
  }

@property (weak, nonatomic) IBOutlet DesplazaView *DictZone;
@property (weak, nonatomic) IBOutlet SelLangsView *selLangs;
@property (weak, nonatomic) IBOutlet UITextField *FindWord;
@property (weak, nonatomic) IBOutlet UIView *SearchPlus;
@property (weak, nonatomic) IBOutlet UIButton *bntSearchPlus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftSearchPlus;

- (IBAction)OnAvancedSearch:(id)sender;
- (IBAction)OnSwapDatos:(id)sender;
- (IBAction)OnShowMenu:(id)sender;
- (IBAction)EditingChanged:(UITextField *)sender;

@end

//=========================================================================================================================================================
@implementation ViewController

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
  {
  [super viewDidLoad];
  
  imgPlus  = [UIImage imageNamed:@"btnFindPlus50"];
  imgMinus = [UIImage imageNamed:@"btnFindMinus50"];
  
  for( UIViewController* Ctrller in self.childViewControllers)
    {
    if( [Ctrller isKindOfClass:SearchController.class] )
      FindPlusCtrller = (SearchController*) Ctrller;
    }
  
  [_selLangs SetDictWithSrc:2 AndDes:3];
  [self SetEditRightBotton];
  
  // Notificaciones para cuando se muestra/oculta el teclado
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
  {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Evento que se produce cuando se va ha mostrar el teclado
- (void)keyboardWillShow:(NSNotification *)notification 
  {
  if( _FindWord.isFirstResponder )
    {
    _TopSpace.constant = -45;
    
    nowEdit = _FindWord;
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Evento que se produce cuando se va a esaconder el teclado
- (void)keyboardWillHide:(NSNotification *)notification 
  {
  if( nowEdit == _FindWord )
    {
    _TopSpace.constant = 0;
 
    nowEdit = nil;
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama al oprimir el boton de busqueda avanzada
- (IBAction)OnAvancedSearch:(id)sender
  {
  HideKeyboard();                                             // Oculta el teclado si se esta mostrando
  [_DictZone setNeedsLayout];                                 // Pone los paneles en la posición correcta
  [self.view layoutIfNeeded];                                 // Fuerza a que se hagan todos los cambios pendientes

  if( _LeftSearchPlus.constant>=0 ) [self HideAvancedSearch];
  else                              [self ShowAvancedSearch];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Muestra las opciones de busqueda avanzada
- (void) ShowAvancedSearch
  {
  if( _LeftSearchPlus.constant>=0 ) return;
  
  [UIView animateWithDuration:0.3 animations:^
    {
    _LeftSearchPlus.constant = 0;
    [self.view setNeedsUpdateConstraints];
  
    [self.view layoutIfNeeded];
    }];
  
  [_bntSearchPlus setImage:imgMinus forState:UIControlStateNormal ];
  
  [FindPlusCtrller OpenFindPlusWithText:_FindWord ];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Oculta las opciones de busqueda avanzada
- (void) HideAvancedSearch
  {
  if( _LeftSearchPlus.constant<0 ) return;
  
  [UIView animateWithDuration:0.3 animations:^
    {
    _LeftSearchPlus.constant = -_SearchPlus.frame.size.width;
    [self.view setNeedsUpdateConstraints];
  
    [self.view layoutIfNeeded];
    }];
  
  [_bntSearchPlus setImage:imgPlus forState:UIControlStateNormal ];
  
  [FindPlusCtrller CloseFindPlus];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea al botón que va a la izquierda del cuadro de busqueda
- (void) SetEditRightBotton
  {
  btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
  
  [btnLeft addTarget:self action:@selector(OnAvancedSearch:) forControlEvents:UIControlEventTouchUpInside];
  
   btnLeft.frame = CGRectMake(0, 0, 25, 20);
 
  _FindWord.leftView     = btnLeft;
  _FindWord.leftViewMode = UITextFieldViewModeNever;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama al oprimir el botón para cambiar la vista de los datos
- (IBAction)OnSwapDatos:(id)sender
  {
  HideKeyboard();
  
  [_DictZone TogglePanel];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama al oprimir el botón para mostrar el menú
- (IBAction)OnShowMenu:(id)sender
  {
  HideKeyboard();
  
  NSArray* ItemIDs = @[@"Diccionario",@"Conjugador",@"Personalización"];
  PopUp = [[PanelRigthView alloc] initInView:sender ItemIDs:ItemIDs];             // Crea un popup menú con items adicionales

  [PopUp OnHidePopUp:@selector(OnHidePopUp:) Target:self];                          // Pone metodo de notificación del mené
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se cierra el menú con las opciones adicionales
- (void)OnHidePopUp:(PanelRigthView*) view
  {
  PopUp = nil;                                                                     // Indica que no hay menú a partir de este momento
  
//  int Idx = view.SelectedItem;                                                     // Obtiene el item seleccionado en el menú
//  if( Idx >= 0 )                                                                   // Hay uno seleccionado
//    [self OnSelectItem:Idx];                                                       // Función que procesa la acción
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cada vez que se cambia el texto en el cuadro de búsqueda
- (IBAction)EditingChanged:(UITextField *)sender
  {
  NSString* txt = _FindWord.text;
  BOOL hide = ( txt.length==0 );
  
  if( _bntSearchPlus.hidden != hide )
    {
    _bntSearchPlus.hidden = hide;
    _FindWord.leftViewMode = (hide? UITextFieldViewModeNever : UITextFieldViewModeAlways);
    }
  
  if( _LeftSearchPlus.constant>=0 ) [self HideAvancedSearch];
  
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cada vez que se llama otro controlador para mostrar una vista
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
  {
//  UIViewController* Ctrller = segue.destinationViewController;
//  NSString* ID = segue.identifier;
  
  }


@end
//=========================================================================================================================================================
