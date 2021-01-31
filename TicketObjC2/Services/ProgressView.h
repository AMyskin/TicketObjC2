//
//  ProgressView.h
//  TicketObjC2
//
//  Created by Alexander Myskin on 31.01.2021.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end

