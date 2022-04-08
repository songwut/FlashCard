//
//  UGCCreateMediaSwiftUIView.swift
//  flash
//
//  Created by Songwut Maneefun on 2/2/2565 BE.
//

import SwiftUI
import Combine
import Alamofire

struct UGCCreateMediaSwiftUIView: View {
    @Environment(\.presentationMode) var presentation
    
    @EnvironmentObject private var viewModel: UGCCreateMediaViewModel
    @StateObject private var playerVM = UGCPlayerViewModel()
    
    @State var isCreated: Bool
    @State private var isShowingImportFile = false
    @State private var isShowingMediaPicker = false
    @State private var isPreviewFullScreen = false
    @State private var image: UIImage?
    
    private let buttonInset: CGFloat = UIDevice.isIpad() ? 32 : 20
    private let buttonWidth: CGFloat = UIDevice.isIpad() ? 96 : 64
    
    var body : some View {
        
        ZStack {
            if self.viewModel.isShowMediaUpload() {
                
                //replace delegate and callback with onReceive "@Published"
                //@EnvironmentObject fource to use _
                UGCMediaUploadView(playerVM: self.playerVM)
                    .onReceive(self.playerVM.$isReciveFullscreen, perform: { isFullScreen in
                        if self.playerVM.isPlayerReady {
                            self.isPreviewFullScreen.toggle()
                        }
                    })
                    .environmentObject(self.viewModel)
                    .fullScreenCover(isPresented: $isPreviewFullScreen, onDismiss: {
                        print("isPreviewFullScreen :\(self.isPreviewFullScreen)")
                        //self.playerVM.isFullscreen = self.isPreviewFullScreen
                    }, content: {
                        /* normal fullscreen
                        UGCCustomPlayerView(isNeedMargin: true)
                            .environmentObject(self.viewModel)
                            .supportedOrientations(.landscape)
                        */
                        if let detail = self.viewModel.detail,
                           let mediaUrl = URL(string: detail.url ?? "") {
                            let contentCode = self.viewModel.contentCode
                            let currentTime = self.playerVM.currentTime
                            let model = UGCPlayerFullScreenViewModel(contentCode: contentCode,
                                                                     isNeedStopWhenClose: false,
                                                                        mediaUrl: mediaUrl,
                                                                     coverImage: detail.image,
                                                                     currentTime: currentTime)
                            UGCPlayerFullScreenSwiftUI(viewModel: model, playerVM: self.playerVM)
                                .supportedOrientations(.landscape)
                        }
                        
                    })
            } else {
                mediaEmptyView
                    .frame(alignment: .center)
            }
            buttonView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onAppear {
            if !self.isCreated, self.viewModel.mId <= 0 {
                viewModel.callAPICreateMaterial()
            } else {
                viewModel.callAPIMaterialDetail()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                //TODO: detech come from new uploading need dismiss
//                Button {
//                    presentation.wrappedValue.dismiss()
//                } label: {
//                    Text("post".localized())
//                }
                //TODO: may check upload 100%
                
                //isComeFromEditPost for protech case open infinity screen
                if self.viewModel.isShowMediaUpload() {
                    if self.viewModel.isComeFromEditPost {
                        Button {
                            self.presentation.wrappedValue.dismiss()
                        } label: {
                            Text("post".localized())
                                .foregroundColor(headerTextColor.color)
                        }
                        .disabled(self.viewModel.isDisablePost())

                    } else {
                        let destination = UGCPostView(item: self.viewModel.detail)
                        NavigationLink(destination: destination) {
                            
                            Text("post".localized())
                                .foregroundColor(headerTextColor.color)
                        }
                        .disabled(self.viewModel.isDisablePost())
                    }
                }
                
            }
        }
    }
    
    private var mediaEmptyView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(self.viewModel.uploadTitle())
                .font(.font(16, .text))
                .foregroundColor(.black)
            Text(self.viewModel.supportTypeText())
                .font(.font(14, .text))
                .foregroundColor(.config_secondary50())
        }
    }
    
    private var buttonView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            
            Button(action: {
                if self.viewModel.contentCode == .video {
                    if self.viewModel.detail.url == nil {
                        self.isShowingMediaPicker = true
                    } else {
                        let confirmBtn = ActionButton(title: "confirm".localized(), action: DidAction(handler: { sender in
                            self.isShowingMediaPicker = true
                        }))
                        let text = "warning_confirm_reupload".localized()
                        PopupManager.showWarning(text, confirm: confirmBtn)
                    }
                    
                } else if self.viewModel.contentCode == .audio  {
                    if self.viewModel.detail.url == nil {
                        self.isShowingImportFile = true
                    } else {
                        let confirmBtn = ActionButton(title: "confirm".localized(), action: DidAction(handler: { sender in
                            self.isShowingImportFile = true
                        }))
                        let text = "warning_confirm_reupload".localized()
                        PopupManager.showWarning(text, confirm: confirmBtn)
                    }
                }
                
            }, label: {
                Image("ic_v2_export")
                    .resizable()
                    .foregroundColor(.white)
                    .padding(.all, buttonInset)
            })
                .buttonStyle(ButtonCircle(color: .config_primary()))
                .frame(width: buttonWidth, height: buttonWidth, alignment: .bottom)
                .disabled(viewModel.mId == 0)
                .fileImporter(isPresented: $isShowingImportFile,
                              allowedContentTypes: [.audio],
                              onCompletion: { result in
                    do {//use until DocumentPickerSwiftUI is ready
                        let fileUrl = try result.get()
                        self.viewModel.mediaUrl = fileUrl
                        self.viewModel.uploadAudio(mediaUrl: fileUrl)
                    } catch {
                        print (error.localizedDescription)
                    }
                    
                })
                .sheet(isPresented: $isShowingMediaPicker) {
                    guard let mediaUrl = self.viewModel.mediaUrl else { return }
                    self.viewModel.uploadVideo(mediaUrl: mediaUrl)
                } content: {
                    ImagePickerView(image: self.$image, mediaUrl: $viewModel.mediaUrl,
                                    mediaTypes: ["public.movie"])
                }
            //DocumentPickerSwiftUI still fixing in 4.12 going to use in 5.0 UGC Doc
            /*
                .sheet(isPresented: $isShowingImportFile) {
                    guard let mediaUrl = self.viewModel.mediaUrl else { return }
                    self.viewModel.uploadAudio(mediaUrl: mediaUrl)
                } content: {
                    DocumentPickerSwiftUI(file: self.$viewModel.mediaUrl)
                }*/
            
            Spacer()
                .frame(height:50)
        }
        .frame(maxWidth: buttonWidth ,maxHeight: .infinity, alignment: .bottom)
    }
}

struct UGCCreateVideoView_Previews: PreviewProvider {
    static var previews: some View {
        UGCCreateMediaSwiftUIView(isCreated: true)
            .environmentObject(
                UGCCreateMediaViewModel(mId: nil, contentCode: .video)
            )
            .previewLayout(.fixed(width: 360, height: 700))
            .environment(\.sizeCategory, .small)
    }
}
