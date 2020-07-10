//=========================================================================================================================================================
//  DirPopUpView.m
//  Dictionary Plus
//
//  Created by Admin on 17/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//=========================================================================================================================================================

#import "DirPopUpView.h"
#import "AppData.h"

#define HROW    45
#define SEP_     3
#define WICON    30
#define WARROW   30
#define SEP_END  10

#define HPOP_UP  ( (DIRCount()*(HROW+SEP_)) + SEP_ )


//=========================================================================================================================================================
@interface DirPopUpView ()
  {
  UIView* popUp;
  
  SEL OnSelLang;
  id  InfoObj;
  
  CGFloat wPopUp;                 // Ancho total del popup para mostrar las direcciones
  CGFloat wSrcLng;                // Ancho de la parte del popup pertenciente al idioma fuente
  CGFloat wDesLng;                // Ancho de la parte del popup pertenciente al idioma destino
  }
@end

//=========================================================================================================================================================
@implementation DirPopUpView

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Crea un popup y lo posiciona relativo a la vista 'view' en la posicion definida por 'Pos' y desplazado en las magnitudes 'dx' y 'dy'
- (instancetype)initWithRefView:(UIView*) view AtLeft:(BOOL) left DeltaX:(int) dx DeltaY:(int) dy
  {
  _SelectedDir = -1;
  
  UIView* topView = FindTopView( view );
  if( topView==nil ) return nil;
  
  CGRect frame = topView.bounds;
  self = [super initWithFrame:frame];
  if( !self ) return self;
  
  self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.10];
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  [topView addSubview:self];
  
  [self CalculeWidth];
  
  CGRect rcRef = view.frame;
  CGRect rc;
  
  if( left ) rc.origin.x = rcRef.origin.x + dx;
  else       rc.origin.x = rcRef.origin.x + rcRef.size.width - wPopUp + dx;
  
  rc.origin.y = rcRef.origin.y + rcRef.size.height + dy;
  if( (rc.origin.y+HPOP_UP) > frame.size.height )
    rc.origin.y = frame.size.height - HPOP_UP;

  rc.size.width  = wPopUp;
  rc.size.height = 0;
  
  CGRect rcFrm = [self convertRect:rc fromView: view.superview ];
  
  popUp = [[UIView alloc] initWithFrame:rcFrm];
  
  popUp.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
  popUp.clipsToBounds = TRUE;
  
  [self AddLanguajes ];
  [self addSubview:popUp];
  
  if( popUp.center.x > topView.center.x )
    popUp.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  
  return self;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Calcula los ancho de los elementos de la lista de direcciones
