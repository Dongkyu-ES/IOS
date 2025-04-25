//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
  var body: some View {
      ZStack {
          // todo cell list
          VStack {
              if !todoListViewModel.todos.isEmpty {
                  CustomNavigationBar(
                    isDisplayLeftBtn: false,
                    rightBtnAction: {
                        todoListViewModel.navigationRightBtnTapped()
                    },
                    rightBtnType: todoListViewModel.naviagationBarRightBtnMode
                  )
              } else {
                  Spacer()
                      .frame(height: 30)
              }
              
              TitleView()
                  .padding(.top, 20)
              
              if(todoListViewModel.todos.isEmpty){
                  AnnouncementView()
              } else {
                  TodoListContentView()
                      .padding(.top, 20)
              }
          }
          WriteTodoBtnView()
              .padding(.trailing, 20)
              .padding(.bottom, 50)
      }
      .alert(
        "To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
        isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
      ) {
          Button("삭제", role: .destructive) {
              todoListViewModel.removeBtnTapped()
          }
          Button("취소", role: .cancel) { }
      }
  }
}

// MARK: - TodoList Title View
private struct TitleView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        HStack {
            if todoListViewModel.todos.isEmpty {
                Text("To do list를\n추가해 보세요.")
            } else {
                Text("To do List \(todoListViewModel.todos.count)개가\n있습니다.")
            }
            
            Spacer()
        }
        .font(.system(size:30, weight: .bold))
        .padding(.leading, 20)
    }
}

// MARK: - TodoEmpty Announcement View
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("pencil")
                .renderingMode(.template)
            
            Text("\"매일 아침 5시 운동하자!\"")
            Text("\"내일 8시 수강 신청하자!\"")
            Text("\"1시 반 점심약속 리마인드 해보자!\"")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(Color.customGray2)
    }
}

// MARK: - TodoList Content View
private struct TodoListContentView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("할일 목록")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.leading, 20)
                
                Spacer()
            }
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.customGray0)
                        .frame(height: 1)
                    
                    ForEach(todoListViewModel.todos, id: \.self) { todo in
                        TodoCellView(todo: todo)
                    }
                }
            }
        }
    }
}

// MARK: - Todo cell view
private struct TodoCellView: View {
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @State private var isRemoveSelected: Bool
    private var todo: Todo
    
    fileprivate init(
        isRemoveSelected: Bool = false,
        todo: Todo
    ) {
        _isRemoveSelected = State(initialValue: isRemoveSelected)
        self.todo = todo
    }
    
    fileprivate var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !todoListViewModel.isEditTodoMode {
                    Button(
                        action: {
                            todoListViewModel.seletedBoxTapped(todo)
                        },
                        label: {
                            todo.selected ? Image(systemName: "selectedBox") : Image(systemName: "unselectedBox")
                        }
                    )
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .font(.system(size: 16))
                        .foregroundStyle(todo.selected ? Color.customIconGray : Color.customBlack)
                        .strikethrough(todo.selected)
                    
                    Text(todo.convertedDayAndTime)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.customIconGray)
                }
                
                Spacer()
                
                if todoListViewModel.isEditTodoMode {
                    Button(
                        action : {
                            isRemoveSelected.toggle()
                            todoListViewModel.todoRemoveSelectedBoxTapped(todo)
                        },
                        label: {
                            isRemoveSelected ? Image("selectedBox") : Image("unselectedBox")
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
        }
    }
}

//MARK: - Todo Write view
private struct WriteTodoBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(
                    action: {
                        pathModel.paths.append(.todoView)
                    },
                    label: {
                        Image("writeBtn")
                    }
                )
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView()
          .environmentObject(PathModel())
          .environmentObject(TodoListViewModel())
  }
}
