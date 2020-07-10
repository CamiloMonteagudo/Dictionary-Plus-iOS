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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableTop;


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
  
  [self ResizeTable];
  
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
  UITextRange* savePos = txtField.selectedTextRange;
  txtField.attributedText = [[NSMutableAttributedString alloc] initWithString:txtField.text];
  txtField.selectedTextRange = savePos;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Actualiza la palabra actual
- (void) UpdateNowWord
  {
  _lbWord.text = nowWord.Wrd;
  
  NSMutableAttributedString* AttrTxt = [[NSMutableAttributedString alloc] initWithString:txtField.text];
  [AttrTxt addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithInteger:6] range:nowWord.rg];
  
  txtField.attributedText = AttrTxt;

  _btnRightWrd.hidden = (Words.count <= 1 );
  _bntLeftWrd.hidden  = (Words.count <= 1 );
  
  [_ListWords reloadData];
  [self ResizeTable];
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
//
- (IBAction)OnAddWrd:(id)sender
  {
  HideKeyboard();
  NSString* wrd = _txtNewWord.text;
  _txtNewWord.text = @"";

  [self AddWrd:wrd ];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)OnAddVerb:(id)sender
  {
  HideKeyboard();
  
//  NSString* wrd = _txtNewVerb.text;
  _txtNewVerb.text = @"";

  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (IBAction)OnFindPlus:(id)sender
  {
  HideKeyboard();
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
  [_ListWords reloadData];
  
  NSUInteger  iSel = nowWord.count-1;
  NSIndexPath *sel = [NSIndexPath indexPathForRow:iSel inSection:0];
  [_ListWords selectRowAtIndexPath:sel animated:FALSE scrollPosition:UITableViewScrollPositionTop];
  
  [self ResizeTable];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Redimensiona el alto de la tabla, para que ocupe el espacio disponible lo mejor posible
- (void)ResizeTable
  {
  CGFloat hRow = _ListWords.rowHeight;                    // Altura de las filas de la tabla
  
  CGFloat hDisp = _Scroll.frame.size.height;              // Altura disponible para la vista
  CGFloat  dtY  = hDisp - _Scroll.contentSize.height;     // Espacio disponible para crecer
  
  CGFloat HNow = _TableHeight.constant;                   // Altura actual de la tabla
  int     nRow = (int)((HNow + dtY) / hRow);              // Número de filas que se puede tener la tabla
  
  NSInteger nWrds = nowWord.count;                        // Número de palabras a mostrar
  if( nRow > nWrds ) nRow = (int)nWrds;                   // Limita el # de filas al # de palabras
  
  if( nRow < 2 ) nRow = 2;                                // Por lo menos hay que mostrar 2 filas
  _TableHeight.constant = nRow * hRow;                    // Nueva altura para la tabla
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

//---------------------------------------------------------------------------------------------------------------------------------------------
// Se llama cuando comienza la edicion de un campo de texto
- (void)textFieldDidBeginEditing:(UITextField *)textField
  {
  }

//---------------------------------------------------------------------------------------------------------------------------------------------
//
- (void)textFieldDidEndEditing:(UITextField *)textField
  {
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


@end

//=========================================================================================================================================================
