//=========================================================================================================================================================
//  SearchController.m
//  Dictionary Plus
//
//  Created by Admin on 25/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "SearchController.h"
#import "ViewController.h"
#import "AppData.h"
#import "ColAndFont.h"
#import "ConjCore.h"
#import "TextQueryPlus.h"

//=========================================================================================================================================================
@interface SimilarWord : NSObject

  @property (nonatomic) NSString* Wrd;
  @property (nonatomic) NSRange   rg;
  @property (nonatomic) NSMutableArray<NSString* >* SWords;

  @property (nonatomic, readonly) NSInteger count;

@end

//=========================================================================================================================================================
@implementation SimilarWord

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea un objeto para representar palabras similares
+ (instancetype) WithWord:(NSString*) wrd AndRange:(NSRange) range
  {
  SimilarWord* SWrd = [SimilarWord new];
  SWrd.Wrd = wrd;
  SWrd.rg  = range;

  SWrd.SWords = [NSMutableArray new];
  return SWrd;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Retorna el número de palabras similares que hay
- (NSInteger)count
  {
  return _SWords.count;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona una palabra a la lista de palabras similares
- (void)AddSWord:(NSString*) wrd
  {
  [_SWords addObject:wrd ];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona una palabra a la lista de palabras similares
- (void)DelSWordAt:(NSInteger) idx
  {
  if( idx<0 || idx>=_SWords.count ) return;
  
  [_SWords removeObjectAtIndex:idx ];
  }

@end

//=========================================================================================================================================================
@interface SearchController ()
  {
  NSMutableArray< SimilarWord* > *Words;                      // Datos de todas la palabras buscadas
  
  int idxWord;                                                // Indice de la palabra actual
  SimilarWord* nowWord;                                       // Palabra actual
  
  NSCharacterSet *WrdsSep;                                    // Caracteres separadores de palabras

  UITextField* txtField;
  }

@property (weak, nonatomic) IBOutlet UILabel *lbWord;
@property (weak, nonatomic) IBOutlet UITableView *ListWords;
@property (weak, nonatomic) IBOutlet UIView *IntroDatos;
@property (weak, nonatomic) IBOutlet UITextField *txtNewWord;
@property (weak, nonatomic) IBOutlet UITextField *txtNewVerb;
@property (weak, nonatomic) IBOutlet UIButton *bntLeftWrd;
@property (weak, nonatomic) IBOutlet UIButton *btnRightWrd;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableHeight;

- (IBAction)OnGetLeftWrd:(id)sender;
- (IBAction)OnGetRightWrd:(id)sender;

- (IBAction)OnDeleteSel:(id)sender;
- (IBAction)OnAddWrd:(id)sender;
- (IBAction)OnAddVerb:(id)sender;
- (IBAction)OnFindPlus:(id)sender;

@end

//=========================================================================================================================================================
@implementation SearchController

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)viewDidLoad
  {
  [super viewDidLoad];
  
  WrdsSep = [NSCharacterSet characterSetWithCharactersInString:@" ,;:._¿?'´¡!\"[]()@-" ];
  Words   = [NSMutableArray new];
  
  CGRect frame = CGRectMake(0, 0, 15, 20);
  
  _txtNewWord.rightView = [[UIView alloc] initWithFrame:frame ];      // Deja espacio para botón de la izquierda
  _txtNewVerb.rightView = [[UIView alloc] initWithFrame:frame ];

  _txtNewWord.rightViewMode = UITextFieldViewModeAlways;
  _txtNewVerb.rightViewMode = UITextFieldViewModeAlways;
  
  // Notificaciones para cuando se muestra/oculta el teclado
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cada vez que ae va a mostrar la vista de busquedas avanzadas
- (BOOL) OpenFindPlusWithText:(UITextField*) txt
  {
  txtField = txt;
  
  NSArray< SimilarWord* > *OldWords = Words;
  Words = [NSMutableArray new];
  nowWord = nil;

  NSScanner *scan = [NSScanner scannerWithString:txt.text];
  scan.charactersToBeSkipped = WrdsSep;
  
  NSString* wrd;
  while( !scan.atEnd )
    {
    if( ![scan scanUpToCharactersFromSet:WrdsSep intoString:&wrd] )
      break;
  
    NSRange rg =  NSMakeRange( scan.scanLocation-wrd.length , wrd.length);
    
    BOOL exist = FALSE;
    
    for( SimilarWord* oldWrd in OldWords )
      if( [oldWrd.Wrd isEqualToString:wrd]  )
        {
        oldWrd.rg = rg;
        [Words addObject: oldWrd ];
        exist = TRUE;
        break;
        }
    
    if( !exist )
      [Words addObject: [SimilarWord WithWord:wrd AndRange:rg] ];
    }
  
  idxWord = 0;
  nowWord = Words[0];
  
  [self UpdateNowWord];
  return TRUE;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cada vez que se cierra la vista de busquedas avanzadas
- (void) CloseFindPlus
  {
//  UITextRange* savePos = txtField.selectedTextRange;
//  txtField.attributedText = [[NSMutableAttributedString alloc] initWithString:txtField.text attributes:nil];
  
//  NSMutableAttributedString* AttrTxt = [[NSMutableAttributedString alloc] initWithAttributedString:txtField.attributedText];
//  [AttrTxt removeAttribute:NSStrokeWidthAttributeName range:NSMakeRange(0, txtField.text.length)];
  
  txtField.defaultTextAttributes = attrEdit;
  txtField.typingAttributes      = attrEdit;
  
//  txtField.selectedTextRange     = savePos;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Actualiza la palabra actual
- (void) UpdateNowWord
  {
  _lbWord.text = nowWord.Wrd;
  
  NSMutableAttributedString* AttrTxt = [[NSMutableAttributedString alloc] initWithAttributedString:txtField.attributedText];
  
  [AttrTxt removeAttribute:NSStrokeWidthAttributeName range:NSMakeRange(0, txtField.text.length)];
  [AttrTxt addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithInteger:6] range:nowWord.rg];
  
  txtField.attributedText = AttrTxt;

  _btnRightWrd.hidden = (Words.count <= 1 );
  _bntLeftWrd.hidden  = (Words.count <= 1 );
  
  [_ListWords reloadData];
  [self ResizeTable];
  
  NSString *Verb = [ConjCore VerbInfinitive:nowWord.Wrd Lang:LGSrc];
  
  if( Verb.length > 0 ) _txtNewVerb.text = Verb;
  else                  _txtNewVerb.text = @"";
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLayoutSubviews
  {
  [self ResizeTable];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)didReceiveMemoryWarning
  {
  [super didReceiveMemoryWarning];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)OnGetLeftWrd:(id)sender
  {
  HideKeyboard();

  --idxWord;
  if( idxWord<0 ) idxWord = (int)Words.count-1;
  
  nowWord = Words[idxWord];
  [self UpdateNowWord];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)OnGetRightWrd:(id)sender
  {
  HideKeyboard();

  ++idxWord;
  if( idxWord >= Words.count )
    idxWord = 0;
  
  nowWord = Words[idxWord];
  [self UpdateNowWord];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)OnDeleteSel:(id)sender
  {
  NSInteger n = [_ListWords numberOfRowsInSection:0];
  for( int i=0; i<n; ++i)
    {
    NSIndexPath* idx = [NSIndexPath indexPathForRow:i inSection:0];
    UITableViewCell* cell = [_ListWords cellForRowAtIndexPath:idx];
    
    UIView* btnDel = [cell viewWithTag:333];
    if( btnDel==sender )
      {
      [nowWord DelSWordAt: i ];
  
      [_ListWords reloadData];
      [self ResizeTable];
      }
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime el boton para adicionar una palabra similar
- (IBAction)OnAddWrd:(id)sender
  {
  HideKeyboard();
  NSString* wrd = _txtNewWord.text;
  _txtNewWord.text = @"";

  [self AddWrd:wrd ];
  [self UpdateTable];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime el boton para adicionar todas las conjugaciones de un verbo
- (IBAction)OnAddVerb:(id)sender
  {
  HideKeyboard();
  
  [ConjCore LoadConjLang: LGSrc];                               // Carga la conjugación para el idioma actual

  NSString* Verb = _txtNewVerb.text;
  NSArray<NSString*>* SWords = nowWord.SWords;

  if( [ConjCore ConjVerb:Verb ] )                               // Si la palabra se puede conjugar
    {
    NSArray<NSString*> * Wrds = [ConjCore GetConjsList];        // Obtiene la lista de palabras de la conjugacion

    for (NSString* wrd in Wrds)
      {
      if( ![SWords containsObject:wrd] && [wrd characterAtIndex:0]!= '-' )
        [self AddWrd:wrd];
      }

    [self UpdateTable];
    _txtNewVerb.text = @"";
    }
  else
    {
    ShowMsg( @"TitleFindPlus", @"WordNoVerb"  );
//    [self.view.window makeFirstResponder:_ConjVerb ];
    }

  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime al boton de buscar
- (IBAction)OnFindPlus:(id)sender
  {
  HideKeyboard();
  
  [Ctrller FindFrasesWithQuery:[self FindWords] NWords:Words.count Options:0];
  }

///------------------------------------------------------------------------------------------------------------------------------------------------------------------
/// Busca palabras del query usando el diccionario de indices 'dictIndexs'
- (FOUNDS_ENTRY*) FindWords
  {
  FOUNDS_ENTRY* EntrysPos = [FOUNDS_ENTRY new];               // Entradas y posiciones de palabras en la entrada

  int nWrds = (int)Words.count;                               // Número de palabras en la consulta
  for( int i=0; i<nWrds; ++i )                                // Recorre todas las palabras
    {
    SimilarWord* wQry = Words[i];
    NUM_SET *Entries = [NUM_SET new];                         // Entradas encontradas

    [self AddEntriesWord:wQry.Wrd FoundEntries:EntrysPos EntriesInSameWord:Entries];    // Busca la palabra principal
    
    int nSin = (int)wQry.SWords.count;                        // Número de sinonimos de la palabra

    for( int j=0; j<nSin; ++j )                               // Recorre todos los sinonimos de la palabra
      {
      NSString* wrd  = wQry.SWords[j];                        // Toma la palabra a buscar

      [self AddEntriesWord:wrd FoundEntries:EntrysPos EntriesInSameWord:Entries];       // Busca el sinonimo de la palabra
      }
    }

  return EntrysPos;                                          // Retorna lista de entradas, con las posiciones de las palabras encontradas
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona las entradas donde esta la palabra 'wrd' a la lista de entradas encontradas
- (void) AddEntriesWord:(NSString*) wrd FoundEntries:(FOUNDS_ENTRY*) EntrysPos EntriesInSameWord:(NUM_SET *) Entries
  {
  wrd = [wrd lowercaseString];                            // Pone la palabra en minusculas
  wrd = QuitaAcentos(wrd, LGSrc);                         // Le quita los acentos

  EntryIndex* WrdData = DictIdx.Words[wrd];               // Obtiene todas las entradas donde esta la palabra

  if( WrdData==nil ) return;                              // No esta en el diccionario de indices de palabras, la salta

  for( int k=0; k<WrdData.Count; ++k)                     // Recorre todas las entradas donde esta la palabra
    {
    int iEntry = WrdData.Entrys[k];                       // Obtiene el indice de la entrada donde esta la palabra

    NSNumber* idx = GET_NUMBER( iEntry );                 // La convierte a un objeto

    if( [Entries containsObject:idx]  )                   // Ya fue encontrada una de las palabras del grupo en la entrada
      continue;                                           // Salta la palabra

    [Entries addObject:idx];                              // Adiciona la entrada a las encontradas

    INT_LIST *WrdsPos = EntrysPos[idx];                   // Busca si la entrada ya existe

    if( WrdsPos==nil )                                    // Si no hay ninguna palabra en esa entrada
      {
      WrdsPos = [INT_LIST new];                           // Crea una nueva lista de posiciones de palabras
      EntrysPos[idx] = WrdsPos;                           // Adiciona la lista a diccionario de entradas
      }

    [WrdsPos addObject:GET_NUMBER(WrdData.Pos[k])];       // Adiciona la posición a la lista posiciones de entrada idx
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Adiciona una palabra a la lista
- (void) AddWrd:(NSString*) wrd
  {
  wrd = [wrd stringByTrimmingCharactersInSet: NSCharacterSet.whitespaceAndNewlineCharacterSet];
  if( wrd.length == 0 ) return;
  
  for( NSString* s in nowWord.SWords )
    if( [s isEqualToString:wrd] ) return;
  
  [nowWord AddSWord: wrd ];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Actualiza el tamaño de la tabla y selecciona y hace visible la última fila
- (void) UpdateTable
  {
  [_ListWords reloadData];
  
  NSInteger iSel = nowWord.count-1;
  if( iSel>=0 )
    {
    NSIndexPath *sel = [NSIndexPath indexPathForRow:iSel inSection:0];
    [_ListWords selectRowAtIndexPath:sel animated:FALSE scrollPosition:UITableViewScrollPositionBottom];
    }
  
  [self ResizeTable];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Redimensiona el alto de la tabla, para que ocupe el espacio disponible lo mejor posible
- (void)ResizeTable
  {
  CGFloat hCont = _Scroll.contentSize.height;             // Altura actual del contenido del scroll
  if( hCont==0 ) return;                                  // No se ha inicializado el scroll, termina
  
  CGFloat hRow  = _ListWords.rowHeight;                   // Altura de las filas de la tabla
  CGFloat hDisp = _Scroll.frame.size.height;              // Altura disponible para la vista
  CGFloat hList = _ListWords.frame.size.height;           // Altura actual de la lista de palabras
  CGFloat hFija = hCont-hList;                            // Altura que no varia su tamaño
  int     rMax  = (int)((hDisp-hFija)/hRow);              // Número maximo de filas que se pueden mostrar
  int     nRow  = (int)nowWord.count;                      // Número de filas que debe tener la tabla
  
  if( nRow > rMax ) nRow = rMax;                          // No se puede mostrar más de las que caben
  if( nRow < 2    ) nRow = 2;                             // Por lo menos hay que mostrar 2 filas
  
  CGFloat hCal = nRow * hRow;                             // Altura calculada para la tabla
  if( _TableHeight.constant != hCal )                     // Si cambio la altura
    _TableHeight.constant = nRow * hRow;                  // Nueva altura para la tabla
  }

//---------------------------------------------------------------------------------------------------------------------------------------------
// Define el numero de items de la tabla.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
  {
  if( !nowWord )	return 0;
  
  return nowWord.count;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------
// Define el contenido de las celdas de la tabla.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
  {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordSimilarCell"];
  
	int idx = (int)[indexPath row];

  UILabel* lb = [cell viewWithTag:222];
  lb.text = nowWord.SWords[idx];
  
	return cell;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando se oprime la tecla retun durante la edicción de las palabras a adicionar
- (BOOL)textFieldShouldReturn:(UITextField *)textField
  {
  HideKeyboard();
  
  if( textField == _txtNewWord ) [self OnAddWrd:textField ];
  if( textField == _txtNewVerb ) [self OnAddVerb:textField];
  
  return TRUE;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Evento que se produce cuando se va ha mostrar el teclado
- (void)keyboardWillShow:(NSNotification *)notification 
  {
  if( _txtNewWord.isFirstResponder )
    {
    nowEdit = _txtNewWord;
    
    NSDictionary *userInfo = [notification userInfo];
  
    NSValue *KbSz = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rcKb = [self.view convertRect:[KbSz CGRectValue] fromView:nil];
  
    _BottomScroll.constant = rcKb.size.height;
    
    [self ResizeTable];
    }
  
  if( _txtNewVerb.isFirstResponder )
    {
    nowEdit = _txtNewVerb;
    
    NSDictionary *userInfo = [notification userInfo];
  
    NSValue *KbSz = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rcKb = [self.view convertRect:[KbSz CGRectValue] fromView:nil];
  
    _BottomScroll.constant = rcKb.size.height;
    
    [self ResizeTable];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Evento que se produce cuando se va a esaconder el teclado
- (void)keyboardWillHide:(NSNotification *)notification 
  {
  if( nowEdit == _txtNewWord || nowEdit == _txtNewVerb)
    {
    nowEdit = nil;
    
    _BottomScroll.constant = 0;
    
    [self ResizeTable];
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la palabra actual que se esta analizando
- (NSString*) GetActualWord
  {
  return _lbWord.text;
  }

@end

//=========================================================================================================================================================
