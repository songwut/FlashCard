//
//  UGCCreateDocSwiftUI.swift
//  UGC
//
//  Created by Songwut Maneefun on 4/4/2565 BE.
//

import SwiftUI

struct UGCCreateDocSwiftUI: View {
    @EnvironmentObject private var viewModel: UGCCreateMediaViewModel
    
    @State var isCreated: Bool
    @State var isShowingImportFile = false
    private let iconSize: CGFloat = UIDevice.isIpad() ? 48 : 32
    
    var body: some View {
        VStack {
            if self.viewModel.isDetailReady {
                if self.viewModel.isShowDocUpload || self.viewModel.isShowDocPreview()  {
                    UGCPreviewDocSwiftUI()
                        .environmentObject(self.viewModel)
                } else {
                    self.uploadContentView
                }
            } else {
                ActivityLoadingView(isLoading: true)
            }
        }
        .onAppear {
            if !self.isCreated, self.viewModel.mId <= 0 {
                viewModel.callAPICreateMaterial()
            } else {
                viewModel.callAPIMaterialDetail()
            }
        }
        .navigationTitle(self.viewModel.detail.nameContent)
    }
    
    var uploadContentView: some View {
        ZStack {
            self.uploadView
                .background(UIColor.config_primary_10().color)
                .padding([.leading, .trailing], UIDevice.isIpad() ? 32 : 16 )
                .padding([.top, .bottom], 32)
                .onTapGesture {
                    self.isShowingImportFile.toggle()
                }
                .fileImporter(isPresented: $isShowingImportFile,
                              allowedContentTypes: [.pdf],
                              onCompletion: { result in
                    do {//use until DocumentPickerSwiftUI is ready
                        let fileUrl = try result.get()
                        self.viewModel.mediaUrl = fileUrl
                        self.viewModel.uploadDoc(mediaUrl: fileUrl)
                        self.viewModel.isShowDocUpload = true
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                })
        }
    }
    
    var uploadView: some View {
        VStack {
            ZStack {
                let color = UIColor.config_primary().color
                let sStyle = StrokeStyle(lineWidth: 1, dash: [5])
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(color, style: sStyle)
                
                VStack(alignment: .center, spacing: 16) {
                    Image("ic_v2_export")
                        .resizable()
                        .padding(.all, 2)
                        .frame(width: self.iconSize, height: self.iconSize, alignment: .center)
                        .foregroundColor(color)
                    
                    Text(String(format: "upload_a_xx".localized(), "document").localized().lowercased())
                        .foregroundColor(color)
                        .font(.font( UIDevice.isIpad() ? 22 : 16, .text))
                        .padding(.top, -8)
                    
                    Text("accept_only".localized() + " pdf.")
                        .foregroundColor(color.opacity(0.5))
                        .font(.font(UIDevice.isIpad() ? 16 : 14, .text))
                        .padding(.top, -8)
                }
            }
        }
    }
}

struct UGCCreateDocSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        UGCCreateDocSwiftUI(isCreated: false)
            .previewLayout(.fixed(width: 320.0, height: 400))
            .environment(\.sizeCategory, .small)
            .environmentObject(UGCCreateMediaViewModel(mId: 0, contentCode: .pdf))
    }
}
