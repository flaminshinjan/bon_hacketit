

import SwiftUI

struct Home: View {
    @State var currentIndex: Int = 0
    @State var currentTab: Tab = tabs[1]
    @Namespace var animation
    @State var selectedMilkShake: MilkShake?
    @State var showDetail: Bool = false
    var body: some View {
        VStack{
            HeaderView()
            VStack(alignment: .leading, spacing: 8) {
                Text(attributedTitle)
                    .font(.largeTitle.bold())
                Text(attributedSubTitle)
                    .font(.largeTitle.bold())
            }
            .padding(.horizontal,15)
            .frame(maxWidth: .infinity,alignment: .leading)
            .opacity(showDetail ? 0 : 1)
            
            GeometryReader{proxy in
                let size = proxy.size
                CarouselView(size: size)
            }
            .zIndex(-10)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .overlay(content: {
            if let selectedMilkShake,showDetail{
                DetailView(animation: animation, milkShake: selectedMilkShake, show: $showDetail)
            }
        })
        .background {
            Color("LightGreen")
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func CarouselView(size: CGSize)->some View{
        VStack(spacing: -40){
            CustomCarousel(index: $currentIndex, items: milkShakes, spacing: 0, cardPadding: size.width / 3, id: \.id) { milkShake, _ in
                VStack(spacing: 10){
                    ZStack{
                        if showDetail && selectedMilkShake?.id == milkShake.id{
                            Image(milkShake.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.init(degrees: -2))
                                .opacity(0)
                        }else{
                            Image(milkShake.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.init(degrees: -2))
                                .matchedGeometryEffect(id: milkShake.id, in: animation)
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: size.height / 10, style: .continuous)
                            .fill(Color("LightGreen-1"))
                            .padding(.top,40)
                            .padding(.horizontal,-40)
                            .offset(y: -10)
                    }
                    
                    Text(milkShake.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.top,8)
                    
                    Text(milkShake.price)
                        .font(.callout)
                        .fontWeight(.black)
                        .foregroundColor(Color("LightGreen"))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                        selectedMilkShake = milkShake
                        showDetail = true
                    }
                }
            }
            .frame(height: size.height * 0.8)
            
            Indicators()
                .padding(.bottom,8)
        }
        .frame(width: size.width, height: size.height, alignment: .bottom)
        .opacity(showDetail ? 0 : 1)
        .background {
            CustomArcShape()
                .fill(.white)
                .scaleEffect(showDetail ? 1.8 : 1, anchor: .bottomLeading)
                .overlay(alignment: .topLeading, content: {
                    TabMenu()
                        .opacity(showDetail ? 0 : 1)
                })
                .padding(.top,40)
                .ignoresSafeArea()
        }
    }
    @ViewBuilder
    func TabMenu()->some View{
        HStack(spacing: 30){
            ForEach(tabs){tab in
                Image(tab.tabImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 50)
                    .padding(10)
                    .background {
                        Circle()
                            .fill(Color("LightGreen-1"))
                    }
                    .background(content: {
                        Circle()
                            .fill(.white)
                            .padding(-2)
                    })
                    .shadow(color: .black.opacity(0.07), radius: 5, x: 5, y: 5)
                    .offset(tab.tabOffset)
                    .scaleEffect(currentTab.id == tab.id ? 1.15 : 0.94, anchor: .bottom)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            currentTab = tab
                        }
                    }
            }
        }
        .padding(.leading,15)
    }
    
    // MARK: Indicators
    @ViewBuilder
    func Indicators()->some View{
        HStack(spacing: 2){
            ForEach(milkShakes.indices,id: \.self){index in
                Circle()
                    .fill(Color("LightGreen"))
                    .frame(width: currentIndex == index ? 10 : 6, height: currentIndex == index ? 10 : 6)
                    .padding(4)
                    .background {
                        if currentIndex == index{
                            Circle()
                                .stroke(Color("LightGreen"),lineWidth: 1)
                                .matchedGeometryEffect(id: "INDICATOR", in: animation)
                        }
                    }
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }
    @ViewBuilder
    func HeaderView()->some View{
        HStack{
            Button {
                
            } label: {
                HStack(spacing: 10){
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Text("Shinjan")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                }
                .padding(.leading,8)
                .padding(.trailing,12)
                .padding(.vertical,6)
                .background {
                    Capsule()
                        .fill(Color("LightGreen-1"))
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .opacity(showDetail ? 0 : 1)
            Button {
                
            } label: {
                Image(systemName: "sun.min.fill")
                    .font(.title2)
                    .foregroundColor(.black)
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .fill(.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 2, y: -5)
                    }
            }
        }
        .padding(15)
    }
    
    var attributedTitle: AttributedString{
        var attString = AttributedString(stringLiteral: "Recipes Rediscovered,")
        if let range = attString.range(of: "Rediscovered,"){
            attString[range].foregroundColor = .white
        }
        return attString
    }
    
    var attributedSubTitle: AttributedString{
        var attString = AttributedString(stringLiteral: "Timeless Flavors Uncovered")
        if let range = attString.range(of: "Uncovered"){
            attString[range].foregroundColor = .white
        }
        return attString
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
struct DetailView: View{
    var animation: Namespace.ID
    var milkShake: MilkShake
    @Binding var show: Bool
    @State var orderType: String = "Active Order"
    @State var showContent: Bool = false
    var body: some View{
        VStack{
            HStack{
                Button {
                    withAnimation(.easeInOut(duration: 0.35)){
                        showContent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        withAnimation(.easeInOut(duration: 0.35)){
                            show = false
                        }
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(15)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            .overlay {
                Text("Details")
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .padding(.top,7)
            .opacity(showContent ? 1 : 0)
            
            HStack(spacing: 0){
                ForEach(["Yumm!","Ingredients"],id: \.self){order in
                    Text(order)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(orderType == order ? .black : .gray)
                        .padding(.horizontal,20)
                        .padding(.vertical,10)
                        .background {
                            if orderType == order{
                                Capsule()
                                    .fill(Color("LightGreen-1"))
                                    .matchedGeometryEffect(id: "ORDERTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut){orderType = order}
                        }
                }
            }
            .padding(.leading,15)
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.bottom)
            .opacity(showContent ? 1 : 0)
            
            Image(milkShake.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.init(degrees: -2))
                .matchedGeometryEffect(id: milkShake.id, in: animation)
            
            GeometryReader{proxy in
                let size = proxy.size
                
                MilkShakeDetails()
                    .offset(y: showContent ? 0 : size.height + 50)
            }
            .padding(.vertical,10)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 0.5)))
        .onAppear {
            withAnimation(.easeInOut.delay(0.1)){
                showContent = true
            }
        }
    }
    
    // MARK: MIMIC Custom Bottom Sheet
    @ViewBuilder
    func MilkShakeDetails()->some View{
        VStack{

                Text(milkShake.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(milkShake.price)
                    .font(.callout)
                    .fontWeight(.black)
                    .foregroundColor(Color("LightGreen"))
                
                
                
                Button {
                    
                } label: {
                    Text("Show Recipe")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.horizontal,25)
                        .padding(.vertical,10)
                        .foregroundColor(.black)
                        .background {
                            Capsule()
                                .fill(Color("LightGreen"))
                        }
                }
                .padding(.top,10)
            }
            .padding(.vertical,20)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(Color("LightGreen-1"))
            }
            .padding(.horizontal,60)
        }
    }

