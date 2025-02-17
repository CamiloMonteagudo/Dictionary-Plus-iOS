//===================================================================================================================================================
//  AppData.h
//  PruTranslate
//
//  Created by Camilo on 31/12/14.
//  Copyright (c) 2014 Softlingo. All rights reserved.
//===================================================================================================================================================

#import <UIKit/UIKit.h>
#import "DictMain.h"
#import "DictIndexes.h"
#import "ViewController.h"

//===================================================================================================================================================
#define LGCount     4
#define SEP         4
#define HSUST_DATA  22

//#define WBTNS       20
//#define HBTNS       20
//
//#define SWAP_DICT   0x0001
//#define DEL_ALL     0x0002
//#define DEL_SEL     0x0004
//#define COPY_TEXT   0x0008
//#define CONJ_WRD    0x0010
//#define TRD_WRD     0x0020
//
//#define All_BTNS    0xFFFF
//
#define FULL_FRASE  0x0001
//#define VERB_UP     0x0002

#define BRD_W  1                  // Ancho del borde de las zonas redondeadas

#define ROUND  8                  // Radio de redondeo de las esquinas
#define R_SUP  0x0001             // Lleva redondeo en la parte superior
#define R_INF  0x0002             // Lleva redondeo en la parte inferior
#define R_ALL  0x0003             // Llava redondeo en todas las esquinas


//===================================================================================================================================================
// Define tipos de datos para la búsqueda
#define INT_LIST      NSMutableArray<NSNumber*>
#define FOUNDS_ENTRY  NSMutableDictionary<NSNumber*,  INT_LIST*>
#define NUM_SET       NSMutableSet<NSNumber*>
#define GET_NUMBER(n) [NSNumber numberWithInt:n]

//===================================================================================================================================================

extern int  LGSrc;
extern int  LGDes;
extern int  LGConj;
extern int  iUser;
extern BOOL iPad;
extern UIView* nowEdit;               // Vista que mostro el teclado

extern DictMain*       Dict;
extern DictIndexes*    DictIdx;

extern ViewController* Ctrller;

extern NSCharacterSet* lnSep;
extern NSCharacterSet* kySep;
extern NSCharacterSet* TypeSep;
extern NSCharacterSet* MeanSep;
extern NSCharacterSet* wrdSep;
extern NSCharacterSet* PntOrSpc;
extern NSCharacterSet* TrimSpc;

extern UIColor* SelColor;
extern UIColor* SustColor;
extern UIColor* BackColor;

//===================================================================================================================================================
extern NSString* LGFlag( int lng);
extern NSString* LGAbrv( int lng );
extern NSString* LGName( int lng );
extern NSString* LGFlagName( int lng );
extern NSString* LGFlagFile( int lng, NSString* Suxfix );

extern int       DIRSrc( int iDir );
extern int       DIRDes( int iDir );
extern int       DIRFromLangs(int src, int des);
extern int       DIRFirst();
extern int       DIRCount();

extern int CNJCount();
extern int CNJLang( int idx );
extern NSString* CNJTitle( int idx );
extern void HideKeyboard();
extern UIView* FindTopView( UIView* FromView );


NSString* IndexDictName( int src, int des );
NSString* MainDictName( int src, int des );
NSString* PathForDict(NSString* FName);

extern BOOL IsLetter( NSInteger idx, NSString* Txt );
extern int HexDigit(int idx, NSString* str );

extern NSString* QuitaAcentos( NSString* wrd, int lng );
extern void WaitMsg();

extern void DrawRoundRect( CGRect rc, int Round, UIColor* ColBrd, UIColor* ColBody );
extern void ShowMsg( NSString* title, NSString* msg );

//===================================================================================================================================================


