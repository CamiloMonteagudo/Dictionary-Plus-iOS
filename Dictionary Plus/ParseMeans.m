//=========================================================================================================================================================
//  ParseMeans.m
//  Dictionary Plus
//
//  Created by Admin on 12/4/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "ParseMeans.h"
#import "AppData.h"

//=========================================================================================================================================================
@interface ParseMeans()
  {
  NSMutableArray<MeanWord*>* Words;
  
  int Lang;

  NSString* Text;
  }
@end


//=========================================================================================================================================================
@implementation ParseMeans

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea el objeto a partir de la cadena que hay que analizar
+ (instancetype) ParseWithStr:(NSString*) str LangSrc:(int) src LangDes:(int) des
  {
  ParseMeans* obj = [ParseMeans new];

  obj->Lang = -1;
  [obj ParseStr:str LangSrc:src LangDes:des];
  
  return obj;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Retorna el numero de palabras detectadas
-(int)Count
  {
  return (int) Words.count;
  }

static NSCharacterSet* BreakFrase = [NSCharacterSet characterSetWithCharactersInString:@";|\U00002029>*?!"];

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Selecciona la primera palabra que se encuentre en el rango dado
- (MeanWord*) WordInRange:(NSRange) rg
  {
  _Actual = -1;
  if( rg.length ==0 ) return nil;
  
  for (int i=0; i<Words.count; ++i)
    {
    MeanWord* wrd = Words[i];
    
    if( wrd.Rg.location < rg.location ) continue;
    
    NSInteger ini = wrd.Rg.location;
    NSInteger len = (rg.location + rg.length) - ini;
    if( len <= 0) return nil;
      
    NSRange    newRg = NSMakeRange(ini, len);
    NSString *selStr = [Text substringWithRange:newRg ];
      
    NSInteger end = [selStr rangeOfCharacterFromSet:BreakFrase].location;
    if( end != NSNotFound )
      {
      newRg.length = end;
      selStr = [Text substringWithRange:newRg ];
      }

    _Actual = i;
    return [MeanWord MeanWordWithWord:selStr Range:newRg Lang:wrd.lng ];
    }
  
  return nil;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la palabra con indice 'idx'
- (MeanWord*) GetAtIndex:(int) idx
  {
  if( idx<0 || idx>=Words.count ) return nil;
  
  return Words[idx];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la palabra seleccionada o actual
- (MeanWord*) GetSelected
  {
  if( _Actual<0 || _Actual>=Words.count ) return nil;
  
  return Words[_Actual];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la proxima palabra
- (void) GetNext
  {
  ++_Actual;
  if( _Actual>=Words.count ) _Actual=0;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtiene la palabra antarior
- (void) GetPrevios
  {
  --_Actual;
  if( _Actual<0 ) _Actual=(int)Words.count-1;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
static NSCharacterSet* CharsStop = [NSCharacterSet characterSetWithCharactersInString:@" ;|\U00002029><*¿?¡!"];
static NSCharacterSet* CharsInit = [NSCharacterSet characterSetWithCharactersInString:@" ><*¿?¡!"];

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Analiza la cadena 'Str' y almacena la información en el objeto
-(void) ParseStr:(NSString*) str LangSrc:(int) src LangDes:(int) des
  {
  Text  = str;
  Words = [NSMutableArray new];
  
  int nowLng = src;
  NSScanner* sc = [NSScanner scannerWithString:str];
  sc.charactersToBeSkipped = nil;
  
  while( !sc.atEnd )
    {
    NSString* wrd;
    
    [sc scanCharactersFromSet:CharsInit intoString:nil];
    
    NSInteger Ini =sc.scanLocation;
    
    [sc scanUpToCharactersFromSet:CharsStop intoString: &wrd];

    if( wrd!=nil )
      [self GetWorFromStr:wrd At:Ini Lang:nowLng];
    
    if( sc.atEnd ) break;
    
    if( [str characterAtIndex:sc.scanLocation] == 0x2029 )
      nowLng = des;
    
    sc.scanLocation += 1;             // Salta el caracter encontrado
    }
  
  _Actual = 0;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
-(void) GetWorFromStr:(NSString*)wrd At:(NSInteger)Ini Lang:(int)nowLng
  {
  NSInteger len = wrd.length;
  
  if( Lang != nowLng )
    {
    wrd = [wrd stringByReplacingOccurrencesOfString:LGFlag(nowLng) withString:@"" ];      // Quita las banderitas
    
    NSInteger lenTmp = wrd.length;
    Ini += (len-lenTmp);
    
    len  = lenTmp;
    Lang = nowLng;
    }
  
  if( len==0 ) return;

  unichar cLast = [wrd characterAtIndex:len-1];
  if( cLast=='.' || cLast==')' || cLast==']' ) return;

  if( [wrd integerValue] != 0 ) return;
  
  NSRange rg = NSMakeRange(Ini, len);
  
  MeanWord* Word = [MeanWord MeanWordWithWord:wrd Range:rg Lang:Lang];
  
  [Words addObject:Word];
  }

@end
//=========================================================================================================================================================

//=========================================================================================================================================================
// Contiene lo datos de una de las palabras del significado
@implementation MeanWord

//--------------------------------------------------------------------------------------------------------------------------------------------------------
+ (instancetype) MeanWordWithWord:(NSString*) wrd Range:(NSRange) rg Lang:(int) lg
  {
  MeanWord* obj = [MeanWord new];
  
  obj.Wrd = wrd;
  obj.Rg  = rg;
  obj.lng = lg;
  
  return obj;
  }

@end

