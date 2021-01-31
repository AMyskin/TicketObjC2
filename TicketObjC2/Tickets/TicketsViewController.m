//
//  TicketsViewController.m
//  TicketObjC2
//
//  Created by Alexander Myskin on 13.01.2021.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) NSArray *mapPrices;
@end

@implementation TicketsViewController {
    BOOL isFavorites;
    BOOL isFavoritesTickets;
}


- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        isFavoritesTickets = YES;
        self.tickets = [NSArray new];
        self.mapPrices = [NSArray new];
        self.title = @"Избранное";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = tickets;
        self.title = @"Билеты";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites ) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Tickets", @"MapPrice"]];
        [segmentedControl setFrame:CGRectMake(0.05*width, 0, 0.9*width, 0.03*height)];
        [segmentedControl setTintColor:[UIColor blueColor]];
        [segmentedControl setSelectedSegmentIndex:0];
        [segmentedControl addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmentedControl];
        
        
        
        self.navigationController.navigationBar.prefersLargeTitles = NO;
        _tickets = [[CoreDataHelper sharedInstance] favorites];
        _mapPrices = [[CoreDataHelper sharedInstance] favoritesMapPrice];
        [self.tableView reloadData];
        
    }
}



- (void)changeSegment:(UISegmentedControl*)sender {
    NSLog(@"Выбран сегмент номер %li", (long)[sender selectedSegmentIndex]+1);
    if ((long)[sender selectedSegmentIndex]) {
        isFavoritesTickets = NO;
        [self.tableView reloadData];
    } else {
        isFavoritesTickets = YES;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFavoritesTickets || !isFavorites) {
        return _tickets.count;
    } else {
        return _mapPrices.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];

    if (isFavorites) {
        if (isFavoritesTickets){
            cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
        } else {
            cell.mapPriceEntity = [_mapPrices objectAtIndex:indexPath.row];
        }
        
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) return;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



@end