- (void) CalculeWidth
  {
  wSrcLng = 0;
  wDesLng = 0;
  
  CGFloat fsz = [UIFont labelFontSize];
  UIFont* fnt = [UIFont systemFontOfSize:fsz];                                         // Fuente para los botones
  NSDictionary* attr = @{NSFontAttributeName:fnt};

  for( int i=0; i<DIRCount(); ++i)
    {
    int iSrc = DIRSrc(i);
    int iDes = DIRDes(i);

    NSString* sSrc = LGName(iSrc);
    NSString* sDes = LGName(iDes);

    CGSize szSrc = [sSrc sizeWithAttributes:attr];
    CGSize szDes = [sDes sizeWithAttributes:attr];
    
    if( szSrc.width > wSrcLng ) wSrcLng = szSrc.width;
    if( szDes.width > wDesLng ) wDesLng = szDes.width;
    }
  
  wDesLng += SEP_END;
  wPopUp = SEP_ + WICON + wSrcLng + WARROW + WICON + wDesLng + SEP_ ;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone todo los idiomas en la lista
- (void) AddLanguajes
  {
  int y = -(HPOP_UP) + SEP_;
  
  for( int i=0; i<DIRCount(); ++i )
    {
    CGRect rc = CGRectMake(SEP_, y, wPopUp-SEP_-SEP_, HROW);
    UIView* row = [[UIView alloc]  initWithFrame:rc ];
    
    row.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    row.backgroundColor  = [UIColor whiteColor];
    
    [self FillRow:row WihtDir:i ];
    
    [popUp addSubview:row ];
    
    y += (SEP_ + HROW);
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Rellena la fila con los datos del idioma dado
- (void) FillRow:(UIView*)row WihtDir:(int) dir
  {
  CGFloat x = 0;
  CGRect rcIcon1 = CGRectMake( x, 0, WICON, HROW );
  x+= WICON;
  
  CGRect rcText1 = CGRectMake( x, 12, wSrcLng, 21);
  x+= wSrcLng;

  CGRect rcArrow = CGRectMake( x, 0, WARROW, HROW);
  x+= WARROW;

  CGRect rcIcon2 = CGRectMake( x, 0, WICON, HROW);
  x+= WICON;

  CGRect rcText2 = CGRectMake( x, 12, wDesLng, 21);
  x+= wDesLng;

  UIImageView* Icon1 = [[UIImageView alloc] initWithFrame:rcIcon1];
  UILabel*     Text1 = [[UILabel     alloc] initWithFrame:rcText1];

  UIImageView* Arrow = [[UIImageView alloc] initWithFrame:rcArrow];

  UIImageView* Icon2 = [[UIImageView alloc] initWithFrame:rcIcon2];
  UILabel*     Text2 = [[UILabel     alloc] initWithFrame:rcText2];
  
  Icon1.contentMode = UIViewContentModeCenter;
  Arrow.contentMode = UIViewContentModeCenter;
  Icon2.contentMode = UIViewContentModeCenter;

  [row addSubview:Icon1];
  [row addSubview:Text1];
  [row addSubview:Arrow];
  [row addSubview:Icon2];
  [row addSubview:Text2];
  
  NSCharacterSet *sp = [NSCharacterSet whitespaceCharacterSet];
  
  int iSrc = DIRSrc(dir);
  int iDes = DIRDes(dir);

  Icon1.image = [UIImage imageNamed: LGFlagFile(iSrc,@"30") ];
  Text1.text = [LGName(iSrc) stringByTrimmingCharactersInSet:sp];
  
  Arrow.image = [UIImage imageNamed: @"LeftArrow" ];

  Icon2.image = [UIImage imageNamed: LGFlagFile(iDes,@"30") ];
  Text2.text = [LGName(iDes) stringByTrimmingCharactersInSet:sp];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Pone como seleccionada la fila idxRow
- (void) SelectRow:(int) idxRow
  {
  if( _SelectedDir != -1 )
    popUp.subviews[_SelectedDir].backgroundColor = [UIColor whiteColor];
  
  if( idxRow>=0 && idxRow< (int)popUp.subviews.count)
    {
    _SelectedDir = idxRow;
    popUp.subviews[idxRow].backgroundColor = [UIColor colorWithRed:0.7 green:0.95 blue:1.0 alpha:1.0];
    }
  else
    _SelectedDir = -1;
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//
- (void) ShowWithDir:(int)dir CallBack:(SEL)callBck Target:(id)target
  {
  OnSelLang = callBck;
  InfoObj   = target;
  
  [self SelectRow:dir];
  
  CGRect rc = popUp.frame;
  rc.size.height = HPOP_UP;
  
  [UIView animateWithDuration:0.5 animations:^{
    popUp.frame = rc;
  }];
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Cuando toca sobre el fondo de la pantalla
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
  {
  CGPoint pnt = [[touches anyObject] locationInView: popUp];     // Punto que se toco dentro de la vista
  
  int lng = -1;
  if( pnt.x>0 && pnt.x<wPopUp && pnt.y>0 && pnt.y<(HPOP_UP-SEP_) )
    {
    lng = (int)(pnt.y / (HROW+SEP_));
  
    if( lng==_SelectedDir ) lng = -1;
    }
  
  [self SelectRow: lng];
  
  CGRect rc = popUp.frame;
  rc.size.height = 0;
  
  [UIView animateWithDuration:0.5
    animations:^
      {
      popUp.frame = rc;
      }
    completion:^(BOOL finished)
      {
      [InfoObj performSelector:OnSelLang withObject:self afterDelay:0.0];
  
      [self removeFromSuperview];
      }];
  
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
//=========================================================================================================================================================
