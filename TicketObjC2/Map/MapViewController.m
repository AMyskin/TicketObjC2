//
//  MapViewController.m
//  TicketObjC2
//
//  Created by Alexander Myskin on 13.01.2021.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"

#import "CoreDataHelper.h"

@interface MapViewController() <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) NSArray *tickets;
@end

@implementation MapViewController



- (instancetype)initMapViewController {
    self = [super init];
    if (self) {
        self.tickets = [NSArray new];
        self.title = NSLocalizedString(@"mapTitle", "");
    }
    return self;
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [self.mapView setDelegate:self];
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
 
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self.mapView addAnnotation:annotation];
            
            
        });
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"%@", view.annotation.subtitle);
    NSUInteger index = [mapView.annotations indexOfObject:view.annotation];
    NSLog(@"%@", mapView.annotations[index].subtitle);
    
    for (MapPrice *price in _prices) {
        CLLocationCoordinate2D coord = price.destination.coordinate;
        if (mapView.annotations[index].coordinate.latitude == coord.latitude){
            if (mapView.annotations[index].coordinate.longitude == coord.longitude){
               // [_showAlert: price];
                
                MapPrice *mapPrice = price;
            
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с точкой" message:@"Что необходимо сделать с выбранной точкой?" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *favoriteAction;
                if ([[CoreDataHelper sharedInstance] isFavoriteMapPrice: mapPrice]) {
                    favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [[CoreDataHelper sharedInstance] removeFromFavoriteMapPrice:mapPrice];
                    }];
                } else {
                    favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[CoreDataHelper sharedInstance] addToFavoriteMapPrice:mapPrice];
                    }];
                }

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:favoriteAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            }
        }
    }
    
    
    
    
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifer = @"Marker";
    MKMarkerAnnotationView *marker = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    if (!marker) {
        marker = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer];
        marker.canShowCallout = true;
        marker.calloutOffset = CGPointMake(-5, 5);
        marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        marker.rightCalloutAccessoryView = button;
    }
    marker.annotation = annotation;
    
    return marker;
    
}

- (void)buttonPressed {
    NSLog(@"Button pressed");
    
}

- (void) showAlert:(MapPrice *)mapPrice {
     
     
     NSLog(@"%ld" , (long)mapPrice.value);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с точкой" message:@"Что необходимо сделать с выбранной точкой?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavoriteMapPrice: mapPrice]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavoriteMapPrice:mapPrice];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavoriteMapPrice:mapPrice];
        }];
    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

