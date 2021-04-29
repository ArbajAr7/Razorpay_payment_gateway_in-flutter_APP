import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Testing',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int totalAmount = 0;
  Razorpay _razorpay;
  @override
  void initState() {;
  super.initState();
  _razorpay = Razorpay();
  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  void openCheckout() async{
    var options={
      'key':'rzp_live_5TdMdtIYB2MizI',
      'amount': totalAmount*100,
      'name':'Politechs',
      'description':'Bill Amount',
      'prefill':{'contact':'', 'email':'',},
      'external':{
        'wallets':['paytm']
      }

    };
    try{
      _razorpay.open(options);
    }
    catch(e){
      debugPrint(e);
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: "+ response.paymentId);
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR: "+ response.code.toString()+"-"+ response.message);
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL WALLET: "+ response.walletName);
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 5,
          backgroundColor: Colors.green,
          title: Text('Payment Testing-by Arbaj '),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LimitedBox(
               maxWidth: 150.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Amount",
                  ),
                  onChanged: (value){
                    setState(() {
                      totalAmount = num.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  openCheckout();
                },
                elevation: 5,
                color: Colors.red,
                child: Text(
                  "Pay now",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
