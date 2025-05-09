//
//  MemoListView.swift
//  voiceMemo
//

import SwiftUI

struct MemoListView: View {
    @EnvironmentObject private var pathmodel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
  var body: some View {
    ZStack {
        VStack {
            if !memoListViewModel.memos.isEmpty {
                CustomNavigationBar(
                    isDisplayLeftBtn: false,
                    rightBtnAction: memoListViewModel.navigationRightBtnTapped,
                    rightBtnType: memoListViewModel.navigationBarRightBtnMode
                
                    )
            } else {
                Spacer()
                    .frame(height: 30)
            }
            
            TitleView()
                .padding(.top, 20)
            
            if memoListViewModel.memos.isEmpty {
                AnnouncementView()
            } else {
                MemoListcontentView()
                    .padding(.top, 20)
            }
            
            
        }
        WriteMemoBtnBiew()
            .padding(.trailing, 20)
            .padding(.bottom, 50)
      }
    .alert(
        "메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?",
        isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
    ) {
        Button("삭제", role: .destructive) {
            memoListViewModel.removeBtnTapped()
        }
        Button("취소", role: .cancel) { }
    }
  }
}

// MARK: - title view
private struct TitleView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if memoListViewModel.memos.isEmpty {
               Text("메모를 \n추가해 보세요.")
            } else {
                Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
            }
            Spacer()
        }
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - announce
 private struct AnnouncementView: View{
     fileprivate var body: some View {
         VStack(spacing: 15){
             Spacer()
             
             Image("pencil")
                 .renderingMode(.template)
             Text("\"퇴근 9시간전 메모\"")
             Text("\"개발 끝낸 후 퇴근하기!\"")
             Text("\"밀린 알고리즘 공부하기1!\"")
             
             Spacer()
         }
         .font(.system(size: 15))
         .foregroundColor(.customGray2)
     }
}

// MARK: - memo list content View
private struct MemoListcontentView: View {
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("메모 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical){
                VStack(spacing: 0) {
                    CustomDivider()
                    
                    ForEach(memoListViewModel.memos, id: \.id) { memo in
                        MemoCellView(memo: memo)
                    }
                }
            }
        }
    }
}

private struct MemoCellView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var memoListViewModel: MemoListViewModel
    @State private var isRemoveSelected: Bool
    private var memo: Memo
    
    fileprivate init(
    isRemoveSelected: Bool = false,
    memo: Memo) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.memo = memo
    }
    
    fileprivate var body: some View {
        Button(
            action: {
                pathModel.paths.append(.memoView(isCreatMode: false, memo: memo))
            },
            label: {
                VStack(spacing: 10) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(memo.title)
                                .lineLimit(1)
                                .font(.system(size: 16))
                                .foregroundColor(.customBlack)
                            Text(memo.convertedDate)
                                .font(.system(size: 12))
                                .foregroundColor(.customIconGray)
                        }
                        
                        Spacer()
                        
                        if memoListViewModel.isEditMemoMode {
                            Button (
                                action: {
                                    isRemoveSelected.toggle()
                                    memoListViewModel.memoRemoveSelectedBoxTapped(memo)
                            }, label: {
                                isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    
                    CustomDivider()
                }
            }
        )
    }
    
}

// MARK: - memo write view
private struct WriteMemoBtnBiew: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        pathModel.paths.append(.memoView(isCreatMode: true, memo: nil))
                    }, label: {
                        Image("writeBtn")
                    }
                )
            }
        }
    }
}

struct MemoListView_Previews: PreviewProvider {
  static var previews: some View {
    MemoListView()
          .environmentObject(PathModel())
          .environmentObject(MemoListViewModel())
  }
}
