class ReservationModel {

  final int reservationId;
  final String customerName;
  final String productName;
  final double quantity;
  final String status;

  ReservationModel({

    required this.reservationId,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.status,

  });

  factory ReservationModel.fromJson(Map<String,dynamic> json){

    return ReservationModel(

      reservationId:
      int.parse(json["reservation_id"].toString()),

      customerName:
      json["customer_name"],

      productName:
      json["product_name"],

      quantity:
      double.parse(json["quantity"].toString()),

      status:
      json["status"],

    );

  }

}