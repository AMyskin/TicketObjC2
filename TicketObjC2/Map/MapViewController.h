//
//  MapViewController.h
//  TicketObjC2
//
//  Created by Alexander Myskin on 13.01.2021.
//


#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "MapPrice.h"



@interface MapViewController : UIViewController

- (instancetype)initMapViewController;
- (void) showAlert:(MapPrice *)mapPrice;

@end


