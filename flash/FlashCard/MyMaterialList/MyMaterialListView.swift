//
//  MyMaterialListView.swift
//  flash
//
//  Created by Songwut Maneefun on 21/9/2564 BE.
//

import SwiftUI

struct MyMaterialListView: View {
    @ObservedObject var viewModel = MyMaterialListViewModel()
    
    @State var myMaterialFlash: MaterialFlashPageResult
    @State var list: [LMMaterialResult]
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List {//List = UITableView in UIKit can change to ScrollView but need custom footer UI loding
                VStack(alignment: .leading, spacing: nil, content: {
                    let items = myMaterialFlash.list
                    let count =  items.count
                    let total = "total".localized()
                    let totalText =  count.textNumber(many: "learning_material".localized())
                    Text("\(total) \(totalText)")
                        .frame(height: 40)
                        .foregroundColor(.text75())
                        .font(.font(14, .text))
                })
                .listRowBackground(Color.white)
                .background(Color.white)
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                
                CreateView
                    .background(Color.white)
                    .listRowBackground(Color.white)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                
                ForEach(list) { item in
                    ZStack {
                        MyMaterialView(isEditor: true, item: item)
                            .background(Color.white)
                            .listRowBackground(Color.white)
                        
                        NavigationLink(destination: FLFlashPostView(flashId:item.id)) {
                            Rectangle()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(0.0)
                    }
                    .background(Color.white)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                    .frame(height: FlashStyle.flashItemHeight)
                    .onAppear {
                        if !isLoading {
                            self.manageLastItem(item: item)
                        }
                    }
                }
                .listRowBackground(Color.white)
                .background(Color.white)
                
                if viewModel.isListFull == false {
                    //ActivityIndicator(isAnimating: $viewModel.isLoading)
                    ActivityIndicator(isAnimating: .constant(isLoading), color: .black, style: .medium)
                }
            }
            .listSeparatorStyleNone()
            .listRowBackground(Color.white)
            .background(Color.white)
            
        }
        //.listStyle(SidebarListStyle()) //ios 14
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .background(Color.white)
        .navigationBarTitle("My Material", displayMode: .automatic)
        .onAppear(perform: {
            viewModel.next = myMaterialFlash.next
            viewModel.nextUrl = myMaterialFlash.nextUrl
            viewModel.previous = myMaterialFlash.previous
            viewModel.pageSize = myMaterialFlash.pageSize
        })
        
    }
    
    var CreateView: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            ZStack {
                FLCreateMaterialView()
                    .frame(height: 122)
                    .padding(.bottom, 8)
                let vm =  FLCreateMaterialListViewModel()
                NavigationLink(destination: FLCreateMaterialListView(viewModel: vm)) {
                    Rectangle()
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(0.0)
            }
        })
        .background(Color.clear)
    }
}

extension MyMaterialListView {
    func manageLastItem(item: LMMaterialResult) {
        let items = list
        let next = myMaterialFlash.next//TODO:wait backend fix this
        let nextUrl = myMaterialFlash.nextUrl
        
        if items.isLastItem(item) {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if !viewModel.isListFull {
                    viewModel.callAPIMyFlashCard(
                        nextUrl: nextUrl) { (newPage) in
                        if let page = newPage {
                            self.myMaterialFlash = page
                            self.list.append(contentsOf: page.list)
                        }
                        
                        isLoading = false
                    }
                }
            }
        }
    }
}

struct MyMaterialListView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyMaterialListView(myMaterialFlash: MockObject.myMaterialFlash, list: MockObject.myMaterialFlash.list)
            .previewDevice("iPhone 12")
            .preferredColorScheme(.dark)
        
    }
}
