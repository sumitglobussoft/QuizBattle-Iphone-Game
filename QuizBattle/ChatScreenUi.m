//
//  ChatScreenUi.m
//  QuizBattle
//
//  Created by GLB-254 on 12/23/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "ChatScreenUi.h"
#import "PTSMessagingCell.h"
@implementation ChatScreenUi

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createTableUi];
    }
    return self;
}
-(void)createTableUi
{
    messageTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, self.frame.size.height)];
    messageTable.delegate=self;
    messageTable.dataSource=self;
    messageTable.separatorColor=[UIColor clearColor];
    messageTable.backgroundColor=[UIColor grayColor];
    //
    self.backgroundColor=[UIColor blackColor];
    [self addSubview:messageTable];

}
#pragma mark Table Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize messageSize = [PTSMessagingCell messageSize:[_messages objectAtIndex:indexPath.row]];
//    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 20.0f;
    return 20;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
//    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
//    //History messages
//    if([self.historyMessages count]>indexPath.row)
//    {
//        NSLog(@"%lu",(unsigned long)[self.historyMessages count]);
//        QBChatAbstractMessage * msg=[self.historyMessages objectAtIndex:indexPath.row];
//        NSLog(@"Messages: %@ id %lu", msg.text,(unsigned long)msg.recipientID);
//        
//        if([[SingletonClass sharedSingleton].quickBloxId intValue]==msg.senderID)
//        {
//            ccell.sent=YES;
//            ccell.avatarImageView.image=[SingletonClass sharedSingleton].imageUser;
//            
//        }
//        else
//        {
//            ccell.sent=NO;
//            ccell.avatarImageView.image=self.opponenetImage;
//            
//        }
//        ccell.messageLabel.text = [_messages objectAtIndex:indexPath.row];
//    }
//    //Normal messages
//    else
//    {
//        ccell.messageLabel.text = [_messages objectAtIndex:indexPath.row];
//        ccell.sent=senderFlag;
//        if(ccell.sent)
//        {
//            ccell.avatarImageView.image=[SingletonClass sharedSingleton].imageUser;
//        }
//        else
//        {
//            ccell.avatarImageView.image=self.opponenetImage;
//        }
//        
//    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
