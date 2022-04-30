//
//  UGCPreviewDocSwiftUI.swift
//  UGC
//
//  Created by Songwut Maneefun on 19/4/2565 BE.
//

import SwiftUI
import PDFKit

struct UGCPreviewDocSwiftUI: View {
    @EnvironmentObject private var viewModel: UGCCreateMediaViewModel
    @StateObject private var docService = UGCDocService()
    @State private var isShowingImportFile = false
    @State private var pdfView: PDFView? = nil
    
    private let buttonInset: CGFloat = UIDevice.isIpad() ? 32 : 20
    private let buttonWidth: CGFloat = UIDevice.isIpad() ? 96 : 64
    
    var body : some View {
        ZStack {
            if self.viewModel.isShowUploading() {
                UGCUploadingView(bgColor: .clear,
                                 maxWidth: UIDevice.isIpad() ? 300 : nil,
                                 progress: self.$viewModel.loadingProgress)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding([.top, .bottom], 32)
                    .padding([.leading, .trailing], UIDevice.isIpad() ? 32 : 16)
                
                cancelUploadView
                    .padding([.top, .bottom], 32)
                    .padding([.leading, .trailing], UIDevice.isIpad() ? 32 : 16)
                
            } else {
                self.contentPreview
                    .frame(maxWidth: .infinity ,maxHeight: .infinity, alignment: .top)
                    .padding([.top, .bottom], UIDevice.isIpad() ? 32 : 16)
                    .padding([.leading, .trailing], UIDevice.isIpad() ? 140 : 16)
                self.buttonView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                let destination = UGCPostView(item: self.viewModel.detail)
                NavigationLink(destination: destination) {
                    Text("post".localized())
                        .foregroundColor(headerTextColor.color)
                }
                .disabled(self.viewModel.isDisablePost())
                
            }
        }
        .navigationTitle(self.viewModel.detail.nameContent)
        .onAppear {
            if self.viewModel.filePdfContent == nil {
                self.viewModel.readPdfDataFromDetail()
            }
            if self.pdfView == nil {
                self.pdfView = PDFView()
            }
            self.docService.prepareData(pdfView: self.pdfView)
        }
    }
    
    private var contentPreview : some View {
        VStack(alignment: .leading, spacing: UIDevice.isIpad() ? 16 : 8) {
            Text(self.docService.countText)
                .foregroundColor(Color("A9A9A9"))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
            
            if let pdfView = self.pdfView ,
                let fileContent = self.viewModel.filePdfContent {
                PDFKitRepresentedView(pdfView: pdfView,
                                      data: fileContent)
                    
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .border(.gray, width: 1)
            }
            
            
            HStack(alignment: .center, spacing: 16) {
                Toggle(isOn: self.$viewModel.isAllowDownload) {
                    EmptyView()
                }
                .onReceive(self.viewModel.$isAllowDownload) { newValue in
                    print("onReceive allow: \(newValue)")
                    if self.pdfView != nil {
                        self.viewModel.sendAllowDownload(newValue)
                    }
                }
                .toggleStyle(
                    SwitchToggleStyle(tint: .config_primary())//Color("AFB1B4")
                )
                .frame(maxWidth: 50, alignment: .leading)
                
                Text("allow_for_download_this_document".localized())
                    .multilineTextAlignment(.leading)
                    .font(.font(12, .regular))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .frame(maxWidth: UIDevice.isIpad() ? 400 : .infinity, alignment: .leading)
            
            Spacer(minLength: self.buttonWidth + 50)
        }
    }
    
    private var buttonView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            
            Button(action: {
                if self.viewModel.detail.url == nil {
                    self.isShowingImportFile = true
                } else {
                    let confirmBtn = ActionButton(title: "confirm".localized(), action: DidAction(handler: { sender in
                        self.isShowingImportFile = true
                    }))
                    let text = "warning_confirm_reupload".localized()
                    PopupManager.showWarning(text, confirm: confirmBtn)
                }
                
            }, label: {
                Image("ic_v2_export")
                    .resizable()
                    .foregroundColor(.white)
                    .padding(.all, self.buttonInset)
            })
                .buttonStyle(ButtonCircle(color: .config_primary()))
                .frame(width: self.buttonWidth, height: self.buttonWidth, alignment: .bottom)
                .disabled(viewModel.mId == 0)
                .fileImporter(isPresented: $isShowingImportFile,
                              allowedContentTypes: [.pdf],
                              onCompletion: { result in
                    do {//use until DocumentPickerSwiftUI is ready
                        let fileUrl = try result.get()
                        self.viewModel.mediaUrl = fileUrl
                        self.viewModel.uploadDoc(mediaUrl: fileUrl)
                        self.viewModel.isShowDocUpload = true
                    } catch {
                        print (error.localizedDescription)
                    }
                })
            
            Spacer()
                .frame(height:50)
        }
        .frame(maxWidth: self.buttonWidth ,maxHeight: .infinity, alignment: .bottom)
    }
    
    private var cancelUploadView: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                Spacer()
                Button {
                    self.viewModel.isCancelUpload = true
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40, alignment: .center)
                }
            }
            Spacer()
        }
    }
}

struct UGCPreviewDocSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        UGCPreviewDocSwiftUI()
            .environmentObject(UGCCreateMediaViewModel(mId: 0, contentCode: .pdf))
    }
}
