class HttpException implements Exception{
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    
    return message;
    //  super.toString(); //this will output instance of HttpException
  }

}
// class NotType implements Exception{
//   final String message;
//   NotType(this.message);

//   @override
//   String toString() {
    
//     return message;
//     //  super.toString(); //this will output instance of HttpException
//   }

// }