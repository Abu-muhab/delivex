class Order {
  String from;
  String to;
  String fromLocationName;
  String toLocationName;
  String fromContact;
  String toContact;

  Order(
      {this.from,
      this.fromContact,
      this.fromLocationName,
      this.to,
      this.toContact,
      this.toLocationName});

  factory Order.fromJson(Map json) {
    return Order(
      from: json['from'],
      to: json['to'],
      fromContact: json['fromContact'],
      fromLocationName: json['fromLocationName'],
      toContact: json['toContact'],
      toLocationName: json['toLocationName'],
    );
  }
}
