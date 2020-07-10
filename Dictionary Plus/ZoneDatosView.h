//===================================================================================================================================================
//  ZoneDatosView.h
//  MultiDict
//
//  Created by Camilo Monteagudo Peña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import <UIKit/UIKit.h>

//===================================================================================================================================================
// Clase base para toda la información que se muestra en la zona de datos
@interface DatosViewBase : UIView

- (void) SelectedDatos;
- (void) UnSelectedDatos;

- (CGFloat) ResizeWithWidth:(CGFloat) w;

@end

//===================================================================================================================================================

//===================================================================================================================================================
// Zona donde se muestran los datos de las palabras
@interface ZoneDatosView : UIView

@property (nonatomic,readonly) int Count;              // Cantidad de datos que se estan mostrando

+(void) SelectDatos:(DatosViewBase*) view;
+(DatosViewBase*) SelectedDatos;

- (void) AddDatos:(DatosViewBase*) view;
- (void) AddDatosAfterSel:(DatosViewBase*) view;
- (void) ClearDatos;
- (void) DeleteSelectedDatos;

@end

//===================================================================================================================================================
