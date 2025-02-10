//
//  File.swift
//  tip-calculator
//
//  Created by Yasir on 14/11/2024.
//

import SwiftUI


struct CalHomeView : View {
    
    var body: some View {
        
        ZStack {
        
           Color(uiColor: ThemeColors.bg).edgesIgnoringSafeArea(.all)
            
            VStack(spacing:15) {
                
                TopHeaderView()
                
                
                ResultViewSUI()
                    //.padding()
                    //.background(.white)
                    .frame(width:UIScreen.main.bounds.width - 40,
                           height:UIScreen.main.bounds.height * 0.26)
                    //.shadow(color: .black, radius: 20)
                
                
                TipInputViewS(textFieldText: "")
                    .frame(width:UIScreen.main.bounds.width - 40,
                           height:UIScreen.main.bounds.height * 0.065)
                
                
                PercentInputView()
                
                
                SplitViewS()

                //Spacer()
            }
            
        }
    }
}

struct CalHomeView_Preview: PreviewProvider {
    static var previews: some View {
        CalHomeView()
    }
}

//==================================================================

struct SplitViewS : View {
    var body: some View {
        
        
        HStack {
        
            SubHorizontalHeader(title1:"Split", title2:"The total")
                
            HStack {
                    
                //BUTTON -
                
                Button {
                    
                } label: {
                    Text("-")
                        .font(Font(AppFont.bold(20)))
                        .padding()
                }.background(Color(uiColor:ThemeColors.primary))
                    .foregroundColor(.white)
                
                
                Text("2")
                    .foregroundColor(.black)
                    .font(Font(AppFont.bold(40)))
                
                
                //BUTTON +
                Button {
                    
                } label: {
                    Text("+")
                        .font(Font(AppFont.bold(20)))
                        .padding()
                }.background(Color(uiColor:ThemeColors.primary))
                    .foregroundColor(.white)
                    
            }
        }
    }
}





struct PercentInputView : View {
    var body: some View {
        
        HStack  {
            
            SubHorizontalHeader(title1:"Choose", title2:"Your Tip")

            VStack {
                
                HStack{
                    //Three Buttons
                    //BUTTON 10%
                    Button {
                        
                    } label: {
                        Text("10%")
                            .foregroundColor(.white)
                        
                    }.font(Font(AppFont.bold(20)))
                        .frame(width:70, height:60)
                        .background(Color(uiColor: ThemeColors.primary))
                        .cornerRadius(5)
                    
                    
                    
                    //BUTTON 15%
                    Button {
                        
                    } label: {
                        Text("15%")
                            .foregroundColor(.white)
                        
                    }.font(Font(AppFont.bold(20)))
                        .frame(width:70, height:60)
                        .background(Color(uiColor: ThemeColors.primary))
                        .cornerRadius(5)
                    
                    
                    //BUTTON 20%
                    Button {
                        
                    } label: {
                        Text("20%")
                            .foregroundColor(.white)
                        
                    }.font(Font(AppFont.bold(20)))
                        .frame(width:70, height:60)
                        .background(Color(uiColor: ThemeColors.primary))
                        .cornerRadius(5)
                }
                
                //CUSTOME TIP BUTTON
                
                Button {
                
                } label: {
                    Text("Custom Tip")
                        .foregroundColor(.white)
                        
                }.font(Font(AppFont.bold(20)))
                    .frame(width:220, height:60)
                    .background(Color(uiColor: ThemeColors.primary))
                    .cornerRadius(5)

            }
            
        }
    }
}


struct TipInputViewS : View {
    
    @State var textFieldText : String
    
    var body: some View {
        HStack(spacing:15.0){
            
            SubHorizontalHeader(title1:"Enter", title2:"Your bill")
            
            HStack{
                
                Text("$")
                    .font(Font(AppFont.bold(24)))
                
                TextField("Type...", text: $textFieldText)
                    .keyboardType(.decimalPad)
                    .foregroundColor(Color(uiColor: ThemeColors.text))
                    .font(Font(AppFont.bold(18)))
            }
            .frame(height:UIScreen.main.bounds.height * 0.065)
            .background(Color(uiColor:.white))
            
            
        }
        
    }
}



struct TopHeaderView : View {
    //HEADER VIEW
    var body: some View {
        HStack(alignment:.center){
            Image("icCalculatorBW").resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 80)
                
            VStack(alignment:.leading){
                HStack(alignment:.center){
                    Text("Mr")
                        .font(Font(AppFont.bold(16)))
                    Text("TIP")
                        .font(Font(AppFont.bold(20)))
                }
                Text("Calculator")
                    .font(Font(AppFont.bold(20)))
            }
        }
        
    }
}



struct ResultViewSUI : View {
    var body: some View {
        //RESTULT VIEW
        ZStack {
            
            Color(uiColor:.white)
            
            VStack (spacing:15){
                Text("Total per person")
                    .font(Font(AppFont.demibold(20)))
                
                MoneyRep(moneyAmount: "0000", prefixFontSize: 24.0, postFixFontSize: 48.0, colorIn: ThemeColors.text)
                
                
                HStack () {
                    Spacer()
                    BillWithAmount(text: "Total bill", amount: "0000")
                    Spacer()
                    BillWithAmount(text: "Total tip", amount: "0000")
                    Spacer()
                }
            }
        }
    }
}




struct BillWithAmount : View {
    
    var text:String
    var amount:String
    
    var body: some View {
        VStack{
            
            Text(text).font(Font(AppFont.bold(18)))

            /*HStack (alignment:.bottom, spacing:0){
                Text("$").font(Font(AppFont.demibold(14)))
                Text(amount).font(Font(AppFont.demibold(20)))
            }*/
            
            MoneyRep(moneyAmount:"0000", prefixFontSize:14.0,postFixFontSize: 20.0, colorIn: ThemeColors.primary)
            
        }
    }
}

struct SubHorizontalHeader : View {
    
    var title1 :String
    var title2 :String
    
    var body: some View {
        VStack (alignment:.leading){
            Text(title1)
                .font(Font(AppFont.bold(16)))
            Text(title2)
                .font(Font(AppFont.regular(16)))
        }
    }
}


struct MoneyRep : View {
    
    var moneyAmount : String
    
    var prefixFontSize : CGFloat
    var postFixFontSize: CGFloat
    var colorIn : UIColor
    
    var body: some View{
        HStack (alignment:.bottom, spacing:0){
            //Text("$").font(Font(AppFont.demibold(14)))
            //Text(moneyAmount).font(Font(AppFont.demibold(20)))
            Text("$").font(Font(AppFont.demibold(prefixFontSize)))
                .foregroundColor(Color(uiColor: colorIn))
            
            Text(moneyAmount).font(Font(AppFont.demibold(postFixFontSize)))
                .foregroundColor(Color(uiColor: colorIn))
        }
    }
}
