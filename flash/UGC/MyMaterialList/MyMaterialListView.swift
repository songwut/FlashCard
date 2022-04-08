//
//  MyMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI

struct MyMaterialListView: View {
    @EnvironmentObject var viewModel: MyMaterialListViewModel

    @State var isCreate =  true
    @State var myMaterialFlash: MaterialFlashPageResult?
    @State var list = [LMMaterialResult]()
    
    @State private var isLoading = true
    @State private var scrollViewSize: CGSize = .zero
    @State private var isPreviewItem: Bool = false
    @State private var isEditItem: Bool = false
    @State private var selectedItem: LMMaterialResult?
    
    private let navTitle = "my_material".localized()
    private let cellMargin: CGFloat = 0
    private let limitItem = 3
    private let column = UIDevice.isIpad() ? 2 : 1
    private let margin: CGFloat = UIDevice.isIpad() ? 16 : 8
    private let headerHeight: CGFloat = UIDevice.isIpad() ? 132 : 100
    private let gridConfig: GridConfig = {
        let isIpad = UIDevice.isIpad()
        return GridConfig(vSpacing: isIpad ? 16 : 8,
                          hSpacing: isIpad ? 16 : 8)
    }()
    
    init() {
        UITableView.appearance().backgroundColor = .white
        UITableViewCell.appearance().backgroundColor = .white
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .topLeading, content: {
                if isLoading {
                    ActivityLoadingView(isLoading: true)
                }
                //self.contentListView
                self.contentGridView
            })
        }
        //.listStyle(SidebarListStyle()) //ios 14
        .background(Color.white)
        .padding(0)
        .navigationBarTitle(Text(navTitle))
        .onAppear(perform: {
            list.removeAll()
            callAPIMyFlashCard()
        })
    }
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            TotalView
            .frame(height: 40)
            
            if self.isCreate, isKMSEnabled,
                UserManager.shared.profile.isCreator {
                
                CreateView
                    .background(Color.white)
                    .frame(height: self.headerHeight)
            }
        }
    }
    
    var contentGridView: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                self.headerView
                    .padding([.leading, .trailing], 16)
                Spacer(minLength: 16)
            }
            .frame(height: self.headerHeight + 40)
            
            ScrollView(.vertical, showsIndicators: false) {
                GridSwiftUI(style: self.gridConfig,
                            columns: UIDevice.isIpad() ? 2 : 1,
                            list: self.list) { item in
                    
                    NavigationLink(isActive: self.$isPreviewItem) {
                        //TODO: change to preview
                        self.managePreviewDestination(item: self.selectedItem ?? item)
                    } label: {
                        EmptyView()
                    }
                    
                    NavigationLink(isActive: self.$isEditItem) {
                        self.manageDestination(item: self.selectedItem ?? item)
                    } label: {
                        EmptyView()
                    }
                    
                    MyMaterialView(selectedItem: self.$selectedItem,
                                   isPreviewItem: self.$isPreviewItem,
                                   isEditItem: self.$isEditItem,
                                   isEditor: true,
                                   item: item)
                        .id(item.uuid)
                        .background(Color.white)
                        .onTapGesture {
                            self.selectedItem = item
                            self.isEditItem.toggle()
                        }
                }
                
            }
            .padding([.leading, .trailing], 16)
            .onChange(of: self.scrollViewSize, perform: { newValue in
                print("scroll: \(newValue)")
            })
            /*
            if viewModel.isListFull == false {
                ActivityLoadingView(isLoading: isLoading)
                    .listRowBackground(Color.white)
                    .background(Color.white)
            }
            */
        }
        
    }
    
    var contentListView: some View {
        List {
            ForEach(self.list, id:\LMMaterialResult.uuid) { item in
                Section {
                    VStack(alignment: .leading, spacing: 0, content: {
                        ZStack {
                            MyMaterialView(selectedItem: self.$selectedItem,
                                           isPreviewItem: self.$isPreviewItem,
                                           isEditItem: self.$isEditItem,
                                           isEditor: true,
                                           item: item)
                                .id(item.uuid)
                                .background(Color.white)
                                .listRowBackground(Color.white)
                            
                            NavigationLink(destination: self.manageDestination(item: item)) {
                                Rectangle()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(0.0)
                        }
                    })
                    .padding(.leading, cellMargin)
                    .padding(.trailing, cellMargin)
                    .background(Color.white)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        if !isLoading {
                            self.manageLastItem(item: item)
                        }
                    }
                    .frame(height: FlashStyle.flashItemHeight)
                } header: {
                    self.headerView
                        .frame(height: self.headerHeight + 40)
                        .padding([.leading, .trailing], 16)
                }
                
            }
            .listRowBackground(Color.white)
            .background(Color.white)
            
            if viewModel.isListFull == false {
                ActivityLoadingView(isLoading: isLoading)
                    .listRowBackground(Color.white)
                    .background(Color.white)
            }
        }
        .onAppear { UITableView.appearance().separatorStyle = .none }
        .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
        .listSeparatorStyleNone()
        .listRowBackground(Color.white)
        .background(Color.white)
    }
    
    var TotalView: some View {
        VStack {
            Text(self.viewModel.totalText())
                .frame(height: 40)
                .foregroundColor(.text75())
                .font(.font(14, .text))
        }
        .background(Color.white)
    }
    
    var CreateView: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            ZStack {
                FLCreateMaterialView()
                    .frame(height: self.headerHeight)
                    .padding(.bottom, 8)
                NavigationLink(destination: CreateMaterialListView()) {
                    Rectangle()
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(0.0)
            }
        })
        .background(Color.clear)
    }
    
    @ViewBuilder func manageDestination(item: LMMaterialResult) -> some View {
        switch item.contentCode {
        case .flashcard:
            UGCPostView(item: item)
            
        case .video , .audio:
            if let _ = item.url {
                UGCPostView(item: item)
            } else {
                let viewModel = UGCCreateMediaViewModel(mId: item.id,
                                                    contentCode:item.contentCode)
                UGCCreateMediaSwiftUIView(isCreated: true)
                    .environmentObject(viewModel)
            }
            
        case .pdf:
            let viewModel = UGCCreateMediaViewModel(mId: item.id,
                                                contentCode:item.contentCode)
            UGCCreateDocSwiftUI(isCreated: true)
                .environmentObject(viewModel)
            
        default:
            UGCPostView(item: item)
        }
    }
    
    @ViewBuilder func managePreviewDestination(item: LMMaterialResult) -> some View {
        switch item.contentCode {
        case .flashcard:
            //make flash preview in SwiftUI
            //OpenVCHelper.openFlashcardUserPreview(id: item.id, state: .preview, mainVC: self)
            Text("flashcard")
            
        case .video , .audio:
            if let mediaUrl = URL(string: item.url ?? "") {
                let contentCode = item.contentCode
                let model = UGCPlayerFullScreenViewModel(contentCode: contentCode,
                                                         isNeedStopWhenClose: false,
                                                            mediaUrl: mediaUrl,
                                                         coverImage: item.image,
                                                         currentTime: 0)
                UGCPlayerFullScreenSwiftUI(viewModel: model, playerVM: UGCPlayerViewModel())
                    .supportedOrientations(.landscape)
            } else {
                Text("video audio no url")
            }
        case .pdf:
            //TODO: preview pdf
            Text("pdf")
            
        default:
            Text("default")
        }
    }
}


extension MyMaterialListView {
    func manageLastItem(item: LMMaterialResult) {
        guard let myMaterial = myMaterialFlash else { return }
        //let next = myMaterial.next //TODO:wait backend fix this
        guard let nextUrl = myMaterial.nextUrl else { return }
        if list.isLastItem(item) {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.callAPIMyFlashCard(nextUrl)
            }
        }
    }
    
    func callAPIMyFlashCard(_ nextUrl:String? = nil) {
        viewModel.callAPIMyFlashCard(nextUrl: nextUrl) { (newPage) in
            if let page = newPage {
                myMaterialFlash = page
                list.append(contentsOf: page.list)
            }
            isLoading = false
        }
    }
}

struct MyMaterialListView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyMaterialListView()
            .environmentObject(MyMaterialListViewModel())
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        
    }
}
