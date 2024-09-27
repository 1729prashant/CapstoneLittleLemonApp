//
//  Menu.swift
//  LittleLemonApp
//
//  Created by Prashant V Gaikar on 26/09/24.
//
import SwiftUI
import CoreData

struct Menu: View {

    @Environment(\.managedObjectContext) private var viewContext
    @State private var menuItems: [MenuItem] = [] // For fetched menu items
    @State private var searchText = ""

    // Sorting function
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }

    // Predicate function for filtering
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }

    // Fetch menu data from server and save to Core Data
    func getMenuData() {
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
                }

                // Save context after mapping
                try viewContext.save()
            } catch {
                print("Decoding error: \(error)")
            }
        }

        task.resume()
    }

    var body: some View {
        VStack {
            Text("Little Lemon")
            Text("Location")
            Text("A short description of the whole application below the previous two fields")

            // Search bar for filtering dishes
            TextField("Search menu", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Display the fetched dishes
            FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            // Display dish title and price safely
                            Text("\(dish.title ?? "No Title") - $\(dish.price ?? "NA")")

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
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .border(Color.gray)
                                            .cornerRadius(10)
                                    case .failure:
                                        Text("No image available")
                                            .frame(width: 100, height: 100)
                                            .border(Color.gray)
                                    @unknown default:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .border(Color.gray)
                                    }
                                }
                            } else {
                                // Fallback image for missing image URL
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .border(Color.gray)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            // Call getMenuData when the view appears
            getMenuData()
        }
    }
}

#Preview {
    Menu()
}
