//=========================================================================================================================================================
//  ParseMeans.h
//  Dictionary Plus
//
//  Created by Admin on 12/4/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import <Foundation/Foundation.h>

//=========================================================================================================================================================
// Contiene lo datos de una de las palabras del significado
@interface MeanWord : NSObject

+ (instancetype) MeanWordWithWord:(NSString*) wrd Range:(NSRange) rg Lang:(int) lg;

@property (nonatomic) NSString* Wrd;   // Palabra que representa
@property (nonatomic) NSRange   Rg;    // Rango donde en el que se encuentra la  palabra
@property (nonatomic) int       lng;   // Idioma de la palabra

@end

//=========================================================================================================================================================
// Maneja todas las palabras que se pueden buscar o conjugar dentro de un significado
@interface ParseMeans : NSObject

@property (nonatomic,readonly) int Count;                              // Retorna el número de palabras parseadas
@property (nonatomic)          int Actual;                             // Retorna la palabra actual

+ (instancetype) ParseWithStr:(NSString*) str LangSrc:(int) src LangDes:(int) des;

- (MeanWord*) WordInRange:(NSRange) rg;
- (MeanWord*) GetAtIndex:(int) idx;
- (MeanWord*) GetSelected;

- (void) GetNext;
- (void) GetPrevios;


@end

//=========================================================================================================================================================
