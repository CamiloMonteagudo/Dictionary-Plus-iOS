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
#import "WaitView.h"
#import "TextQuery.h"
#import "SortedIndexs.h"

//=========================================================================================================================================================
@interface ViewController ()
  {
  PanelRigthView* PopUp;                                  // Vista que muestra el menú con las opciones adicionales
  
  UIButton* btnLeft;                                      // Boton al la derecha del cuedra de búsqueda
  
  UIImage* imgPlus;                                       // Icono para mostrar las búsquedas avanzadas
  UIImage* imgMinus;                                      // Icono para ocultar las búsquedas avanzadas
  
  SearchController* FindPlusCtrller;
  
  SortedIndexs* SortEntries;
  TextQuery* Query;
  }

@property (weak, nonatomic) IBOutlet DesplazaView *DictZone;
@property (weak, nonatomic) IBOutlet SelLangsView *selLangs;
@property (weak, nonatomic) IBOutlet UITextField *FindWord;
@property (weak, nonatomic) IBOutlet UIView *SearchPlus;
@property (weak, nonatomic) IBOutlet UIButton *bntSearchPlus;
@property (weak, nonatomic) IBOutlet UITableView *TableFrases;

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
  Ctrller = self;
  
  [super viewDidLoad];
  
  imgPlus  = [UIImage imageNamed:@"btnFindPlus50"];
  imgMinus = [UIImage imageNamed:@"btnFindMinus50"];
  
  for( UIViewController* Ctrller in self.childViewControllers)
    {
    if( [Ctrller isKindOfClass:SearchController.class] )
      FindPlusCtrller = (SearchController*) Ctrller;
    }
  
  [_selLangs SetDictWithSrc:LGSrc AndDes:LGDes];
  [self SetEditRightBotton];
  
  _FindWord.allowsEditingTextAttributes = TRUE;
  
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

//---------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime la tecla retun durante la edicción de las palabras a adicionar
- (BOOL)textFieldShouldReturn:(UITextField *)textField
  {
  HideKeyboard();
  return TRUE;
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
  
  [self FindFrases];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cada vez que se llama otro controlador para mostrar una vista
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
  {
//  UIViewController* Ctrller = segue.destinationViewController;
//  NSString* ID = segue.identifier;
  
  }


//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Carga el diccionario para los idiomas activos
- (BOOL) LoadDictWithSrc:(int) src AndDes:(int) des
  {
  WaitView* Wait = [[WaitView alloc] initInTopFrom:self.view];
  
  int iDir = DIRFromLangs( src, des );                         // Toma la dirección seleccionada
  
//  if( ![self CheckPurchase:iDir] )                             // Chequea que el diccionarios este comprado o en modo prueba
//     return;                                                   // No lo carga hasta que no sea comprado

  BOOL ret1 = [DictMain    LoadWithSrc:src AndDes:des ];
  BOOL ret2 = [DictIndexes LoadWithSrc:src AndDes:des ];

  [Wait removeFromSuperview];

  if( !ret1 || !ret2 )
    {
    NSLog(@"Dicionario Cargado:%d Indices Cargados:%d", ret1, ret2 );
//    [self ShowHeaderMsg:@"NoLoadDict"];
    return FALSE;
    }
  
  // Guarda dirección seleccionada en los datos del usuario
  NSUserDefaults* UserDef = [NSUserDefaults standardUserDefaults];
  [UserDef setObject:[NSNumber numberWithInt:iDir] forKey:@"lastDir"];

  [self FindFrases];
  return TRUE;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Encuentra todas las palabras frases y oraciones que cumplen el criterio de busqueda
- (void) FindFrases
  {
  Query = [TextQuery QueryWithText: _FindWord.text ];                       // Obtiene el query

  FOUNDS_ENTRY* FoundEntries = [Query FindWords];                           // Busca las palabras

  SortEntries = [SortedIndexs SortEntries:FoundEntries Query:Query];        // Organiza las palabras por su ranking

  [_TableFrases reloadData];                                                // Actualiza el contenido de la lista
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Realiza una busqueda avanzada de palabras y frases, según los datos suministrados en 'Query' y 'sw'
- (void) FindFrasesWithQuery:(TextQueryPlus*) query Options:(int) sw
  {
  FOUNDS_ENTRY* FoundEntries = [query FindWords];                           // Busca las palabras

  SortEntries = [SortedIndexs SortEntries:FoundEntries QueryPlus:query Options:sw];    // Organiza las palabras por su ranking

  [_TableFrases reloadData];                                                // Actualiza el contenido de la lista
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama para saber el número de palabras de la lista de palabras del diccionario
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
  {
  return SortEntries.Count;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
static CGFloat FontSize   = [UIFont systemFontSize];                            // Tamaño de la letras estandard del sistema

static UIFont* fontReg   = [UIFont systemFontOfSize:     FontSize];             // Fuente para los significados
static UIFont* fontBold  = [UIFont boldSystemFontOfSize: FontSize];             // Fuente para los textos resaltados dentro del significado

static NSDictionary* attrKey = @{ NSFontAttributeName:fontReg };
static NSDictionary* attrWrd = @{ NSFontAttributeName:fontBold };

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama para conocer la palabra que se corresponde con la fila 'row'
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
  {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordOrPhrase"];
  
	int row = (int)[indexPath row];

  EntrySort* entry = SortEntries->Entries[row];

  int idx = entry->Index;
  NSString* key = Dict.Items[idx].Key;

  NSInteger PosLst[50];
  NSInteger LenLst[50];
  NSInteger pos = 0;

  NSScanner* sc = [NSScanner scannerWithString:key];
  while( !sc.isAtEnd && pos<50 )
    {
    [sc scanCharactersFromSet:wrdSep intoString:nil];

    NSInteger IniWrd = sc.scanLocation;

    [sc scanUpToCharactersFromSet:wrdSep intoString:nil];

    PosLst[pos] = IniWrd;
    LenLst[pos] = sc.scanLocation-IniWrd;

    ++pos;
    }

  NSMutableAttributedString* TxtKey  = [[NSMutableAttributedString alloc] initWithString:key attributes:attrKey  ];

  NSInteger nPos = entry->WrdsPos.count;
  for( int i=0; i<nPos; ++i )
    {
    NSInteger wPos = entry->WrdsPos[i].integerValue;
    if( wPos>=pos ) continue;

    NSRange rg = NSMakeRange( PosLst[wPos], LenLst[wPos] );

    [TxtKey setAttributes:attrWrd range:rg];
    }

  cell.textLabel.attributedText = TxtKey;

  return cell;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando cambia la selección de la palabra actual en la lista de palabras del diccionario
//- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
//  {
//  int row = (int)_tableFrases.selectedRow;
//  if( row==-1 ) return;
//  
//  int idx = SortEntries->Entries[row]->Index;
//
//  [_ZonaDatos AddDatosAtIndex:idx];
//
//  [_ZonaDatos scrollPoint:NSMakePoint(0, 0)];
//  }



@end
//=========================================================================================================================================================
