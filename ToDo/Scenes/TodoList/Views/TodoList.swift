//
//  TodoList.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI

// MARK: - TodoList
struct TodoList: View {

    @StateObject var viewModel = TodoListViewModel()
    @FocusState private var isFocused

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.todoItems) { todoItem in
                        TodoCell(
                            todoItem: todoItem,
                            color: viewModel.colorFor(todoItem: todoItem),
                            onTap: {
                                viewModel.selectedTodoItem = todoItem
                                viewModel.todoViewPresented.toggle()
                            },
                            onRadioButtonTap: {
                                viewModel.toggleDone(todoItem)
                            }
                        )
                        .markableAsDone(isDone: todoItem.isDone) {
                            viewModel.toggleDone(todoItem)
                        }
                        .deletable {
                            viewModel.delete(todoItem)
                        }
                        .withInfo {
                            viewModel.selectedTodoItem = todoItem
                            viewModel.todoViewPresented.toggle()
                        }
                    }
                    newEventTextView
                } header: { headerView }
                .listRowBackground(Color.backgroundSecondary)
            }
            .groupedList()
            .navigationTitle("title")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    calendarButton
                }
            }
            .safeAreaInset(edge: .bottom) {
                floatingButton
            }
            .sheet(isPresented: $viewModel.todoViewPresented) {
                TodoView(
                    viewModel: TodoViewModel(
                        todoItem: viewModel.todoItemToOpen
                    )
                )
            }
            .fullScreenCover(isPresented: $viewModel.calendarViewPresented) {
                CalendarView()
                    .ignoresSafeArea()
            }
        }
    }

}

// MARK: - UI Elements
extension TodoList {

    private var calendarButton: some View {
        Button {
            viewModel.calendarViewPresented.toggle()
        } label: {
            Image(systemName: "calendar")
                .resizable()
                .foregroundStyle(.textPrimary, .primaryBlue)
                .frame(width: 20, height: 20, alignment: .center)
        }
    }

    private var newEventTextView: some View {
        TextField(
            "",
            text: $viewModel.newTodo,
            prompt: Text("newTask").foregroundStyle(.textTertiary)
        )
        .listRowInsets(EdgeInsets(top: 16, leading: 60, bottom: 16, trailing: 16))
        .focused($isFocused)
        .font(.todoBody)
        .foregroundStyle(.textPrimary)
        .onSubmit {
            isFocused = false
            if !viewModel.newTodo.isEmpty {
                viewModel.addItem(TodoItem(text: viewModel.newTodo))
                viewModel.newTodo = ""
                isFocused = true
            }
        }
    }

    private var floatingButton: some View {
        Button {
            viewModel.todoViewPresented.toggle()
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundStyle(.primaryWhite, .primaryBlue)
                .frame(width: 44, height: 44, alignment: .center)
                .shadow(color: .buttonShadow, radius: 5, x: 0, y: 8)
                .padding(.vertical, 10)
        }
    }

    private var headerView: some View {
        HStack {
            Text("done.\(viewModel.doneCount)")
                .foregroundStyle(.textTertiary)
                .font(.todoSubhead)
            Spacer()
            menu
        }
        .textCase(.none)
        .padding(.vertical, 6)
        .padding(.horizontal, -10)
    }

    private var menu: some View {
        Menu {
            Section {
                Button {
                    viewModel.toggleShowCompleted()
                } label: {
                    Label(
                        viewModel.showCompleted ? "hide" : "show",
                        systemImage: viewModel.showCompleted ? "eye.slash" : "eye"
                    )
                }
            }
            Section {
                Button {
                    viewModel.toggleSortByPriority()
                } label: {
                    Label(
                        viewModel.sortType.descriptionOfNext,
                        systemImage: "arrow.up.arrow.down"
                    )
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .foregroundStyle(.textPrimary, .primaryBlue)
                .frame(width: 20, height: 20, alignment: .center)
        }
    }

}

// MARK: - Preview
#Preview {
    TodoList()
}
