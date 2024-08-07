//
//  TodoView.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI
import SwiftData

// MARK: - TodoView
struct TodoView: View {

    @StateObject var viewModel: TodoViewModel
    @FocusState private var isFocused
    @Environment(\.dismiss) var dismiss

    init(todoItem: TodoItem) {
        let viewModel = TodoViewModel(todoItem: todoItem)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Group {
                    Section {
                        newEventTextView
                    }
                    Section {
                        importanceCell
                        categoryCell
                        deadlineCell
                        if viewModel.isDeadlineEnabled {
                            datePickerCell
                        }
                    }
                    Section {
                        deleteButtonCell
                    }
                }
                .listRowBackground(Color.backgroundSecondary)
                .listRowSeparatorTint(.primarySeparator)
            }
            .groupedList()
            .listSectionSpacing(16)
            .navigationTitle("task")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("", isPresented: $viewModel.isAlertShown) {
                confirmation
            }
            .sheet(isPresented: $viewModel.isCategoryViewShown) {
                CategoryView(category: $viewModel.category)
                    .toolbar(.hidden, for: .navigationBar)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismissIfNeeded()
                        AnalyticsService.todoViewCancel()
                    } label: {
                        Text("cancel")
                            .font(.todoBody)
                            .foregroundStyle(.primaryBlue)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                             await viewModel.saveItem()
                        }
                        AnalyticsService.todoViewSave()
                        dismiss()
                    } label: {
                        Text("save")
                            .font(.todoBody)
                            .foregroundStyle(viewModel.canItemBeSaved ? .primaryBlue : .textTertiary)
                            .bold()
                    }
                    .disabled(!viewModel.canItemBeSaved)
                }
            }
        }
        .interactiveDismissDisabled(viewModel.canItemBeSaved)
    }

    private func dismissIfNeeded() {
        if viewModel.canItemBeSaved {
            viewModel.isAlertShown = true
        } else {
            dismiss()
        }
    }

}

// MARK: - UI Elements
extension TodoView {

    private var confirmation: some View {
        Button(role: .destructive) {
            viewModel.isAlertShown.toggle()
            dismiss()
        } label: {
            Text("task.discardChanges")
        }
    }

    private var newEventTextView: some View {
        TextField(
            "",
            text: $viewModel.text,
            prompt: Text("task.placeholder").foregroundStyle(.textTertiary),
            axis: .vertical
        )
        .frame(minHeight: 120, alignment: .topLeading)
        .focused($isFocused)
        .font(.todoBody)
        .foregroundStyle(.textPrimary)
        .overlay(
            HStack {
                if let color = viewModel.color {
                    Spacer()
                    Rectangle()
                        .fill(color)
                        .frame(width: 5)
                        .padding(.trailing, -5)
                        .padding(.vertical, -12)
                }
            }
        )
    }

    private var importanceCell: some View {
        HStack {
            Text("importance")
                .font(.todoBody)
                .foregroundStyle(.textPrimary)
                .truncationMode(.tail)
            Spacer()
            Picker("", selection: $viewModel.importance) {
                ForEach(Importance.allCases) { $0.symbol }
            }
            .frame(maxWidth: 150)
            .pickerStyle(.segmented)
            .backgroundStyle(.overlay)
        }
    }

    private var deadlineCell: some View {
        VStack {
            Toggle(isOn: $viewModel.isDeadlineEnabled.animation()) {
                Text("deadline")
                    .font(.todoBody)
                    .foregroundStyle(.textPrimary)
                    .truncationMode(.tail)
            }
            if viewModel.isDeadlineEnabled {
                HStack {
                    Text(
                        viewModel.selectedDeadline.formatted(
                            .dateTime
                                .day(.twoDigits)
                                .month(.wide)
                                .year()
                        )
                    )
                    .font(.todoFootnote)
                    .foregroundStyle(.primaryBlue)
                    Spacer()
                }
            }
        }
    }

    private var categoryCell: some View {
        Button {
            viewModel.isCategoryViewShown.toggle()
        } label: {
            HStack {
                Text("category")
                    .font(.todoBody)
                    .foregroundStyle(.textPrimary)
                    .truncationMode(.tail)
                Spacer()
                if let category = viewModel.category {
                    HStack(spacing: 1) {
                        Text(category.text)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .font(.todoBody)
                            .foregroundStyle(.textPrimary)
                        if let hex = category.color {
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .fill(Color(hex: hex))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
        }
    }

    private var datePickerCell: some View {
        DatePicker(
            "",
            selection: $viewModel.selectedDeadline,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
    }

    private var deleteButtonCell: some View {
        Button {
            Task {
                await viewModel.removeItem()
            }
            AnalyticsService.todoViewDelete(id: viewModel.todoItem.id)
            dismiss()
        } label: {
            Text("delete")
                .frame(maxWidth: .infinity)
                .font(.todoBody)
                .foregroundStyle(viewModel.isItemNew ? .textTertiary : .primaryRed)
        }
        .disabled(viewModel.isItemNew)
    }

}

// MARK: - Preview
#Preview {
    TodoView(
        todoItem: TodoItem(
            text: "Text",
            importance: .important,
            deadline: .now,
            isDone: false,
            createdAt: .now,
            color: nil,
            category: nil
        )
    )
}
