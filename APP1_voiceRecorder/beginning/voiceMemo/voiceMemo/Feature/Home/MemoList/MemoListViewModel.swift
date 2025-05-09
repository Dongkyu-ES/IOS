//
//  MemoListViewModel.swift
//  voiceMemo
//

import Foundation

class MemoListViewModel: ObservableObject {
    @Published var memos: [Memo]
    @Published var isEditMemoMode: Bool
    @Published var removeMemo: [Memo]
    @Published var isDisplayRemoveMemoAlert: Bool
    
    var removeMemoCount: Int {
        return removeMemo.count
    }
    
    var navigationBarRightBtnMode: NavigationBtnType {
        isEditMemoMode ? .complete : .edit
    }
    
    init(memos: [Memo] = [],
         isEditMemoMode: Bool = false,
         removeMemo: [Memo] = [],
         isDisplayRemoveMemoAlert: Bool = false
    ) {
        self.memos = memos
        self.isEditMemoMode = isEditMemoMode
        self.removeMemo = removeMemo
        self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
    }
  
}

extension MemoListViewModel {
    func addMemo(_ memo: Memo) {
        memos.append(memo)
    }
    
    func updateMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: {$0.id == memo.id}) {
            memos[index] = memo
        }
    }
        
    func removeMemo(_ memo: Memo) {
        if let index = memos.firstIndex(where: {$0.id == memo.id}) {
            memos.remove(at: index)
        }
    }
    
    func navigationRightBtnTapped() {
        if isEditMemoMode {
            if removeMemo.isEmpty {
                isEditMemoMode = false
            } else {
                setIsDisplayRemoveMemoAlert(true)
            }
        } else {
            isEditMemoMode = true
        }
    }
    
    func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool){
        isDisplayRemoveMemoAlert = isDisplay
    }
    
    func memoRemoveSelectedBoxTapped(_ memo: Memo) {
        if let index = removeMemo.firstIndex(of: memo) {
            removeMemo.remove(at: index)
        } else {
            removeMemo.append(memo)
        }
    }
    
    func removeBtnTapped() {
        memos.removeAll { memo in
            removeMemo.contains(memo)
        }
        removeMemo.removeAll()
        isEditMemoMode = false
    }
}
