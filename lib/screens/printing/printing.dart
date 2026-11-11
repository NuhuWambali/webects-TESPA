//
//
//
// Future<void> _goPrint() async {
//   String resultValue;
//   int returnedValue = 0;
//   try {
//     final int result = await platform.invokeMethod('goPrint', toNativeCollection);
//     resultValue = 'printer result $result % .';
//     returnedValue = result;
//     // _resultValue = returnedValue;
//     // setState(() {
//     //   printPosStatus = returnedValue;
//     //   print('Printing POS Result Issssssss: '+printPosStatus.toString());
//     // });
//   } on PlatformException catch (e) {
//     resultValue = "Failed to print: '${e.message}'.";
//   }
//
//   // print("RESUUUULLLLTTTTT VALUUUEEE ISSSS: "+_resultValue.toString());
// }
//
//
