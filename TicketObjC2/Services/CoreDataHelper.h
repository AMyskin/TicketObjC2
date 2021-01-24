//
//  CoreDataHelper.h
//  TicketObjC2
//
//  Created by Alexander Myskin on 24.01.2021.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "Ticket.h"
#import "TicketObjC2-Swift.h"


@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

@end
