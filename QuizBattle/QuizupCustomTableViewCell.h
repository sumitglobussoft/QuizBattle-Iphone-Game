//
//  QuizupCustomTableViewCell.h
//  QuizupCustomTableView
//
//  Created by GBS-ios on 10/21/14.
//  Copyright (c) 2014 Globussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizupCustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic ,strong) UIButton *playNowButton;
@property (nonatomic ,strong) UIButton *challengeButton;
@property (nonatomic ,strong) UIButton *rankingButton;
@property (nonatomic ,strong) UIButton *discussionButton;
@end
