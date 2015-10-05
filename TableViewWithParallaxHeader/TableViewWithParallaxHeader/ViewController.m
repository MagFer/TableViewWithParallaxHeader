//
//  ViewController.m
//  TableViewWithParallaxHeader
//
//  Created by Ian Andoni Magarzo Fernández on 28/9/15.
//  Copyright (c) 2015 Ian Andoni Magarzo Fernández. All rights reserved.
//

#import "ViewController.h"
#import "StyleConstants.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>{

}

@property (weak, nonatomic) IBOutlet UIScrollView *canvasScrollView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctBottomHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;


@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctHeightTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctTopSpaceTableView;

@property (assign, nonatomic) CGFloat maxNegativeContentOffset;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadContent];
    [self loadStyles];
}

- (void)loadContent{
    //_headerTitle.text = @"Ian Magarzo Fernández"; //2 lines
    _headerTitle.text = @"Ian Magarzo"; //1 line
}
- (void)loadStyles{
    [_headerTitle sizeToFit];
    
    _maxNegativeContentOffset = kHeaderMaxHeigth - kHeaderMinHeigth - (_headerTitle.frame.size.height - 44);
    
    _ctHeightTableView.constant = self.view.frame.size.height - (kHeaderMaxHeigth - _maxNegativeContentOffset);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", indexPath.row];
    return cell;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1) { //TableViewScroll
        
        //HEADER HEIGHT
        if (_table.contentOffset.y < 0) _ctBottomHeaderView.constant = _table.contentOffset.y;
        else{
            _ctBottomHeaderView.constant = 0;
        }
        
        //TABLE
        if (_table.contentOffset.y < _maxNegativeContentOffset) {
            _canvasScrollView.contentOffset = _table.contentOffset;
            
            
        }else if(_table.contentOffset.y > _maxNegativeContentOffset && _table.contentSize.height > (_table.frame.size.height + _table.contentOffset.y)){
            
            _canvasScrollView.contentOffset = CGPointMake(0.0, _maxNegativeContentOffset);
            
        }else if (_table.contentSize.height < (_table.frame.size.height + _table.contentOffset.y)) { //Disable Bottom Bounce
            _table.contentOffset = CGPointMake(0.0, _table.contentSize.height - _table.frame.size.height);
        }
        
    }
}


@end
