//
//  TicketTableViewCell.m
//  TicketObjC2
//
//  Created by Alexander Myskin on 13.01.2021.
//

#import "TicketTableViewCell.h"


@interface TicketTableViewCell ()
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation TicketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:_priceLabel];
        
        _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_airlineLogoView];
        
        _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        _placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_placesLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:_dateLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, 100.0, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (UIImageView *)getMyImageFrom:(NSURL *)urlLogo {
    
    CGFloat width = self.bounds.size.width;
    
    
    NSLog(@"%@", urlLogo);
    UIImageView *imgView = [[UIImageView alloc] init];
   
    NSData *data=[NSData dataWithContentsOfURL:urlLogo];
    imgView.image=[UIImage imageWithData:data];
    CGFloat imgHeight =(width - 10) * imgView.image.size.height / imgView.image.size.width;
    [imgView setFrame:CGRectMake(5, 5, width - 10, imgHeight)];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    return imgView;
}

- (UIImage *)getOnlyImageFrom:(NSURL *)urlLogo {
    
    
    NSLog(@"%@", urlLogo);
    UIImage *myimgView = [[UIImage alloc] init];
   
    NSData *data=[NSData dataWithContentsOfURL:urlLogo];
    myimgView=[UIImage imageWithData:data];
  
    return myimgView;
}

- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    NSURL *urlLogo = AirlineLogo(ticket.airline);

  //  _airlineLogoView = [self getMyImageFrom:urlLogo];
    
    _airlineLogoView.image=[self getOnlyImageFrom:urlLogo];

    
    CGFloat width = self.bounds.size.width;
  // NSData *data=[NSData dataWithContentsOfURL:urlLogo];
  //  _airlineLogoView.image=[UIImage imageWithData:data];
    CGFloat imgHeight =(width - 10) * _airlineLogoView.image.size.height / _airlineLogoView.image.size.width;
    [_airlineLogoView setFrame:CGRectMake(5, 5, width - 10, imgHeight)];
    [_airlineLogoView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setFavoriteTicket:(FavoriteTicket *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld руб.", favoriteTicket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:favoriteTicket.departure];
    NSURL *urlLogo = AirlineLogo(favoriteTicket.airline);
    //[_airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}




@end
