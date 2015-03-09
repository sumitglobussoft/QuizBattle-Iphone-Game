//
//  PurchaseTableViewCell.h
//  QuizBattle
//
//  Created by GBS-mac on 9/19/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *messageLable;
@property (nonatomic, strong) UILabel *lblDescription;
@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UIButton * buyButton;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIImageView *picIcon;
@property (nonatomic, strong) UIImageView *picArrow;
@property (nonatomic, strong) UIImageView *picBooster;
@property (nonatomic, strong) UILabel *lblBoosterDetail;
@property (nonatomic, strong) UILabel *lblLifeDetail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectedButton:(NSString*)selectedButton;
@end
