import 'package:cryptotracker/models/Cryptocurrency.dart';
import 'package:cryptotracker/pages/DetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Market Cap Leaders ',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Text(
              //   'Leaders',
              //   style: TextStyle(
              //     fontSize: 35,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Expanded(
                child: Consumer<MarketProvider>(
                  builder: (context, marketProvider, child) {
                    if (marketProvider.isLoading == true) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (marketProvider.markets.length > 0) {
                        return ListView.builder(
                          itemCount: marketProvider.markets.length,
                          itemBuilder: (context, index) {
                            CryptoCurrency currentCrypto = marketProvider.markets[index];
                            return ListTile(
                              onTap: (){
                                Navigator.push(
                                    context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                      id: currentCrypto.id!,
                                    )
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.all(0),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(currentCrypto.image!),
                              ),
                              title: Text(currentCrypto.name!),
                              subtitle: Text(currentCrypto.symbol!.toUpperCase()),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("₹" + currentCrypto.currentPrice!.toStringAsFixed(4),
                                  style: TextStyle(
                                    color: Color(0xff0395ab),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),),
                                  Builder(
                                    builder: (context) {
                                      double priceChange = currentCrypto.priceChange24!;
                                      double priceChangePercentage = currentCrypto.
                                      priceChangePercentage24!;
                                      if(priceChange < 0 ){
                                        // nagative
                                        return Text("${priceChangePercentage.toStringAsFixed(2)}%"
                                            " (${priceChange.toStringAsFixed(4)})", style: TextStyle
                                          (
                                          color: Colors.red
                                        ),);
                                      }
                                      else{
                                        // poitive
                                        return Text("+${priceChangePercentage.toStringAsFixed(2)}%"
                                            " (+${priceChange.toStringAsFixed(4)})", style: TextStyle
                                          (
                                            color: Colors.green
                                        ),);
                                      }

                                    },
                                  ),
                                ],
                              ),

                            );
                          },
                        );
                      } else {
                        return Text("Data not found!");
                       }
                     }
                        },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}