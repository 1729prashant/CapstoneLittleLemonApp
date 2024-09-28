//
//  Menu.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//
import SwiftUI
import CoreData

enum HeroDetails: String {
    case heading = "Little Lemon",
         location = "Chicago",
         description = "We are a family owned Mediterranian restaurant, focused on traditional recipes served with a modern twist."
}

struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuItems: [MenuItem] = [] // For fetched menu items
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil //state variable for category selection
    @State private var hasFetchedData: Bool = false // Track if data has been fetched

    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "kIsLoggedIn")
    @State private var selectedTab: Int = 1 // Track the current tab
    
    // Sorting function
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
    
    // Predicate function for filtering
    func buildPredicate() -> NSPredicate {
        var predicates: [NSPredicate] = []
        
        // Add predicate for search text
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }
        
        // Add predicate for category filtering
        if let category = selectedCategory {
            predicates.append(NSPredicate(format: "category ==[cd] %@", category))
        }
        
        // Combine predicates
        if predicates.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    
    // Check if data is present in Core Data
    func isDataPresent() -> Bool {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.fetchLimit = 1
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking data presence: \(error)")
            return false
        }
    }
    
    // Fetch menu data from server and save to Core Data
    func getMenuData() {
        
        // Check if data is already present
        if isDataPresent() {
            print("Data already present, skipping fetch.")
            return
        }
        
        // Clear the existing data from Core Data
        PersistenceController.shared.clear()
        
        // Server URL
        let serverUrl = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let url = URL(string: serverUrl) else {
            print("Invalid URL")
            return
        }
        
        // Create a URLRequest
        let request = URLRequest(url: url)
        
        // Fetch menu data
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for network errors
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            // Check for valid response and data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Try decoding the response
            do {
                let decoder = JSONDecoder()
                let menuList = try decoder.decode(MenuList.self, from: data)
                
                // Map MenuItems to Dish objects and save them to Core Data
                for menuItem in menuList.menu {
                    let dish = Dish(context: viewContext)
                    dish.title = menuItem.title
                    dish.image = menuItem.image
                    dish.price = menuItem.price
                    dish.description1 = menuItem.description
                    dish.category = menuItem.category
                }
                
                // Save context after mapping
                try viewContext.save()
            } catch {
                print("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func toggleCategorySelection(_ category: String) {
        if selectedCategory == category {
            selectedCategory = nil // Deselect if it's already selected
        } else {
            selectedCategory = category // Set the selected category
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Background Rectangle
                ZStack {
                    Rectangle()
                        .fill(Color.primaryColor1) // Change to your desired color
                        .frame(height: 290) // Fixed height
                        .edgesIgnoringSafeArea(.horizontal) // Edge to edge
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                
                                Text(HeroDetails.heading.rawValue)
                                    .font(Font.custom("MarkaziText-Regular", size: 48))
                                    .foregroundColor(.primaryColor2)
                                Text(HeroDetails.location.rawValue)
                                    .font(Font.custom("MarkaziText-Regular", size: 34))
                                    .foregroundColor(.white)
                                Text(" ")
                                Text(HeroDetails.description.rawValue)
                                    .font(Font.custom("Karla-Regular", size: 16))
                                    .foregroundColor(.white)
                            }
                            .padding(.leading) // Add padding to the left
                            
                            Spacer() // Push the image to the right
                            
                            Image("heroImage") // Placeholder image, change to your image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 140) // Image size
                                .cornerRadius(10)
                                .padding(.trailing) // Add padding to the right
                            
                            
                        }
                        .padding(.vertical) // Vertical padding for HStack
                        
                        // Search bar for filtering dishes
                        TextField("🔎 Type here to search menu", text: $searchText)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                .padding(.top) // Add top padding if needed
                .background(Color.white) // Background color for the entire view
                .overlay(
                    VStack {
                        Spacer()
                    }
                )
                
                Text("ORDER FOR DELIVERY !")
                    .font(Font.custom("Karla-Bold", size: 20))
                    .padding(.trailing, 120)
                
                HStack {
                    Button("Starters") {
                        toggleCategorySelection("starters")
                    }
                    .buttonStyle(MonospacedButtonStyle(isSelected: selectedCategory == "starters"))
                    
                    
                    Button("Mains") {
                        toggleCategorySelection("mains")
                    }
                    .buttonStyle(MonospacedButtonStyle(isSelected: selectedCategory == "mains"))
                    
                    Button("Desserts") {
                        toggleCategorySelection("desserts")
                    }
                    .buttonStyle(MonospacedButtonStyle(isSelected: selectedCategory == "desserts"))
                    
                    Button("Drinks") {
                        toggleCategorySelection("drinks")
                    }
                    .buttonStyle(MonospacedButtonStyle(isSelected: selectedCategory == "drinks"))
                    
                }
                //.buttonStyle(MonospacedButtonStyle())
                
                
                // Display the fetched dishes
                FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List {
                        ForEach(dishes) { dish in
                            HStack {
                                // Display dish title and price safely
                                VStack(alignment: .leading) {
                                    Text("\(dish.title ?? "No Title")")
                                        .font(Font.custom("Karla-bold", size: 18))
                                    
                                    Text("\(dish.description1 ?? "No Description")")
                                        .font(Font.custom("Karla-Regular", size: 14))
                                        .foregroundColor(.highlightColor2)
                                        .lineLimit(2)
                                    Text(" ")
                                    Text("$\(dish.price ?? "$$$" )")
                                        .font(Font.custom("Karla-Regular", size: 16))
                                    
                                }
                                Spacer()
                                // Display dish image safely
                                if let imageUrl = dish.image, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .border(Color.gray)
                                                .padding(.trailing)
                                            
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .border(Color.gray)
                                                .cornerRadius(10)
                                                .padding(.trailing)
                                            
                                        case .failure:
                                            Text("No image available")
                                                .frame(width: 100, height: 100)
                                                .border(Color.gray)
                                                .padding(.trailing)
                                            
                                        @unknown default:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .border(Color.gray)
                                                .padding(.trailing)
                                        }
                                    }
                                } else {
                                    // Fallback image for missing image URL
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .border(Color.gray)
                                        .padding(.trailing)
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Call getMenuData when the view appears, but dont repeat
                if !hasFetchedData {
                    getMenuData()
                    hasFetchedData = true
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        UserProfile(isLoggedIn: $isLoggedIn, selectedTab: $selectedTab)
                        
                    } label:   {
                        Image("profile-image-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 180, height: 40)
                }
                
            }
        }
    }
}

#Preview {
    Menu()
}



