import PhotosUI
import SwiftUI

struct ProfileView: View {
    @Environment(AppStore.self) private var store

    private enum Field: Hashable {
        case name
        case goalTitle
        case newSkill
    }

    @State private var newSkillTitle = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showResetConfirmation = false
    @FocusState private var focusedField: Field?

    private let avatarSymbols = [
        "figure.run",
        "scope",
        "flag.checkered",
        "flame.fill",
        "bolt.fill",
        "trophy.fill",
        "star.fill"
    ]

    var body: some View {
        @Bindable var store = store

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Profile")
                        .font(.title2.weight(.bold))

                    HStack(spacing: 16) {
                        ProfileAvatarView(
                            imageData: store.profileImageData,
                            systemName: store.profileSymbol,
                            theme: store.theme
                        )

                        TextField("Your name", text: $store.userName)
                            .textFieldStyle(.roundedBorder)
                            .font(.headline)
                            .focused($focusedField, equals: .name)
                            .submitLabel(.done)
                    }

                    HStack {
                        Text("Profile picture")
                            .font(.headline.weight(.bold))
                        Spacer()
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Label("Upload", systemImage: "photo")
                                .font(.subheadline.weight(.bold))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(store.theme.primary)
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 74), spacing: 12)], spacing: 12) {
                        ForEach(avatarSymbols, id: \.self) { symbol in
                            Button {
                                store.profileSymbol = symbol
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(store.profileSymbol == symbol ? store.theme.primary : Color.black.opacity(0.05))
                                        .frame(height: 64)

                                    Image(systemName: symbol)
                                        .font(.title2.weight(.bold))
                                        .foregroundStyle(store.profileSymbol == symbol ? .white : .primary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if store.profileImageData != nil {
                        Button("Remove uploaded photo") {
                            store.updateProfileImage(data: nil)
                            selectedPhoto = nil
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(store.theme.primaryDark)
                    }
                }
                .padding(20)
                .background(.white.opacity(0.88))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                VStack(alignment: .leading, spacing: 16) {
                    Text("Goal")
                        .font(.title2.weight(.bold))

                    TextField("Goal title", text: $store.goalTitle)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .goalTitle)
                        .submitLabel(.done)

                    DatePicker("Goal date", selection: $store.goalDate, displayedComponents: .date)
                        .datePickerStyle(.compact)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(store.goalTitle.isEmpty ? "Next event" : store.goalTitle)
                            .font(.headline.weight(.bold))
                        Text(store.goalCountdownText)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(store.theme.success)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .padding(20)
                .background(.white.opacity(0.88))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                remindersCard
                themeCard
                skillAdminCard
                resetCard
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
        }
        .background(
            LinearGradient(
                colors: [
                    store.theme.backgroundTop,
                    store.theme.backgroundBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Profile")
        .onChange(of: selectedPhoto) { _, newItem in
            guard let newItem else { return }

            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        store.updateProfileImage(data: data)
                    }
                }
            }
        }
        .confirmationDialog("Reset app data?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
            Button("Reset everything", role: .destructive) {
                store.resetAllData()
                selectedPhoto = nil
                newSkillTitle = ""
                focusedField = nil
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This clears your profile, goal, sessions, friends, custom skills, and theme.")
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }

    private var themeCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color theme")
                .font(.title2.weight(.bold))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                ForEach(AppTheme.presets) { theme in
                    Button {
                        store.selectedThemeID = theme.id
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(theme.primary)
                                    .frame(width: 18, height: 18)
                                Circle()
                                    .fill(theme.primarySoft)
                                    .frame(width: 18, height: 18)
                                Circle()
                                    .fill(theme.success)
                                    .frame(width: 18, height: 18)
                            }

                            Text(theme.name)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(store.selectedThemeID == theme.id ? theme.primary.opacity(0.16) : Color.black.opacity(0.04))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(store.selectedThemeID == theme.id ? theme.primary : .clear, lineWidth: 2)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var remindersCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily reminder")
                .font(.title2.weight(.bold))

            Toggle(
                "Remind me every day",
                isOn: Binding(
                    get: { store.reminderEnabled },
                    set: { newValue in
                        Task {
                            await store.updateReminderEnabled(newValue)
                        }
                    }
                )
            )
            .tint(store.theme.primary)

            DatePicker(
                "Reminder time",
                selection: Binding(
                    get: { store.reminderTime },
                    set: { store.reminderTime = $0 }
                ),
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.compact)
            .disabled(!store.reminderEnabled)
            .opacity(store.reminderEnabled ? 1 : 0.55)

            Text(store.reminderStatusText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var skillAdminCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Skill types")
                .font(.title2.weight(.bold))

            HStack(spacing: 10) {
                TextField("Add a new skill", text: $newSkillTitle)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .newSkill)
                    .submitLabel(.done)

                Button("Add") {
                    store.addSkill(title: newSkillTitle)
                    newSkillTitle = ""
                    focusedField = nil
                }
                .buttonStyle(.borderedProminent)
                .tint(store.theme.primary)
            }

            VStack(spacing: 10) {
                ForEach(store.skills.sorted { $0.sortOrder < $1.sortOrder }) { skill in
                    HStack(spacing: 12) {
                        Image(systemName: skill.symbol)
                            .frame(width: 26)
                        Text(skill.title)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(14)
                    .background(Color.black.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
            }
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var resetCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Testing")
                .font(.title2.weight(.bold))

            Text("Use reset while testing so the app behaves like a clean first install again.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button("Reset app data") {
                showResetConfirmation = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding(20)
        .background(.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
