//
//  TicketTableViewCell.h
//  TicketObjC2
//
//  Created by Alexander Myskin on 13.01.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"
#import "TicketObjC2-Swift.h"

NS_ASSUME_NONNULL_BEGIN


@interface TicketTableViewCell : UITableViewCell

#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", iata]];
@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicket *favoriteTicket;
@property (nonatomic, strong) MapPriceEntity *mapPriceEntity;

@end

NS_ASSUME_NONNULL_END
