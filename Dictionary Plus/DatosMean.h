//===================================================================================================================================================
//  DatosMean.h
//  MultiDict
//
//  Created by Camilo Monteagudo Preña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "ZoneDatosView.h"
#import "ParseMeans.h"

//===================================================================================================================================================
// Botón para poner un icono y el cursor de la manito
@interface MarkNum : NSObject

@property (nonatomic) int Count;
@property (nonatomic) int Now;
  
+ (MarkNum*) Create;
  
@end

//===================================================================================================================================================
// Recuadro donde se ponen los datos de una entrada del diccionario
@interface DatosMean : InfoDatos

@property (nonatomic) int src;
@property (nonatomic) int des;

@property (nonatomic) CGFloat HText;

@property (nonatomic) BOOL HasSustMarks;
@property (nonatomic) BOOL HSustMarks;

@property (nonatomic) NSString* sKey;
@property (nonatomic) MeanWord* ActualWord;

+ (DatosMean*) DatosForIndex:(NSInteger) Idx;
+ (DatosMean*) DatosForEntry:(EntryDict*) Entry Src:(int)src Des:(int)des;

- (ParseMeans*) GetParseMeans;
- (void) CheckSelectedWord;
- (NSAttributedString*) GetAttrStr;

- (CGFloat) ResizeWithWidth:(CGFloat) w;

- (NSString*) TextInKeyForMark:(NSString*) code;
- (NSString*) TextInDataForMark:(NSString*) code;

//- (void) ResplaceMark:(NSString*) code TextSrc:(NSString*) srcTxt TextDes:(NSString*) desTxt;
//- (void) SustWords;

- (void) SelectedDatos;
- (void) UnSelectedDatos;

- (void) PreviosWord;
- (void) NextWord;
- (void) FindActualWord;
- (void) ConjActualWord;

@end

//===================================================================================================================================================
// Celda en la tabla para representar los datos de un significado
@interface DatosMeanCell : InfoCell <UITextViewDelegate>

- (void) SelWordInRange:(NSRange) rg;
- (void) UseWithInfoDatos:(DatosMean*) datos;

- (void) BckColor:(UIColor*) col;

@end

//===================================================================================================================================================
