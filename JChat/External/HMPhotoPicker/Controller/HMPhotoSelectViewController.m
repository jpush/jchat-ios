//
//  HMPhotoSelectViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "HMPhotoSelectViewController.h"
#import "ThumbImageCollectionViewCell.h"
#import "HMPhotoBrowserViewController.h"
#import "HMPhotoModel.h"
#import "HMPhotoPickerConstants.h"
#import "AppDelegate.h"

#define kPhotoGridViewFrame CGRectMake(0, 0, screenWidth,screenHeight - 45)
#define kBrowserBtnFrame CGRectMake(13, 10, 35, 16)
#define kSendBtnFrame CGRectMake(screenWidth - 45, 10, 35, 16)

@interface HMPhotoSelectViewController (){
  PHCachingImageManager *imageManager;
  NSMutableDictionary *selectedPhotoDic;// 已经选中的图片
  NSMutableArray *allPhotoArr;
  __weak IBOutlet UICollectionView *photoGridView;
  __weak IBOutlet UIButton *browserBtn;
  __weak IBOutlet UILabel *selectedPhotoLabel;
  __weak IBOutlet UIButton *sendBtn;
}



@end

@implementation HMPhotoSelectViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  selectedPhotoDic = @{}.mutableCopy;
  allPhotoArr = @[].mutableCopy;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancel)];
  
  selectedPhotoLabel.layer.masksToBounds = YES;
  selectedPhotoLabel.layer.cornerRadius = selectedPhotoLabel.frame.size.height / 2;
  
  imageManager = [[PHCachingImageManager alloc] init];

  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self selector:@selector(didSelectStatusChange:) name:kSelectStatusChange object:nil];
  [defaultCenter addObserver:self selector:@selector(finshToSelectPhoto) name:kFinishToSelectPhoto object:nil];
  if ([[[UIDevice currentDevice]systemVersion] floatValue]>= 8) {
    [self getAllPhotoWithPhotosFramework];
  } else {
    [self getAllPhotoWithAssert];
  }
  [self setUpCollectionView];
}

- (void)cancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getAllPhotoWithPhotosFramework {
  if (_allFetchResult == nil) {
    _allFetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)_photoCollection options:nil];
  }
  if (_photoCollection.localIdentifier == nil) {
    self.title = @"相机胶卷";
  } else {
    self.title = _photoCollection.localizedTitle;
  }
  
  PHFetchResult *allPhotoResult = _allFetchResult;
  for (int index = 0; index < [allPhotoResult count]; index ++) {
    PHAsset *asset = allPhotoResult[index];
    HMPhotoModel *model = [[HMPhotoModel alloc] init];
    [model setDataWithPhotoAsset:asset imageManager:imageManager];
    [allPhotoArr addObject:model];
  }
}

- (void)getAllPhotoWithAssert {

//    if (_photo_model_array == nil){
//      _photo_model_array = [[NSMutableArray alloc]init];
  
//      if (self.showAll_photo){
        [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
          if (group != nil) {
            
            //设置过滤对象
            ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:filter];
            
            //通过文件夹枚举遍历所有的相片ALAsset对象，有多少照片，则调用多少次block
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
              if (result != nil) {
                //将result对象存储到数组中
//                YBPhotoModel *photo_model = [[YBPhotoModel alloc]init];
//                photo_model.url = result.defaultRepresentation.url;
//                photo_model.isSelected = NO;
//                [_photo_model_array addObject:photo_model];
                HMPhotoModel *model = [[HMPhotoModel alloc] init];
                [model setDatawithAsset:result];
                [allPhotoArr addObject:model];
              }
            }];
            // 将所有获取的 照片模型 交给manager统一管理
//            [YBPhotePickerManager sharedYBPhotePickerManager].all_photo_array = _photo_model_array;
            
            [photoGridView reloadData];
            
          }
        } failureBlock:^(NSError *error) {
          UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"请允许访问相册,方可使用此功能!\n您可以在\"设置->隐私->照片\"中启用",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"设置",nil), nil];
          [alertView show];
        }];
        
