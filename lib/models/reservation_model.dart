class ReservationModel {
  final int reservationId;
  final String? cartId;
  final String customerName;
  final String productName;
  final String image;
  final double quantity;
  final String status;

  ReservationModel({
    required this.reservationId,
    this.cartId,
    required this.customerName,
    required this.productName,
    required this.image,
    required this.quantity,
    required this.status,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      reservationId: int.parse(json["reservation_id"].toString()),
      cartId: json["cart_id"]?.toString(),
      customerName: json["customer_name"],
      productName: json["product_name"],
      image: json["image"] ?? "",
      quantity: double.parse(json["quantity"].toString()),
      status: json["status"],
    );
  }
}