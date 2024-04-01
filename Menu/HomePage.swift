//
//  HomePage.swift
//  Menu
//
//  Created by Omid Shojaeian Zanjani on 31/03/24.
//

import SwiftUI
import CoreHaptics

struct HomePage: View {
    // Page properites
    @State var foodName:String = ""
    @ObservedObject var subcategory:SubCategoryPublisher = SubCategoryPublisher()
    @State private var engine: CHHapticEngine?
    @State var keyBoardHeight:CGFloat = 0
    var body: some View {
        VStack{
            HStack{
                SearchFields( heightKeyboard: $keyBoardHeight)
                FilterButton()
            }// Hstack
            .padding(.horizontal, 20)
            
            CategoryView()
                .padding(.horizontal, 20)
                .padding(.top, 20)
            ScrollView(.vertical){
                subCategoryItems()
            }
            .padding(.top, 20)
            
        }
        .onAppear(perform: {
            // Initialize the haptic engine
           do {
               self.engine = try CHHapticEngine()
               try self.engine?.start()
           } catch {
               print("Error initializing haptic engine: \(error)")
           }
        })
        .modifier(DismissingKeyboard())
    }
       
    
    @ViewBuilder
    func FilterButton()->some View {
        Button(action: {
        }, label: {
            VStack{
                Image(systemName: "slider.horizontal.3")
                    .padding()
            }
            .background(btnColor)
            .foregroundStyle(txtColor)
            .clipShape(.circle)
        })
    }// FilterButton
    
    @ViewBuilder
    func SearchFields(heightKeyboard:Binding<CGFloat>) -> some View{
        let maxHeight:CGFloat = 50.0
//        let binding = Binding<String>(get: {
//                  self.foodName
//              }, set: {
//                  self.foodName = $0
//              })
        
        HStack{
            TextField("example: Margarita ", text: $foodName)
                .padding(.horizontal, 20)
                .frame(maxHeight: maxHeight)
                .overlay {
                    RoundedRectangle(cornerRadius: maxHeight / 2.0)
                        .fill(Color.clear)
                        .stroke(Color.gray, lineWidth: 1)
                }
                .onAppear(){
                    // this part of code is only to show how can we get notified when something happen like when keyboard is opened
                    // then I used offset to change the offset of textfield to where ever I want
                    // but now I make it comment to prevent any extra errors.
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                        
                        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
                        
                        withAnimation {
                            heightKeyboard.wrappedValue = keyboardFrame.height
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                        
                        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
                        
                        withAnimation {
                            heightKeyboard.wrappedValue = .zero
                        }
                    }
                }
                //.offset(y: heightKeyboard.wrappedValue)
                .onChange(of: foodName) { newValue in
                    subcategory.filterSubCategory(words: newValue)
                }
                
                
        }
    }
    
    @ViewBuilder
    func CategoryView()->some View{
        ScrollView(.horizontal){
            HStack(spacing: 10) {
                ForEach(Category.sampleCategory, id: \.id){catItem in
                    CategoryItem(catItem)
                }
            }
        }
    }
    
    @ViewBuilder
    func CategoryItem(_ categoryItem:Category)->some View {
        VStack(spacing:10){
            Image(categoryItem.img)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(.circle)
            Text(categoryItem.type.rawValue)
                .fontWeight(.semibold)
        }
        .onTapGesture {
            withAnimation {
                subcategory.subcategoryMaker(categoty: categoryItem)
                
            }
        }
    }
    struct ColumnModel{
        var id = UUID()
        var item:GridItem
        static let columns = [
            ColumnModel(item: GridItem()),
            ColumnModel(item: GridItem())
        ]
    }
    @ViewBuilder
    func subCategoryItems()-> some View{
        let dividesSubCats:[[SubCategory]] = {
            var temp = subcategory.subCategory.separateArray(into: 2)
            
            if temp.count == 0 {
                return [[],[]]
            }else if temp.count == 1 {
                temp.append([])
                return temp
            }else{
                return temp
            }
        }()
        HStack(alignment: .top, spacing: 5) {
            ForEach(ColumnModel.columns.indices, id: \.self){ loopNum in
                VStack(spacing: 180){
                    ForEach(dividesSubCats[loopNum] , id: \.id){ item in
                        Cell(subCat: item)
                            .frame(width: 185, height: 130.0)
                            .foregroundStyle(.mint)
                        
                    }
                }
            }
        }.padding(.top, 90)
    }
    
    @ViewBuilder
    func Cell(subCat:SubCategory)-> some View {
        VStack{
            Image(subCat.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 185, height: 195)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack{
                Text(subCat.name)
                Spacer()
                Image(systemName: subCat.isFavorite ? "heart.fill":"heart")
                    .onTapGesture {
                        subcategory.toggleFavoriteItem(sub: subCat)
                        generateHapticFeedback()
                    }
            }
            .padding(.horizontal, 10)
            HStack{
                Text(subCat.category.type.rawValue)
                    .fixedSize()
                Spacer()
            }
            .padding(.horizontal, 10)
            HStack{
                Text("\(subCat.price) $")
                Spacer()
                Button(action: {
                    print("()")
                }, label: {
                    Text("order")
                        .foregroundStyle(.white)
                })
                .frame(width: 100,height: 30)
                .background(Color.green)
                
                .clipShape(.rect(cornerRadius: 10))
            }
            .padding(.horizontal, 10)
            Spacer()
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(.clear)
                .stroke(.black, style: .init(lineWidth: 1))
        }
    }
    
    func generateHapticFeedback() {
            // Check if the haptic engine is available
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

            // Create a haptic event
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)

            do {
                // Play the haptic event
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                print("Error playing haptic feedback: \(error)")
            }
        }
}
struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}


#Preview {
    HomePage()
}
