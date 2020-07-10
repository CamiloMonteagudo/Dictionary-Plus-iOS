//===================================================================================================================================================
//  ZoneDatosView.h
//  MultiDict
//
//  Created by Camilo Monteagudo Peña on 3/1/17.
//  Copyright © 2017 BigXSoft. All rights reserved.
//===================================================================================================================================================

#import <UIKit/UIKit.h>

@class InfoDatos;
//===================================================================================================================================================
// Clase base para mostrar información en la lista de la derecha
@interface InfoCell : UITableViewCell

@property (nonatomic, weak) InfoDatos* Datos;

- (void) UseWithInfoDatos:(InfoDatos*) datos;
- (void) BckColor:(UIColor*) col;

@end

//===================================================================================================================================================
// Clase base para los datos de la información que se muestra a la derecha
@interface InfoDatos : NSObject

@property (nonatomic) NSString* CellName;
@property (nonatomic, weak) InfoCell* Cell;

- (CGFloat) ResizeWithWidth:(CGFloat) w;

- (void) SelectedDatos;
- (void) UnSelectedDatos;

@end

//===================================================================================================================================================

//===================================================================================================================================================
// Zona donde se muestran los datos de las palabras
@interface ZoneDatosView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,readonly) int Count;              // Cantidad de datos que se estan mostrando

+(void) SelectDatos:(InfoDatos*) view;
+(InfoDatos*) SelectedDatos;

- (void) AddDatos:(InfoDatos*) view Select:(BOOL) sel;
- (void) AddDatosAfterSel:(InfoDatos*) view;
- (void) ClearDatos;
- (void) DeleteSelectedDatos;

- (void) UpdateInfo;
- (void) SelectFirst;

@end

//===================================================================================================================================================