//        self.showAll_photo = NO;
//      }else{
//        //通过文件夹枚举遍历所有的相片ALAsset对象，有多少照片，则调用多少次block
//        [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//          if (result != nil) {
//            //将result对象存储到数组中
//            YBPhotoModel *photo_model = [[YBPhotoModel alloc]init];
//            photo_model.url = result.defaultRepresentation.url;
//            photo_model.isSelected = NO;
//            [_photo_model_array addObject:photo_model];
//          }
//        }];
//      }
//    }


}
- (void)setUpCollectionView {
  photoGridView.minimumZoomScale = 0;
  photoGridView.contentOffset = CGPointMake(0, 64);
  [photoGridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [photoGridView registerNib:[UINib nibWithNibName:@"ThumbImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbImageCollectionViewCell"];
  [self.view addSubview:photoGridView];
  UICollectionViewFlowLayout *collectLayout = (UICollectionViewFlowLayout *)photoGridView.collectionViewLayout;
  NSLog(@"translucent %@",[UINavigationBar appearance].translucent?@"yes":@"no");
  if ([UINavigationBar appearance].translucent == YES) {
    collectLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 64);
  }
  
  photoGridView.backgroundColor = [UIColor whiteColor];
  photoGridView.delegate = self;
  photoGridView.dataSource = self;
}

- (IBAction)clickToBrowserSelectedPhotos:(id)sender {
  HMPhotoBrowserViewController *photoBrowserVC = [[HMPhotoBrowserViewController alloc] init];
  photoBrowserVC.photoCollection = _photoCollection;
  photoBrowserVC.imageManager = imageManager;
  photoBrowserVC.allFetchResult = _allFetchResult;
  photoBrowserVC.photoDelegate = _photoDelegate;
  photoBrowserVC.allPhotoArr = [NSMutableArray arrayWithArray:[selectedPhotoDic allValues]];
  NSIndexPath *browserIndex= [NSIndexPath indexPathForItem:0 inSection:0];
  photoBrowserVC.currentIndex = browserIndex;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
}
- (IBAction)sendSelectedPhotos:(id)sender {
  [self finshToSelectPhoto];
}

- (void)finshToSelectPhoto {
  if ([_photoDelegate respondsToSelector:@selector(HMPhotoPickerViewController:selectedPhotoArray:)]){
    __block NSMutableArray *selectedImageArr = @[].mutableCopy;
    
    for (NSString *key in selectedPhotoDic) {
      HMPhotoModel *photoModel = selectedPhotoDic[key];
      
      if (photoModel.largeImage == nil) {
        NSLog(@"fail to get large image");
        break;
      }
      
      [selectedImageArr addObject:photoModel.largeImage];
    }
    [_photoDelegate HMPhotoPickerViewController:self selectedPhotoArray:selectedImageArr];
  }
  [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didSelectStatusChange:(NSNotification *)notification {
  NSLog(@"get the notification %@",notification);

  HMPhotoModel *model = notification.object[0];
  NSLog(@"huangmin model  %@",model);
  UIButton *selectBtn = notification.object[1];

  if ([[[UIDevice currentDevice]systemVersion] floatValue]>= 8) {
    if (selectedPhotoDic[model.photoAsset] == nil) {
      if (selectedPhotoDic.count > 8) {
        [MBProgressHUD showMessage:@"最多选择9张图片" view:self.view];
        return;
      }
      [selectedPhotoDic setObject:model forKey:model.photoAsset];
    } else {
      [selectedPhotoDic removeObjectForKey:model.photoAsset];
    }
  } else {
    if (selectedPhotoDic[model.asset] == nil) {//shipei
      if (selectedPhotoDic.count > 8) {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [MBProgressHUD showMessage:@"最多选择9张图片" view:appDelegate.window];
        return;
      }
      [selectedPhotoDic setObject:model forKey:model.imgURL];
    } else {
      [selectedPhotoDic removeObjectForKey:model.imgURL];
    }
  }
  
  selectBtn.selected = !selectBtn.selected;
  model.isSelected = selectBtn.selected;
  if ([selectedPhotoDic count] > 0) {
    browserBtn.enabled = YES;
    selectedPhotoLabel.hidden = NO;
    selectedPhotoLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[selectedPhotoDic count]];
    sendBtn.enabled = YES;
  } else {
    browserBtn.enabled = NO;
    selectedPhotoLabel.hidden = YES;
    sendBtn.enabled = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO];
  [photoGridView reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return allPhotoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return CGSizeMake(80, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"ThumbImageCollectionViewCell";
  ThumbImageCollectionViewCell *cell = (ThumbImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  [cell setDataWithModel:allPhotoArr[indexPath.item]];
  return cell;
}

- (void)collectionView:(UICollectionView * _Nonnull)collectionView
didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
  HMPhotoBrowserViewController *photoBrowserVC = [[HMPhotoBrowserViewController alloc] init];
  photoBrowserVC.photoCollection = _photoCollection;
  photoBrowserVC.imageManager = imageManager;
  photoBrowserVC.allFetchResult = _allFetchResult;
  photoBrowserVC.allPhotoArr = allPhotoArr;
  photoBrowserVC.photoDelegate = _photoDelegate;
  photoBrowserVC.currentIndex = indexPath;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}



@end
