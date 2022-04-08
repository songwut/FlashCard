//
//  UGCMediaUploadView.swift
//  UGC
//
//  Created by Songwut Maneefun on 2/3/2565 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Alamofire
import MapKit

struct UGCMediaUploadView: View {
    
    @EnvironmentObject private var viewModel: UGCCreateMediaViewModel
    @StateObject var playerVM: UGCPlayerViewModel
    
    @State private var isShowingMediaPicker = false
    private let buttonInset: CGFloat = UIDevice.isIpad() ? 32 : 20
    private let buttonWidth: CGFloat = UIDevice.isIpad() ? 96 : 64
    @State var mediaUrl: URL? = nil
    @State var paused: Bool = true
    
    private let pading = 16
    
    var body: some View {

        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                
                VStack {
                    //cover
                    topCoverView
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.all, 16)
                .frame(height: geometry.size.width * 9 / 16)
                
                //info
                infoView
                    .frame(minHeight: 80, maxHeight: 100)
                    .padding(.all, 16)
                
                //scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(self.viewModel.coverList, id:\UGCCoverModel.uuid) { cover in
                            UGCCoverItemView(item: cover)
                                .id(cover.uuid)
                                .foregroundColor(.white)
                                .frame(width: 128, height: 76)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture(perform: {
                                    if cover.image == nil {
                                        print("picker")
                                        self.isShowingMediaPicker = true
                                    } else {
                                        self.viewModel.callAPIUpdateCover(uiimage: nil, coverId: cover.id)
                                    }
                                })
                                .sheet(isPresented: $isShowingMediaPicker) {
                                    ImagePickerView(image: $viewModel.imagePicked, mediaUrl: $mediaUrl, mediaTypes: ["public.image"])
                                }
                        }
                    }
                    .padding(.leading, 16)
                }
                
                Spacer()
                
            }
        }
        
    }
    
    func updateCoverIndex(cover: UGCCoverModel, index: Int) {
        self.viewModel.coverList.remove(at: 0)
        self.viewModel.coverList.insert(cover, at: 0)
    }
    
    var coverCurrentImageView: some View {
        ImageView(url: self.viewModel.coverCurrentImage,
                  mode: .fill,
                  placeholder: defaultImage ?? UIImage())
    }
    
    var topCoverView: some View {
        ZStack {
            VStack {
                if let image = self.viewModel.imagePicked {
                    Image(uiImage: image)
                        .resizable()
                        .onAppear {
                            let cover = UGCCoverModel(id: nil, image: nil, uiimage: image)
                            self.updateCoverIndex(cover: cover, index: 0)
                            self.viewModel.callAPIUpdateCover(uiimage: image)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                } else if let _ = self.viewModel.imageId {
                    self.coverCurrentImageView
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                } else  {
                    self.coverCurrentImageView
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            //show progress UI when loadingProgress 0...99 %
            if self.viewModel.isShowUploading() {
                UGCUploadingView(progress: $viewModel.loadingProgress)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                cancelUploadView
                
            } else {
                if self.viewModel.isUploadReady() {
                    playButtonView
                    durationView
                } else if self.viewModel.isShowingPreview {
                    UGCCustomPlayerView(playerVM: self.playerVM, isNeedMargin: false)
                        .environmentObject(self.viewModel)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onReceive(self.playerVM.$isPlayerEnd) { isPlayerEnd in
                            if self.playerVM.isPlaying {
                                self.viewModel.isShowingPreview = !isPlayerEnd
                            }
                        }
                }
            }
            
            
        }
    }
    
    var durationView: some View {
        VStack {
            Spacer()
            
            HStack(alignment: .bottom, spacing: 16) {
                Spacer()
                
                Text(self.viewModel.durationTimeText())
                    .foregroundColor(.white)
                    .font(.font( UIDevice.isIpad() ? 16 : 10, .text))
                    .padding(.all, 4)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(4)
            }
            .padding(16)
        }
    }
    
    private var playButtonView: some View {
        VStack {
            Button(action: {
                self.viewModel.isShowingPreview = true
            }, label: {
                Image("ic_v2_play")
                    .resizable()
                    .foregroundColor(Color("222831"))
                    .padding(.all, buttonInset)
            })
                .buttonStyle(ButtonCircle(color: .white))
                .frame(width: buttonWidth, height: buttonWidth, alignment: .bottom)
        }
    }
    
    var cancelUploadView: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                Spacer()
                Button {
                    print("cancel upload")
                    self.viewModel.loadingProgress = -1
                    self.viewModel.callAPIMaterialDetail()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40, alignment: .center)
                }
            }
            Spacer()
        }
    }
    
    var infoView: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: Color.gray.opacity(0.2), radius: 16, x: 0, y: 2)
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(self.viewModel.detail.name)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                Text(self.viewModel.detail.fileSizeDisplay())
            }
            .padding([.all], 16)
        }
    }
}

struct UGCMediaUploadView_Previews: PreviewProvider {
    static var previews: some View {
        UGCMediaUploadView(playerVM: UGCPlayerViewModel())
            .environmentObject(UGCCreateMediaViewModel(mId: nil, contentCode: .video))
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
    }
}
