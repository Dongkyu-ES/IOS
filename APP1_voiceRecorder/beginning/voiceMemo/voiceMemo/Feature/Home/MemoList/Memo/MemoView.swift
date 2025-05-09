//
//  MemoView.swift
//  voiceMemo
//

import SwiftUI

struct MemoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @StateObject var memoViewModel: MemoViewModel
    @State var isCreatemode: Bool = true
 
  var body: some View {
      ZStack {
          VStack {
              CustomNavigationBar(
                leftBtnAction: {
                    pathModel.paths.removeLast()
                },
                rightBtnAction: {
                    if isCreatemode {
                        memoListViewModel.addMemo(memoViewModel.memo)
                    } else {
                        memoListViewModel.updateMemo(memoViewModel.memo)
                    }
                    pathModel.paths.removeLast()
                },
                rightBtnType: isCreatemode ? .create : .complete
            )
              
              MemoTitleInputView(memoViewModel: memoViewModel, isCreatemode: $isCreatemode)
                  .padding(.top, 20)
              
              memoContentInputView(memoViewModel: memoViewModel)
                  .padding(.top, 10)
              
          }
          if !isCreatemode {
              RemoveMemoBtnView(memoViewModel: memoViewModel)
                  .padding(.trailing, 20)
                  .padding(.bottom, 10)
          }
      }
  }
}

// MARK: - memo title input
private struct MemoTitleInputView : View {
    @ObservedObject private var memoViewModel: MemoViewModel
    @FocusState private var isTitleFieldFocused: Bool
    @Binding private var isCreatemode: Bool
    
    fileprivate init(
        memoViewModel: MemoViewModel,
        isCreatemode: Binding<Bool>
    ) {
        self.memoViewModel = memoViewModel
        self._isCreatemode = isCreatemode
    }
    
    fileprivate var body: some View {
        TextField(
            "제목을 입력하세요.",
            text: $memoViewModel.memo.title
        )
        .font(.system(size: 30))
        .padding(.horizontal, 20)
        .focused($isTitleFieldFocused)
        .onAppear {
            if isCreatemode {
                isTitleFieldFocused = true
            }
        }
    }
}

// MARK: - memo content input view
private struct memoContentInputView : View {
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init(memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $memoViewModel.memo.content)
                .font(.system(size: 20))
            
            if memoViewModel.memo.content.isEmpty {
                Text("메모를 입력하세요.")
                    .font(.system(size: 16))
                    .foregroundColor(.customGray1)
                    .allowsHitTesting(false)
                    .padding(.top, 16)
                    .padding(.leading, 5)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - memo delete button
private struct RemoveMemoBtnView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @EnvironmentObject private var pathModel: PathModel
    @ObservedObject private var memoViewModel: MemoViewModel
    
    fileprivate init( memoViewModel: MemoViewModel) {
        self.memoViewModel = memoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        memoListViewModel.removeMemo(memoViewModel.memo)
                        pathModel.paths.removeAll()
                    }, label: {
                        Image("trash")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                )
            }
        }
    }
}

struct MemoView_Previews: PreviewProvider {
  static var previews: some View {
      MemoView(memoViewModel:
            .init(memo: .init(title: "", content: "", date: Date()
                             )
            )
      )
          .environmentObject(PathModel())
          .environmentObject(MemoListViewModel())
  }
}
