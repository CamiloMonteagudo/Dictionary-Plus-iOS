//===================================================================================================================================================
//  DatosView.h
//  MultiDict
//
//  Created by Camilo Monteagudo Preña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "ZoneDatosView.h"

//===================================================================================================================================================
// Botón para poner un icono y el cursor de la manito
@interface MarkNum : NSObject

@property (nonatomic) int Count;
@property (nonatomic) int Now;
  
+ (MarkNum*) Create;
  
@end

//===================================================================================================================================================
// Recuadro donde se ponen los datos de una entrada del diccionario
@interface DatosView : DatosViewBase <UITextViewDelegate>

@property (nonatomic) int src;
@property (nonatomic) int des;

@property (nonatomic, readonly) BOOL HasSustMarks;
@property (nonatomic, readonly) BOOL HSustMarks;

+ (DatosView*) DatosForIndex:(NSInteger) Idx;
+ (DatosView*) DatosForEntry:(EntryDict*) Entry Src:(int)src Des:(int)des;

- (CGFloat) ResizeWithWidth:(CGFloat) w;

- (NSString*) TextInKeyForMark:(NSString*) code;
- (NSString*) TextInDataForMark:(NSString*) code;

- (void) ResplaceMark:(NSString*) code TextSrc:(NSString*) srcTxt TextDes:(NSString*) desTxt;

- (NSString*) getSelWordAndLang:(int *)lang;

- (void) CopyText;
- (void) SelectedDatos;
- (void) SustWords;
- (void) UnSelectedDatos;

@end

//===================================================================================================================================================
