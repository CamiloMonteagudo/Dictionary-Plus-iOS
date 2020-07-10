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

//===================================================================================================================================================
// Datos de las conjugaciones de un verbo
@interface DatosConjs : InfoDatos

@property (nonatomic) NSString* Verb;
@property (nonatomic)       int Lang;
@property (nonatomic)   CGFloat HText;

+ (DatosConjs*) DatosForWord:(NSString *) wrd Lang:(int)lng;

- (CGFloat) ResizeWithWidth:(CGFloat) w;

- (void) SelectedDatos;
- (void) UnSelectedDatos;

@end

//===================================================================================================================================================
// Celda en la tabla para representar las conjugaciones de un verbo
@interface DatosConjsCell : InfoCell

- (void) UseWithInfoDatos:(DatosConjs*) datos;
- (void) BckColor:(UIColor*) col;

@end

//===================================================================================================================================================
