//
//  TodoVie.swift
//  voiceMemo
//
//  Created by tecace on 2024/02/23.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var todoListViewModel: TodoListViewModel
    @StateObject private var todoViewModel = TodoViewModel()
    
    var body: some View {
        VStack {
            CustomNavigationBar(
              leftBtnAction: {
                pathModel.paths.removeLast()
              },
              rightBtnAction: {
                todoListViewModel.addTodo(
                  .init(
                    title: todoViewModel.title,
                    content: todoViewModel.content,
                    time: todoViewModel.time,
                    day: todoViewModel.day,
                    selected: false
                  )
                )
                pathModel.paths.removeLast()
              },
              rightBtnType: .create
            )
            
            TitleView()
                .padding(.top,20)
            
            Spacer()
                .frame(height: 20)
        
            
            TodoTitleView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            Spacer()
                .frame(height: 20)
            
            
            TodoContentView(todoViewModel: todoViewModel)
                .padding(.leading,20)
            

            SelectTimeview()

            
            SelectDayView(todoViewModel: todoViewModel)
                .padding(.leading, 20)
            
            Spacer()

            
        }
    }
}

private struct TitleView : View {
    fileprivate var body: some View {
        HStack {
            Text("Todo List")
            Spacer()
        }
        .font(.system(size: 30,weight: .bold))
        .padding(.leading, 20)
    }
}

private struct TodoTitleView : View {
    @ObservedObject private var todoViewModel : TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("제목을 입력하세요.", text: $todoViewModel.title)
    }
}


private struct TodoContentView : View {
    @ObservedObject private var todoViewModel: TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        TextField("내용을 입력하세요.", text: $todoViewModel.content)
    }
    
}


private struct SelectTimeview : View {
    @ObservedObject private var todoViewModel = TodoViewModel()
    
    fileprivate init(todoViewModel: TodoViewModel = TodoViewModel()) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            DatePicker(
                "",
                selection: $todoViewModel.time,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color.customGray0)
                .frame(height: 1)
            
            
        }
    }
    
}


private struct SelectDayView : View {
    @ObservedObject private var todoViewModel : TodoViewModel
    
    fileprivate init(todoViewModel: TodoViewModel) {
        self.todoViewModel = todoViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            HStack {
                Text("날짜")
                    .foregroundColor(.customIconGray)
                
                Spacer()
            }
            
            HStack {
                Button(action: {
                    todoViewModel.setIsDisplayCalendar(true)
                }, label: {
                    Text("\(todoViewModel.day.formattedDay)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.customGreen)
                })
                .popover(isPresented: $todoViewModel.isDisplayCalendar){
                    DatePicker("",
                               selection: $todoViewModel.day,
                               displayedComponents: .date)
                    
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .onChange(of: todoViewModel.day){_ in
                        todoViewModel.setIsDisplayCalendar(false)
                    }
                }
                Spacer()
            }
        }
    }
}



struct TodoVie_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
